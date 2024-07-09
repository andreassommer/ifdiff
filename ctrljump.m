function ctrljump(increment, direction, ctrlif_index, conditionvalue)
    % Dummy function to signal a state jump. Users specify jumps using ifdiff_jumpif. During preprocessing, this
    % is replaced with a ctrlif (that will monitor the switching function) and a ctrljump, which contains the
    % increment and direction as well as the index of the generated ctrlif.
    % Like ifdiff_jumpif, ctrljump is never evaluated, it is only used as an anchor for code editing - IFDIFF
    % uses it to generate a jump function, a continuous function that computes the jump not only for the exact
    % switching point, but for a region around it, which can be used for sensitivity computation.
end