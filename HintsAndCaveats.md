# Hints and Caveats

## Nested Functions

### Usage Conditions

**Do not** use [nested functions](https://www.mathworks.com/help/matlab/matlab_prog/nested-functions.html) 
in IFDIFF, if they or functions called by them contain any switches 
(no `if`, `abs`, `sign`, `min`, `max`, `ifdiff_jumpif`, etc.).

If switching logic is necessary, write the nested function in a separate function file (recommended).

```MATLAB
function dx = rhs(t, x, p)
    function out = f1()     % POSSIBLE
        out = p(1)*t;
    end
    function out = f2()     % DON'T DO THIS!
        if x(1) > 1
            out = 1;
        else
            out = 0;
        end
    end
...
end
```

### Helpful Tipps

- Whenever preprocessing a RHS (or a helper function) containing nested 
  functions, IFDIFF issues the warning `IFDIFF:Preprocessing:NestedFunction`. 
  You can turn it off with
  ```MATLAB
  warning('off', 'IFDIFF:Preprocessing:NestedFunction')
  ```
- Nested function can read and write variables of the enclosing function. 
  Reading always outputs the value of the respective variable at the time of the call. 
  Shared variables have to be initialized in the enclosing function before 
  the first call to the nested function
- Above point prevents IFDIFF from simplifying generated RHS and switching 
  functions as there might be variables accessed in the nested function.
  If this leads to performance issues, simply move the nested function to
  a separate function file
- You can use empty nested functions to prevent IFDIFFs function optimization 
  for the purpose of **debugging**.

## Global Variables

IFDIFF does **not** explicitly **support** [global variables](https://www.mathworks.com/help/matlab/ref/global.html).
Using them in a RHS or in functions called by it is **at your own risk**.
When preprocessing a RHS (or a helper function) declaring global variables,
IFDIFF issues the warning `IFDIFF:Preprocessing:GlobalVariable`.
You can turn it off with
```MATLAB
warning('off', 'IFDIFF:Preprocessing:GlobalVariable')
```

## Debugging

IFDIFF simplifies the generated switching, jump and model functions by removing all statements
that do not contribute to their result. IFDIFF provides two functions which help with debugging.

### Keeping Variables: `ifdiff_keepvar`

Variables passed to `ifdiff_keepvar` are **not removed** from the generated functions,
e.g. to inspect them while debugging. The function itself does nothing.

```MATLAB
function dx = rhs(t, x, p)
    dbgVal = 3*x(1) + p(2);     % not needed for the switch, would be removed
    ifdiff_keepvar(dbgVal);     % keeps dbgVal in the generated functions
    if x(1) > p(1)
        dx = 2;
    else
        dx = 1;
    end
end
```

- Place the call **after the last assignment** of the variable and **before the switches**
  (`if`, `abs`, `min`, `max`, etc.) whose switching functions should contain it.
  The line right after the assignment is usually a safe place.
- If a variable is reassigned between switches, call `ifdiff_keepvar` after **each** assignment.
- Pass the variable itself, **not its name**: `ifdiff_keepvar(x)`, not `ifdiff_keepvar('x')`.
- Several variables can be passed at once: `ifdiff_keepvar(a, b, c)`.

### Conditional Breakpoints: `ifdiff_breakif`

`ifdiff_breakif(cond)` stops in the debugger if `cond` is true, e.g. `ifdiff_breakif(t > 5)`.

- MATLAB stops **inside** `ifdiff_breakif`. Type `dbup` to get to the workspace of your RHS.
- The call is also kept in the generated switching functions, so MATLAB may stop there as well.
  The RHS is also called more often than you might expect (e.g. for rejected integration steps
  and switching point detection).
- Variables used in `cond` are kept in the generated functions, just like with `ifdiff_keepvar`.
- `cond` should be a scalar logical.