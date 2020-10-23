---
title: "Understanding Kernel is fun"
date: Thu Oct 15 08:13:33 IST 2020
tags: [build#5]
---

Bonsoir!

I was going through some of my kernel docs today and suddenly gotta mood to write on the same. If I speak in simple language, what is kernel? It is nothing but a set of code which knows how to communicate with hardwares. Linux is mostly written in C with a bit of assembly language. Actually this kernel code understands how to interpret your keypresses when you press a key and/or how to communicate with your hard drive to write bytes to it and much more. It can even speak TCP/IP.

So how we are accessing the kernel? If you are a regular terminal user, you will poke kernel time to time. Yes! it is system calls. System calls work silently in the background, interfacing with the kernel to get the job done. Regular programs that you write can interact with your computer’s hardware using system calls.

There are 2 types of modes which help us to use system calls. User mode and Kernel mode. Both are different by the factor of privileges and security. All user gets into USER MODE by default when an user session is started. And the through POSIX API we issue system calls to kernel. This is because playing with kernel mode can lead to kernel crashes and halt your PC. Unix-like systems comes with POSIX API making it available through GNU C Library to invoke a system call and woke up kernel. Technically if I go a bit deep, APIs are defined inside libc standard C library which then uses wrapper routines to issue a system call. So basically POSIX API are used in USER MODE to indirectly access system calls. System calls are just function we call directly from the code while API is just an interface to call that function indirectly.
```
Command-line utility -> Invokes functions from system libraries (glibc) -> Invokes system calls
```

So everytime you pass a system call through API in USER MODE, CPU switches to KERNEL MODE for executing the task. Simple! [Trap computing](https://en.wikipedia.org/wiki/Trap_(computing)). If you want to know which functions were called from the glibc library, ltrace is best.
```
jino@jino-ThinkPad-T450:~/tech-repo$ ltrace ls
strrchr("ls", '/')                                                                                      = nil
setlocale(LC_ALL, "")                                                                                   = "en_IN"
bindtextdomain("coreutils", "/usr/share/locale")                                                        = "/usr/share/locale"
textdomain("coreutils")                                                                                 = "coreutils"
.
.
```

Lets see yet another command which captures and records all these system calls and the signals. [Strace](https://www.youtube.com/watch?v=yWlqYsPPAyM) is among such which displays the name of each system call together with its arguments enclosed in a parenthesis and its return value to standard error, you can optionally redirect it to a file as well. 


Here I used strace to see what ls command does.
```
jino@jino-ThinkPad-T450:~/ocp/example$ strace -o output "ls"
jino  output
```

I copied the standard out to a file. Strace will output a whole bunch of crap. So I just copied what is needed. The very first line you see is execve, name of a system call being executed. Text within the parentheses is the arguments provided to the system call.
```
execve("/bin/ls", ["ls"], 0x7ffd180682d0 /* 61 vars */) = 0
```

opening libraries
```
openat(AT_FDCWD, "/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) = 3
```
This step is to put into memory.
```
mmap(NULL, 130161, PROT_READ, MAP_PRIVATE, 3, 0) = 0x7f54ea918000
```
Get contents from the required directory.
```
getdents(3, /* 4 entries */, 32768)     = 104
getdents(3, /* 0 entries */, 32768)     = 0
#close the directory
close(3)                                = 0
fstat(1, {st_mode=S_IFCHR|0620, st_rdev=makedev(136, 1), ...}) = 0
write(1, "jino  output\n", 13)          = 13
close(1)                                = 0
close(2)                                = 0
exit_group(0)                           = ?
+++ exited with 0 +++
```
Man page explains more than me. If you are intrested refer man. This is just .5%. There are a lot of stuffs that makes us interact with os like a pro. "/proc", [ftrace](http://www.brendangregg.com/blog/2014-09-06/linux-ftrace-tcp-retransmit-tracing.html), perf are some.

Kernel programming is fun if you are good at C. Am just aware of very few usages. But understands kernel now. Thats it. Have a good day.



