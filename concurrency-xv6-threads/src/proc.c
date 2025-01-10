#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "x86.h"
#include "proc.h"
#include "spinlock.h"

struct {
  struct spinlock lock;
  struct proc proc[NPROC];
  struct thread threads[NTHR];
} ptable;

// Instead of using a separate lock for ttable, maybe we just use 
// the ptable lock every time we want to modify ttable?
/*
struct {
  //struct spinlock lock;
  struct thr thr[NTHR];
} ttable;
*/

static struct proc *initproc;

//int nextpid = 1;
int nexttid = 1;
extern void forkret(void);
extern void trapret(void);

static void wakeup1(void *chan);

void
pinit(void)
{
  initlock(&ptable.lock, "ptable");
}

// Must be called with interrupts disabled
int
cpuid() {
  return mycpu()-cpus;
}

// Must be called with interrupts disabled to avoid the caller being
// rescheduled between reading lapicid and running through the loop.
struct cpu*
mycpu(void)
{
  int apicid, i;
  
  if(readeflags()&FL_IF)
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
    if (cpus[i].apicid == apicid)
      return &cpus[i];
  }
  panic("unknown apicid\n");
}

// Disable interrupts so that we are not rescheduled
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
  c = mycpu();
  if (c->thread != 0)
    p = c->thread->proc;
  else
    p = 0;
  popcli();
  return p;
}

// Disable interrupts (because myproc also requires disabling
// interrupts xD)
struct thread*
mythread(void) {
  struct cpu* c;
  struct thread* t;
  pushcli();
  c = mycpu();
  t = c->thread;
  popcli();
  return t;
}

// Looks in thread list for T_UNUSED thr
// If not found, returns 0
static struct thread*
allocthread(void)
{
  struct thread *t;
  char *sp;

  acquire(&ptable.lock);

  for (t = ptable.threads; t < &ptable.threads[NTHR]; t++)
    if (t->state == T_UNUSED)
      goto found;

  release(&ptable.lock);
  return 0;

found:
  t->state = T_EMBRYO;
  t->tid = nexttid++; 

  release(&ptable.lock);

  if ((t->kstack = kalloc()) == 0) {
    t->state = T_UNUSED;
    return 0;
  }
  sp = t->kstack + KSTACKSIZE;

  // Leaving room for trap frame
  sp -= sizeof *t->tf;
  t->tf = (struct trapframe*)sp;

  // Setting up a new context which starts executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *t->context;
  t->context = (struct context*)sp;
  memset(t->context, 0, sizeof *t->context);
  t->context->eip = (uint)forkret;

  return t;
}

//PAGEBREAK: 32
// Calls allocthread to allocate a thread.
// Checks if an T_UNUSED slot exists in the process table
// If not found or allocthread is unsuccesful, returns 0.
static struct proc*
allocproc(void)
{
  struct proc *p;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == P_UNUSED)
      goto found;

  release(&ptable.lock);
  return 0;

found:
  p->state = P_EMBRYO;
  release(&ptable.lock);

  struct thread *t;
  if ((t = allocthread()) == 0) {
    p->state = P_UNUSED;
    return 0;
  }

  p->threads[0] = t;
  t->proc = p;
  p->thread_cnt = 1;

  return p;
}

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];

  p = allocproc();
  
  initproc = p;
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
  memset(p->threads[0]->tf, 0, sizeof(*p->threads[0]->tf));
  p->threads[0]->tf->cs = (SEG_UCODE << 3) | DPL_USER;
  p->threads[0]->tf->ds = (SEG_UDATA << 3) | DPL_USER;
  p->threads[0]->tf->es = p->threads[0]->tf->ds;
  p->threads[0]->tf->ss = p->threads[0]->tf->ds;
  p->threads[0]->tf->eflags = FL_IF;
  p->threads[0]->tf->esp = PGSIZE;
  p->threads[0]->tf->eip = 0;  // beginning of initcode.S

  safestrcpy(p->name, "initcode", sizeof(p->name));
  safestrcpy(p->threads[0]->name, "initthr", sizeof(p->threads[0]->name));
  p->cwd = namei("/");

  // this assignment to p->state lets other cores
  // run this process. the acquire forces the above
  // writes to be visible, and the lock is also needed
  // because the assignment might not be atomic.
  acquire(&ptable.lock);

  p->state = P_USED;
  p->threads[0]->state = T_RUNNABLE;

  release(&ptable.lock);
}

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
  uint sz;
  struct thread *t = mythread();
  struct proc *curproc = t->proc;

  sz = curproc->sz;
  if(n > 0){
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  } else if(n < 0){
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  curproc->sz = sz;
  switchuvm(t);
  return 0;
}

// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to T_RUNNABLE.
// Process MUST have only a single thread, or else fork
// fails.
int
fork(void)
{
  int i, pid;
  struct proc *np;
  struct proc *curproc = myproc();

  if (curproc->thread_cnt > 1)
    return -1;

  // Allocate process.
  if((np = allocproc()) == 0){
    return -1;
  }

  // Copy process state from proc.
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
    kfree(np->threads[0]->kstack);
    np->threads[0]->kstack = 0;
    np->threads[0]->state = T_UNUSED;
    np->state = P_UNUSED;
    return -1;
  }
  np->sz = curproc->sz;
  np->parent = curproc;
  *np->threads[0]->tf = *curproc->threads[0]->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->threads[0]->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
  safestrcpy(np->threads[0]->name, curproc->threads[0]->name, sizeof(curproc->threads[0]->name));

  np->pid = np->threads[0]->tid;
  pid = np->pid;

  acquire(&ptable.lock);

  np->state = P_USED;
  np->threads[0]->state = T_RUNNABLE;

  release(&ptable.lock);

  return pid;
}

