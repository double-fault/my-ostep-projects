#include "types.h"
#include "stat.h"
#include "user.h"
#include "fs.h"

int
main(int argc, char *argv[])
{
  int pid = getpid();

  printf(1, "If you don't see a \"test failed\" somewhere, then it succeeds. Page fault is trap 14.\n");

  int *p = (int*)0x1000;
  *p = 69;
  printf(1, "[pid %d] value at 0x1000: %d\n", pid, *p);

  if (mprotect((void*)p, 3) < 0) {
    printf(1, "[pid %d] test failed\n", pid);
    exit();
  }

  printf(1, "[pid %d] 3 pages starting at 0x1000 protected.\n", pid);

  int rc = fork();
  if (rc < 0) {
    printf(1, "test failed\n");
    exit();
  } else if (rc > 0) {
    printf(1, "[pid %d] child is %d, exiting.\n", pid, rc);
    if (wait() < 0) 
            printf(1, "[pid %d] test failed.\n", pid);
    exit();
  }

  pid = getpid();

  rc = fork();
  if (rc < 0) {
    printf(1, "test failed\n");
    exit();
  } else if (rc == 0) {
    pid = getpid();
    printf(1, "[pid %d] trying to write at 0x3001, should cause a page fault.\n", pid);
    p = (int*) 0x3001;
    *p = 69;

    printf(1, "[pid %d] test failed.\n", pid);
    exit();
  } else {
    printf(1, "[pid %d] child is %d\n", pid, rc);
  }

  if (munprotect((void*)0x3000, 4) < 0) {
    printf(1, "[pid %d] test failed.\n", pid); 
  }

  p = (int*) 0x3001;
  printf(1, "[pid %d] trying to write at 0x3001, should work.\n", pid);
  *p = 69;
  printf(1, "[pid %d] value at 0x3001: %d\n", pid, *p);

  if (wait() < 0) 
          printf(1, "[pid %d] test failed.\n", pid);

  printf(1, "[pid %d] writing to 0x2FFF should cause a page fault.\n", pid);

  p = (int*) 0x2FFF;
  *p = 69;

  printf(1, "[pid %d] test failed.\n", pid);

  exit();
}
