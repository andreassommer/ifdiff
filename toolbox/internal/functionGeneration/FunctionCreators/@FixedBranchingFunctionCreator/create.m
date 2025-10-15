function functionHandle = create(this, collisionIndex)
%functionHandle = this.CREATE(collisionIndex)
%
%Create a new function and necessary helper functions based on a signature.
%The source code of the functions will be written to .m files.
%
%INPUT:
%   collisionIndex - Integer added as a suffix to the name of the new function
%   to avoid name clashes when encountering hash collisions in the signature.
%       scalar positive integer
%
%OUTPUT:
%   functionHandle - Handle to the main (i.e. not helper) function of the newly created functions.
%       function handle
%
%See also BRANCHINGSIGNATURE

% We have to create one main function and an arbitrary number of helper functions depending on the function index.
% Since we don't know the number in advance and may need to edit functions multiple times, store mtrees in a cell array.
% We also assign a unique integer ID to each exported function which is equal to its index in the cell array.
% Note that the RHS, which will become the main function, is always assigned index 1.
this.exportMtreeArray = this.functionData.mtreeArray(1);

% All exported functions are named as: <functionName>_<exportID>
rhsName = this.functionData.functionNameArray{1};
this.functionName = createSwitchingFunctionName(this.functionNamePrefix, rhsName, this.signature.hash, collisionIndex);

% Update name of main function.
this.exportMtreeArray{1} = mtree_changeFcnName( ...
    this.exportMtreeArray{1}, ...
    getExportFunctionName(this.functionName, 1));

this.funcIter = FunctionIterator(this.functionData);
for idxCtrlif = 1:this.numCtrlif-1
    % Iterate over helper function calls preceding the ctrlif call to find the mtree of the ctrlif.
    % Along the way, create copies of helper functions and adjust helper function calls if necessary.
    this = this.handleHelperCallsBeforeCtrlif(idxCtrlif, false);
    % Fix the branching by replacing the ctrlif with its true or false part.
    this = this.fixBranching(idxCtrlif);
end

% Last ctrlif has to be handled in a special way depending on the type of function.
this = this.handleLastCtrlif();

% Export main function and any new helper function mtrees to actual .m files.
exportSwitchingFunctions(this.exportMtreeArray, this.writePath, this.functionName, this.signature.str);

% Return function handle to the main function.
functionHandle = str2func(getExportFunctionName(this.functionName, 1));
end
