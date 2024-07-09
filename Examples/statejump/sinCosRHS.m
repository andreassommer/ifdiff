function dx = sinCosRHS(~, x, ~)
%SINCOSRHS Sine-cosine pair that, whenever the sine hits zero, jumps to sin=cos=(+/-)sqrt(1/2). This is an
% opportunity to experiment with jump directions and possibly needs two different jump functions
    dx = zeros(2, 1);
    dx(1) = x(2);
    dx(2) = -x(1);
    % convenient: when the sine hits 0 from above, cosine is -1, and if it hits it from below, cosine is 1.
    % ... well, guess it isn't so much of an opportunity to experiment after all. but it indicates that using
    % these jumps is going to be more convenient than i thought.
    ifdiff_jumpif(x(1), 0, x(2)*[sqrt(1/2); sqrt(1/2)-1]);
end

