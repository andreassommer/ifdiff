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