//clones current process to create a new proc which shares the address space
//but has a separate stack pointed to at by stack
//new process continues at passed func ptr with args arg1, arg2
/*
int
clone(int (*fn)(void*, void*), void* arg1, void* arg2, void* stack) 
{
  int i, pid;
  struct proc *np;
  struct proc *curproc = myproc();

  //Allocate new process (thread)
  if ((np = allocproc()) == 0) {
    return -1;
  }

  np->pgdir = curproc->pgdir; // cloned process has same pgdir as curproc
  np->sz = curproc->sz;
  np->parent = curproc;
  */

// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
  struct proc *curproc = myproc();
  struct proc *p;
  int fd;

  if(curproc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd]){
      fileclose(curproc->ofile[fd]);
      curproc->ofile[fd] = 0;
    }
  }

  begin_op();
  iput(curproc->cwd);
  end_op();
  curproc->cwd = 0;

  acquire(&ptable.lock);

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == curproc){
      p->parent = initproc;
      if(p->state == P_ZOMBIE)
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  curproc->state = P_ZOMBIE;
  for (int i = 0; i < curproc->thread_cnt; i++)
    curproc->threads[i]->state = T_ZOMBIE;

  sched();
  panic("zombie exit");
}

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
  struct proc *p;
  int havekids, pid;
  struct proc *curproc = myproc();
  
  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->parent != curproc)
        continue;
      havekids = 1;
      if(p->state == P_ZOMBIE){
        // Found one.
        pid = p->pid;

        for (int i = 0; i < p->thread_cnt; i++) {
          struct thread *t = p->threads[i];
          kfree(t->kstack);
          t->kstack = 0;
          t->tid = 0;
          t->proc = 0;
          t->name[0] = 0;
          t->state = T_UNUSED;
          t->killed = 0;
        }
        freevm(p->pgdir);
        p->pid = 0;
        p->parent = 0;
        p->name[0] = 0;
        p->killed = 0;
        p->state = P_UNUSED;
        release(&ptable.lock);
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
      release(&ptable.lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}

//PAGEBREAK: 42
// Per-CPU process scheduler.
// Each CPU calls scheduler() after setting itself up.
// Scheduler never returns.  It loops, doing:
//  - choose a process to run
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
  struct proc *p;
  struct cpu *c = mycpu();
  c->thread = 0;
  
  for(;;){
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->state != P_USED)
        continue;

      // Use the current ticks as a lottery mechanism to 
      // pick which thread must be run
      int pick = ticks % p->thread_cnt;
      struct thread *t = p->threads[pick];

      // Switch to chosen thread.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->thread = t;
      switchuvm(t);
      t->state = T_RUNNING;

      swtch(&(c->scheduler), t->context);
      switchkvm();

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->thread = 0;
    }
    release(&ptable.lock);

  }
}

// Enter scheduler.  Must hold only ptable.lock
// and have changed proc->state. Saves and restores
// intena because intena is a property of this
// kernel thread, not this CPU. It should
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void)
{
  int intena;
  struct thread *t = mythread();

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
    panic("sched locks");
  if(t->state == T_RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  intena = mycpu()->intena;
  swtch(&t->context, mycpu()->scheduler);
  mycpu()->intena = intena;
}

// Give up the CPU for one scheduling round.
void
yield(void)
{
  acquire(&ptable.lock);  //DOC: yieldlock
  mythread()->state = T_RUNNABLE;
  sched();
  release(&ptable.lock);
}

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);

  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
  struct thread *t = mythread();
  
  if(t == 0)
    panic("sleep");

  if(lk == 0)
    panic("sleep without lk");

  // Must acquire ptable.lock in order to
  // change t->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
    acquire(&ptable.lock);  //DOC: sleeplock1
    release(lk);
  }
  // Go to sleep.
  t->chan = chan;
  t->state = T_SLEEPING;

  sched();

  // Tidy up.
  t->chan = 0;

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
  }
}

//PAGEBREAK!
// Wake up all threads sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
  struct thread *t;

  for(t = ptable.threads; t < &ptable.threads[NTHR]; t++)
    if(t->state == T_SLEEPING && t->chan == chan)
      t->state = T_RUNNABLE;
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
}

// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
      // TODO: do this but for threads?
      /*
      // Wake process from sleep if necessary.
      if(p->state == T_SLEEPING)
        p->state = T_RUNNABLE;
        */
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}

//PAGEBREAK: 36
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
  static char *states[] = {
  [T_UNUSED]    "unused",
  [T_EMBRYO]    "embryo",
  [T_SLEEPING]  "sleep ",
  [T_RUNNABLE]  "runble",
  [T_RUNNING]   "run   "
  };
  int i;
  struct thread *t;
  char *state;
  uint pc[10];

  for(t = ptable.threads; t < &ptable.threads[NTHR]; t++){
    if(t->state == T_UNUSED)
      continue;
    if(t->state >= 0 && t->state < NELEM(states) && states[t->state])
      state = states[t->state];
    else
      state = "???";
    cprintf("%d %s %s", t->tid, state, t->name);
    if(t->state == T_SLEEPING){
      getcallerpcs((uint*)t->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}
