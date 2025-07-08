function functionHandle = create(this, collisionIndex)
%functionHandle = this.CREATENEW(signature, collisionIndex)
%functionHandle = this.CREATENEW(signature, collisionIndex, ctrljumpInfo)
%
%Create a new switching/jump function and necessary helper functions based on a signature.
%The source code of the functions will be written to .m files.
%
%INPUT:
%   signature - Signature corresponding to the function that should be created.
%       BranchingSignature
%
%   collisionIndex - Integer added as a suffix to the name of the new function
%   to avoid name clashes when encountering hash collisions in the signature.
%       scalar positive integer
%
%   ctrljumpInfo - (Optional) Contains information that ties ctrlif indices to ctrljump expressions.
%   If provided, this function will create a jump function instead of a switching function.
%       3xN array of integers
%
%OUTPUT:
%   switchingFunctionHandle - Handle to the main (i.e. not helper) function of the newly created function.
%       function handle
%
%See also SWITCHINGFUNCTIONFACTORY, BRANCHINGSIGNATURE, SOLVEODE, SOLVEODE_GETJUMPINDICES

% Overview of the algorithm:
% The output of the switching function should be the condition contained within the last ctrlif in the signature,
% since this is the ctrlif whose condition has flipped and the condition is in normal form (i.e. cond >= 0).
%
% Also, we want the switching function to only contain statements that are required to compute the switching value,
% because it may be called many times during the root finding algorithm used to compute the switching point.
%
% To achieve this, we first replace all ctrlifs called before the last ctrlif with their fixed true or false part.
%
% However, ctrlifs may be contained within helper functions, so we first need to find the mtree of each ctrlif.
%
% Additionally, the same ctrlif may be called multiple times.
% To deal with this, we create a copy of a helper function for each unique call sequence belonging to this function.
%
% Finally, the last ctrlif, and all helper function leading to it have to be replaced by appropriate return statements,
% to simplify all functions and acquire the switch condition as the output of the main switching function.
%
% A similar procedure applies to jump functions with the main difference that the output value is obtained differently.

% We have to create one main function and an arbitrary number of helper functions depending on the function index.
% Since we don't know the number in advance and may need to edit functions multiple times, store mtrees in a cell array.
% We also assign a unique integer ID to each exported function which is equal to its index in the cell array.
% Note that the RHS, which will become the main function, is always assigned index 1.
this.exportMtreeArray = this.functionData.mtreeArray(1);

% All exported functions are named as: <switchingFunctionName>_<exportID>
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
    this = this.fixBranching(idxCtrlif);
end

% Last Ctrlif
this = this.handleLastCtrlif();

% Export main function and any new helper function mtrees to actual .m files.
exportSwitchingFunctions(this.exportMtreeArray, this.writePath, this.functionName, this.signature.str);

% Return function handle to the main function.
functionHandle = str2func(getExportFunctionName(this.functionName, 1));
end
