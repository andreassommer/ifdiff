classdef MtreeHelperCallInfo < MtreeFunctionCallInfo
    %this = MTREEHELPERCALLINFO(mtree)
    %
    %Store and manage row indices related to helper function calls in an mtree.
    %
    %INPUT:
    %   mtree - Mtree for which the row index information should be generated.
    %       mtreeplus
    %
    %See also MTREEFUNCTIONCALLINFO

    methods
        % Constructor
        function this = MtreeHelperCallInfo(mtree)
            if nargin == 0
                [callIndex, rIndex, rIndexArgs] = deal([]);
            else
                [callIndex, rIndex, rIndexArgs] = createHelperCallInfo(mtree);
            end
            numArgs = -1;

            this = this@MtreeFunctionCallInfo(callIndex, rIndex, rIndexArgs, numArgs);
        end
    end
end
