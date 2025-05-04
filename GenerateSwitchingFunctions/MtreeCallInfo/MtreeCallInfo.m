classdef MtreeCallInfo
    %this = MTREECALLINFO(mtree)
    %this = MTREECALLINFO(callIndex, rIndex, rIndexArgs)
    %
    %Store and manage mtree row indices related to helper function calls.
    %
    %INPUT:
    %   mtree - Mtree for which the row index information should be generated.
    %       mtreeplus
    %
    %   callIndex - Function indices found in an mtree.
    %       1xN array of positive integers
    %
    %   rIndex - Row indices related to function calls. Entries for different function calls are stored column-wise.
    %   Different types of row indices are stored row-wise and named after the rIndexName enum.
    %       4xN array of positive integers
    %
    %   rIndexArgs - Row indices of arguments of function calls.
    %   Arguments within an entry for a function call are stored in order of appearance (i.e. the i-th arg at index i).
    %       1xN cell array of 1x? positive integers
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
    %See also RINDEXNAME, CREATEFUNCTIONCALLINFO

    properties (Dependent)
        rIndexCall
        rIndexEquals
        rIndexExpr
        rIndexFname
        rIndexArgs
    end

    properties (Access=private)
        % Used internally to associate a call index with a column entry of an rIndex.
        % E.g.: Call index 5 is at index 3 in callIndex => Row index for call index 5 is stored in column 3 of rIndex.
        callIndex = []
        % Row indices are stored uniformly in a matrix.
        % Each column corresponds to a full row index entry for a function call.
        rIndexInternalFull = zeros(length(enumeration('rIndexName')), 0);
        % Arguments are stored separately in a cell array, because the number of arguments for calls is not uniform.
        rIndexInternalArgs = {};
    end

    properties (Constant, Hidden)
        ERR_CODE_INVALID_CONSTRUCTOR = 'IFDIFF:MtreeCallInfo:InvalidConstructor'
        ERR_MSG_INVALID_CONSTRUCTOR = 'Invalid number of constructor inputs: Got %d, but expected 0, 1 or 3.'
    end

    methods
        % Constructor
        function this = MtreeCallInfo(varargin)
            if nargin == 0
                return
            end

            if nargin == 1
                % Generate row index from mtree.
                mtree = varargin{1};
                [callIndex, rIndex, rIndexArgs] = createFunctionCallInfo(mtree);
            elseif nargin == 3
                callIndex = varargin{1};
                rIndex = varargin{2};
                rIndexArgs = varargin{3};
            else
                error(this.ERR_CODE_INVALID_CONSTRUCTOR, this.ERR_MSG_INVALID_CONSTRUCTOR, nargin);
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
                this.rIndexInternalArgs = cell(1, nEntries);
            else
                this.rIndexInternalArgs = rIndexArgs;
            end
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
            this.rIndexInternalArgs = this.rIndexInternalArgs(includeEntry);
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
            if isscalar(this.rIndexInternalArgs)
                % Unpack cell array when only one entry is present for better usability.
                rIndex = this.rIndexInternalArgs{1};
            else
                rIndex = this.rIndexInternalArgs;
            end
        end
    end
end
