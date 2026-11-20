function ifdiff_breakif(cond)
%IFDIFF_BREAKIF Conditional breakpoint for use in a RHS (or helper
%function). Stops in the debugger if cond is true. Use dbup to get to the
%workspace of the calling function.
%The call is kept in the generated switching, jump and model functions, so
%it may also stop there.
%Variables used in cond are kept in these functions as well.
%
% INPUT:
%   cond - scalar conditional value for applying a keyboard interrupt
    if cond %%ifdiff:ignore
        keyboard %#ok<KEYBOARDFUN>
    end
end

