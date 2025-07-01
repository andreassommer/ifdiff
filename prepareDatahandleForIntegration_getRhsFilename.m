function rhsFilename = prepareDatahandleForIntegration_getRhsFilename(rhs)
%rhsFilename = PREPAREDATAHANDLEFORINTEGRATION_GETRHSFILENAME(rhs)
%
%Determine name of the .m file containing the RHS function definition.
%
%INPUT:
%   rhs - Specification of the RHS from user input.
%       1xN char | string scalar | function_handle
%
%OUTPUT:
%   rhsFilename - Name of the .m file containing the RHS function definition.
%   Does not include any preceding path. Does not include the '.m' extension.
%       1xN char
%
%See also PREPAREDATAHANDLEFORINTEGRATION.

if isa(rhs, 'function_handle')
    rhsFile = func2str(rhs);
else
    rhsFile = convertStringsToChars(rhs);
    if ~ischar(rhsFile)
        throw(invalidDataTypeError(rhs))
    end
end

if ~isrow(rhsFile)
    throw(invalidDimensionError(rhsFile));
end

rhsFilename = extractName(rhsFile);
end

%% Helpers
function filename = extractName(file)
if exist(file, 'file') ~= 2 % check for .m file
    throwAsCaller(fileNotFoundError(file));
end

[~, filename, ~] = fileparts(file);
end

%% Exceptions
function e = fileNotFoundError(file)
msg = [ ...
    'Unable to find RHS file ''%s'': ', ...
    'First argument must be name of .m-file containing the RHS function definition ', ...
    'or a non-anonymous function handle to the RHS function (i.e. @myRhs, not @(t,y,p) myRhs(t,y,p)).\n'];
e = MException('IFDIFF:Preprocessing:RhsFileNotFound', msg, file);
end

function e = invalidDataTypeError(input)
msg = 'Invalid data type ''%s'' for RHS specification: First argument must be char or string scalar.\n';
e = MException('IFDIFF:Preprocessing:InvalidRhsDataType', msg, class(input));
end

function e = invalidDimensionError(input)
msg = 'Invalid dimensions [%s] for RHS specification: First argument must be row vector.\n';
e = MException('IFDIFF:Preprocessing:InvalidRhsDimension', msg, num2str(size(input)));
end
