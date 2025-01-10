# xv6 kernel threads

An attempt at implementing kernel threads in xv6.

Some notes/questions along the way:

 - The function pointer passed into `clone` has a size of 4 bytes so can just use `argptr` - the size of func. ptrs seems to be platform dependent, but well, if it is 4 bytes here I will just use `argptr` and call it a day.
 - Implement TLB shootdown maybe? Too complicated for me probably.
