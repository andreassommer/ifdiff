classdef MtreeFunctionCallInfo
    %this = MTREEFUNCTIONCALLINFO(callIndex, rIndex, rIndexArgs, numArgs)
    %
    %Store and manage row indices related to function calls in an mtree.
    %
    %INPUT:
    %   callIndex - Function indices found in an mtree.
    %       1xN array of positive integers
    %
    %   rIndex - Row indices related to function calls. Entries for different function calls are stored column-wise.
    %   Different types of row indices are stored row-wise and named after the rIndexName enum.
    %       4xN array of positive integers
    %
    %   rIndexArgs - Row indices of arguments of function calls.
    %   Arguments within an entry for a function call are stored in order of appearance (i.e. the i-th arg at index i).
    %   Entries may be stored as columns of a matrix, if number of arguments is uniform, or as cells, otherwise.
    %       MxN array of positive integers | 1xN cell array of ?x1 positive integers
    %
    %   numArgs - Number of args for function calls or any negative number if number of args is not uniform.
    %       integer
    %
    %OUTPUT:
    %   rIndexCall - Row indices of function CALL nodes.
    %       1xN array of positive integers
    %
    %   rIndexEquals - Row indices of EQUALS nodes assigning the result of a function call.
    %       1xN array of positive integers
    %
    %   rIndexExpr - Row indices of EXPRESSION nodes assigning the result of a function call.
    %       1xN array of positive integers
    %
    %   rIndexFname - Row indices of ID nodes storing the name of functions that were called.
    %       1xN array of positive integers
    %
    %   rIndexArgs - Row indices of nodes storing the arguments of function calls.
    %       MxN array of positive integers | 1xN cell array of ?x1 positive integers
    %
    %See also RINDEXNAME, MTREEHELPERCALLINFO, MTREECTRLIFCALLINFO

    properties (Dependent)
        rIndexCall
        rIndexEquals
        rIndexExpr
        rIndexFname
        rIndexArgs
    end

    properties (Access=public)
        % Used internally to associate a call index with a column entry of an rIndex.
        % E.g.: Call index 5 is at index 3 in callIndex => Row index for call index 5 is stored in column 3 of rIndex.
        callIndex = []
        % Row indices are stored uniformly in a matrix.
        % Each column corresponds to a full row index entry for a function call.
        rIndexInternalFull = zeros(length(enumeration('rIndexName')), 0);
        % Arguments are stored separately because the number of arguments for calls may not be uniform.
        rIndexInternalArgs = {};
        numArgs = 0;
    end

    methods
        % Constructor
        function this = MtreeFunctionCallInfo(callIndex, rIndex, rIndexArgs, numArgs)
            if nargin == 0
                return
            end

            if isempty(callIndex)
                % If we don't have a callIndex, we can't associate function calls with row index entries, so stop here.
                return
            end

            this.callIndex = callIndex;
            nEntries = length(callIndex);

            if isempty(rIndex)
                % Preallocate
                this.rIndexInternalFull(end, nEntries) = 0;
            else
                this.rIndexInternalFull = rIndex;
            end

            if isempty(rIndexArgs)
                % Preallocate
                if numArgs >= 0
                    this.rIndexInternalArgs = zeros(numArgs, nEntries);
                else
                    this.rIndexInternalArgs = cell(1, nEntries);
                end
            else
                this.rIndexInternalArgs = rIndexArgs;
            end

            this.numArgs = numArgs;
        end

        function this = selectCallIndex(this, callIndex)
            %this = this.SELECTCALLINDEX(callIndex)
            %
            %Create a new object that only contains the entries corresponding to a given call index.
            %
            %INPUT:
            %   callIndex - Call indices of the entries that should be kept.
            %       1xN array of positive integers
            %
            %OUTPUT:
            %   this - Copy of object containing only the selected entries.
            %       MtreeCallInfo

            includeEntry = ismember(this.callIndex, callIndex);

            this.callIndex = callIndex;
            this.rIndexInternalFull = this.rIndexInternalFull(:, includeEntry);
            if this.numArgs >= 0
                this.rIndexInternalArgs = this.rIndexInternalArgs(:, includeEntry);
            else
                this.rIndexInternalArgs = this.rIndexInternalArgs(includeEntry);
            end
        end


        % Getters
        function rIndex = get.rIndexCall(this)
            rIndex = this.rIndexInternalFull(rIndexName.Call, :);
        end

        function rIndex = get.rIndexEquals(this)
            rIndex = this.rIndexInternalFull(rIndexName.Equals, :);
        end

        function rIndex = get.rIndexExpr(this)
            rIndex = this.rIndexInternalFull(rIndexName.Expr, :);
        end

        function rIndex = get.rIndexFname(this)
            rIndex = this.rIndexInternalFull(rIndexName.Fname, :);
        end

        function rIndex = get.rIndexArgs(this)
            if this.numArgs < 0 && isscalar(this.rIndexInternalArgs)
                % Unpack cell array when only one entry is present for better usability.
                rIndex = this.rIndexInternalArgs{1};
            else
                rIndex = this.rIndexInternalArgs;
            end
        end
    end
end
