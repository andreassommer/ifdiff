function [AbsTol, RelTol] = getIntegratorTolerances(options)
% Returns the absolute and relative integration tolerances contained in
% 'options', if present. Otherwise, the default values
% from the config are returned.
%
%
% INPUT:
% 'options'     set of integration options
%                   struct (odeset)
%
% OUTPUT:
% 'AbsTol'      Absolute local integration tolerance
%                   float
% 'RelTol'      Relative local integration tolerance
%                   float

config = [];

AbsTol = options.AbsTol;
if isempty(AbsTol)
    config = makeConfig();
    AbsTol = config.optionsDefault.AbsTol;
end

RelTol = options.RelTol;
if isempty(RelTol)
    if isempty(config)
        config = makeConfig;
    end
    RelTol = config.optionsDefault.RelTol;
end