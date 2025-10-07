classdef MtreeCtrlifCallInfo < MtreeFunctionCallInfo
    %this = MTREECTRLIFCALLINFO(mtree)
    %
    %Store and manage row indices related to ctrlif function calls in an mtree.
    %
    %INPUT:
    %   mtree - Mtree for which the row index information should be generated.
    %       mtreeplus
    %
    %See also MTREEFUNCTIONCALLINFO

    methods
        % Constructor
        function this = MtreeCtrlifCallInfo(mtree)
            if nargin == 0
                [callIndex, rIndex, rIndexArgs] = deal([]);
                numArgs = 0;
            else
                [callIndex, rIndex, rIndexArgs] = createCtrlifCallInfo(mtree);
                numArgs = size(rIndexArgs, 1);
            end

            this = this@MtreeFunctionCallInfo(callIndex, rIndex, rIndexArgs, numArgs);
        end
    end
end
