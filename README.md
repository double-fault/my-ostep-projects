# ostep-projects

An attempt at various ostep-projects.

questions todo:

1. In the scheduler why switch to the kernel pgdir at all, i.e why even do `switchkvm`.. seems to be running fine even without it.
2. If you are restricted to one CPU do you even need the lock on ptable?
3. We do `kinit1` and `kinit2` because of blah blah blah whatever reasons -- but can we not just directly map everything in one step, since after all we can just directly write to the phy addresses (just subtract KERNBASE type shit) - so just make your free list in one step? 
4. Upon doing an objdump -h on an executable, why do the debug sections have a non-zero size?
5. printfs from inside kernel code..? 

