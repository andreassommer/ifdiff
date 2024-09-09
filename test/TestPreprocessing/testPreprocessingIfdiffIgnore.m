function out = testPreprocessingIfdiffIgnore(in1, in2)
    if all(class(in1) == 'string') % ifdiff:ignore
        out = in1;
        return
    end

    if in1 > in2
        out = in1;
    else
        out = in2;
end