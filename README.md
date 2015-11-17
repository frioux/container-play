Here is an example of using Linux Namespaces (not Docker) to ensure that child
processes get killed when the parent process dies.

### The Problem

First, to see the problem, in Terminal 1 run `./orphans.sh`.  You should see
output something like this:

```
Parent: 52044
Child 1: 52045
Child 2: 52046
Child 3: 52047
Child 4: 52048
```

You can `./watch.sh` to see the processes "live" in Terminal 2; it looks like
this on my machine:

```
Every 0.3s: pstree -Up | grep dash   Tue Nov 17 15:30:55 2015

           │            ├─zsh(238906)───orphans.sh(52044)─┬─dash(52045)───sleep(54516)
           │            │                                 ├─dash(52046)───sleep(54513)
           │            │                                 ├─dash(52047)───sleep(54517)
           │            │                                 ├─dash(52048)───sleep(54515)
```

Now go back to Terminal 1 and press Ctrl+C.  Terminal 2 should now look
something like this:

```
Every 0.3s: pstree -Up | grep dash   Tue Nov 17 15:32:12 2015

           ├─dash(52045)───sleep(55926)
           ├─dash(52046)───sleep(55927)
           ├─dash(52047)───sleep(55924)
           ├─dash(52048)───sleep(55925)

```

Note that those processes have been orphaned.  They are running directly under
init.  There are ways to have them receive a `SIGHUP` if the session leader
exits, but `SIGHUP` can be captured and ignored.  You can kill all of those
processes either by doing `killall -5 dash` or if there are other dash processes
running, `kill -5 5204{5,6,7,8}`.

### The Solution

Linux Namespaces have become commonly used via Docker, but Docker solves a
**lot** of problems and this problem can be solved much more simply with a
smaller tool that in fact makes only a handful of system calls, instead of
implementing a lightweight VM.

Run `./contained-orphans.sh` in Terminal 1.  You will almost certainly see
exactly:

```
Parent: 1
Child 1: 2
Child 2: 3
Child 3: 6
Child 4: 7
```

Now back in Terminal 2 you will see something like:

```
Every 0.3s: pstree -Up | grep dash   Tue Nov 17 15:43:06 2015

           │            ├─zsh(238906)───unshare(62792)───dash(62793)─┬─dash(62794)───sleep(64213)
           │            │                                            ├─dash(62795)───sleep(64211)
           │            │                                            ├─dash(62798)───sleep(64212)
           │            │                                            ├─dash(62799)───sleep(64210)

```

Go back to Terminal 1 and press Ctrl+c.  Terminal 2 will be completely blank.
