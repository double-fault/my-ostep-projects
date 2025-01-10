// Per-CPU state
struct cpu {
  uchar apicid;                // Local APIC ID
  struct context *scheduler;   // swtch() here to enter scheduler
  struct taskstate ts;         // Used by x86 to find stack for interrupt
  struct segdesc gdt[NSEGS];   // x86 global descriptor table
  volatile uint started;       // Has the CPU started?
  int ncli;                    // Depth of pushcli nesting.
  int intena;                  // Were interrupts enabled before pushcli?
  //struct proc *proc;           // The process running on this cpu or null
  struct thread *thread;             // thread running on this cpu or null
};

extern struct cpu cpus[NCPU];
extern int ncpu;

//PAGEBREAK: 17
// Saved registers for kernel context switches.
// Don't need to save all the segment registers (%cs, etc),
// because they are constant across kernel contexts.
// Don't need to save %eax, %ecx, %edx, because the
// x86 convention is that the caller has saved them.
// Contexts are stored at the bottom of the stack they
// describe; the stack pointer is the address of the context.
// The layout of the context matches the layout of the stack in swtch.S
// at the "Switch stacks" comment. Switch doesn't save eip explicitly,
// but it is on the stack and allocproc() manipulates it.
struct context {
  uint edi;
  uint esi;
  uint ebx;
  uint ebp;
  uint eip;
};

// Q: Do we need the zombie state in threads? or will the parent proc always be in the zombie state anyway?
enum thrstate { T_UNUSED, T_EMBRYO, T_ZOMBIE, T_SLEEPING, T_RUNNABLE, T_RUNNING };

// if all threads of a proc are embryos, then the proc must also be in the embryo state
enum procstate { P_UNUSED, P_EMBRYO, P_ZOMBIE, P_USED };

// Per-process state
struct proc {
  uint sz;                     // Size of process memory (bytes)
  pde_t* pgdir;                // Page table

  int thread_cnt;
  struct thread *threads[NTHR];
  enum procstate state;

  int killed;
  int pid;

  struct proc *parent;
  /*
  char *kstack;                // Bottom of kernel stack for this process
  enum procstate state;        // Process state
  int pid;                     // Process ID
  struct proc *parent;         // Parent process
  struct trapframe *tf;        // Trap frame for current syscall
  struct context *context;     // swtch() here to run process
  void *chan;                  // If non-zero, sleeping on chan
  int killed;                  // If non-zero, have been killed
                               */
  struct file *ofile[NOFILE];  // Open files
  struct inode *cwd;           // Current directory
  char name[16];               // Process name (debugging)
};

struct thread {
  char *kstack;
  enum thrstate state;
  int tid;
  struct proc *proc; // ptr to parent process - is this needed?
  struct trapframe *tf;
  struct context *context;
  void *chan;
  int killed; // thread killed vs proc killed should be separate?
  char name[16]; // thread name (for debugging?)
};

// Process memory is laid out contiguously, low addresses first:
//   text
//   original data and bss
//   fixed-size stack
//   expandable heap
