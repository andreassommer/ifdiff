# Speedtracker: Performance Regression Testing

## What is Speedtracker?
Speedtracker is a module within IFDIFF for testing for long-term performance
regressions. It tracks versions of the project's development, as well as
performance benchmarks. When invoked, it successively loads each snapshot,
runs the benchmarks on that snapshot, and collects the results.

## Goals and Requirements
Speedtracker is intended to track long-term deteriorations in the performance
due to inefficiencies accidentally introduced into the code. This and
the small and fluctuating development team mean that we cannot rely
on a pristine, consistent testing environment: Two benchmarking runs
six months apart may produce different results solely because
the tester's computer got slowed down by software bloat. Therefore,
every benchmarking run must compare all snapshots on the local
machine, in the moment it is performed.  
  
Another requirement is to avoid the use of extra software because there
is nobody to manage it. Speedtracker should be callable from within
MATLAB :registered: and use only MATLAB, OS commands, and Git.  
  
Speedtracker aims to be compatible with Windows and Linux.  
  
Users are assumed to be decently familiar with MATLAB, IFDIFF, and Git.  
  
TODO: determine how benchmarking results should be collected/visualized.

## Use Instructions
Refer to `instructions.odt` for instructions. These instructions double
as a description of the module's functionality, so reading them (now)
may be a good starting point to understanding how it works. The code structure is
documented in `structure.odt`. Read this before you make any changes; the structure
and conventions are not self-explanatory.

## Development Process
This is hopefully going to remain a small module, allowing us to
stick to the following simple process. When adding or modifying
functionality, proceed as follows:

1. Add the desired functionality to `instructions.odt`. This document contains
  a list of system functions ("SF") and an example exercise. Each of these 
  system functions comprises:
    1. Name
    2. Description
    3. Inputs/how to perform 
    4. Preconditions
    5. Output
    6. Postconditions
    7. Exceptions (ways it could go wrong and what it does in that case)
    8. (optional) Notes
2. Implement the functionality in code. Consult `structure.odt` if you do not
  know where to start, it gives a rundown of the basic program flow and structure.
  Also update this file if you make any changes or extensions to major architectural
  components.
3. Test the functionality. For now, the test procedure is to manually try out
  1. every correct way of using the SF
  2. every exception described in the SF
  3. every set of inputs that does not match what the "Inputs/how to perform"
      section stipulates. e.g., if it says the first argument is to be a
      nonempty string, try out what happens when you pass in the empty string
      and what happens when you pass in a non-string value like a number.

## Programming Guidelines
For now, our guidelines are small enough to stay here instead of in a
separate file. Read `structure.odt` for more detail on how these goals
are implemented; this section is only about general guidelines.  
  
The most important non-functional requirement is robustness.
Git has many features and makes it easy to create confusing repository states
that a developer who merely uses it and is not a Git expert may have a hard
time figuring out how to get back from.
Since we are checking out past versions of the same repo, we must
take care not to check out a version where Speedtracker does not
exist and cannot restore the program state.  
For these reasons,
check the results of every OS call and think of how to ensure
that a failed operation can restore the state before it happened.
Different exceptions should have well-defined error identifiers
which are defined as public class constants.  

Error handling in general: syntax errors/faulty arguments print out a usage message
and one line describing which argument is wrong. Semantic errors, e.g.
creating a snapshot with a name already taken, print out a one-liner
explaining what happened. Truly unexpected exceptions are logged fully,
with stack trace.  
  
All code besides `speedtracker.m`, benchmark and config files must
go in the `speedtracker` folder, because copying it to a temp location
is how the module prevents checking-out of old snapshots from breaking
itself.  

The Speedtracker code uses classes for top-level organization, but is largely
procedural, not object-oriented. Hide classes behind interfaces if they
separate major parts of the application. For example, the class
SnapshotLoader, through which the main program manages
snapshots, is an abstract class.  

Data Types:  
Use char arrays and cellstrings, not strings.
Vectors are row vectors wherever row or column would both work.

Expected Userbase:  
Users are developers of IFDIFF and can thus be expected to have a high degree of
expertise in MATLAB (higher than mine at any rate ^_^") and maybe even to poke around
in the Speedtracker code when it doesn't work how they like it.  

Expect users to have everyday knowledge of
Git: add, commit, push, pull, maybe tag, but no more.  

Git Usage Internally:  
Some Git commands use advanced terminal features like coloring that are
implemented with ANSI escape sequences and similar. On Linux, output of
Git commands may contain these escape sequences, making handling them very
difficult. For this reason, avoid using commands like `git tag`, `git show`,
and `git diff`. The commands listed under "Plumbing Commands" in the
[Git docs](https://git-scm.com/docs/) are intended for scripting and do
not use escape sequences.
Some commands, like `git add`, are okay and are used in Speedtracker.
