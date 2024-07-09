function dx = fullSwitchRHS(~, x, ~)
% What happens if we have a full switch, i.e. model and state change at the same time?
% with the ifdiff_jumpif formulation, this would mean two ctrlifs with identical SWFs.
% IFDIFF can handle this so far, but identifying the jump and creating the jump function
% could be challenging.
    if x < 10
        dx = 2;
    else
        dx = 1;
    end
    ifdiff_jumpif(x(1) - 10, 1, [5]);
end
