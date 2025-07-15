function parameters = getParams_LV()
    parameters = zeros(4, 1);
    parameters(1) = 0.2;
    parameters(2) = 0.01;
    parameters(3) = 0.001;
    parameters(4) = 0.1;

    parameters = reshape(parameters, [], 1);
end
