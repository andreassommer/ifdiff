# Hints and Caveats

## Nested Functions

### Usage Conditions

IFDIFF generally supports [nested functions] (https://www.mathworks.com/help/matlab/matlab_prog/nested-functions.html) in RHS files or functions called by an 
RHS under the sole condition that those **do not contain any switches** (no `if`, `abs`, `sign`, `min`, `max`, `ifdiff_jumpif`, etc.).

If switching logic is necessary, write the nested function as a local function 
(i.e. functions defined after the `end` of the main function in the same file) or as a separate function file (recommended).

```MATLAB
function dx = rhs(t, x, p)
    function out = inflow()   % OK: nested function without switches
        out = p(1)*t;
    end
    function out = rate()     % NOT supported: nested function with a switch
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

- Whenever preprocessing a RHS (or a helper function) containing nested functions, IFDIFF issues the warning `IFDIFF:Preprocessing:NestedFunction`. You can turn it off with
  ```MATLAB
  warning('off', 'IFDIFF:Preprocessing:NestedFunction')
  ```
- Nested function can read and write variables of the enclosing function. Reading always outputs the value of the respective variable at the time of the call. 
  Shared variables have to be initialized in the enclosing function before the first call to the nested function
- Above point prevents IFDIFF from simplifying generated RHS and switching functions as there might be variables accessed in the nested function. If this leads to performance issues,
  simply move the nested function to a separate function file
- You can use empty nested functions to prevent IFDIFFs function optimization for the purpose of **debugging**.