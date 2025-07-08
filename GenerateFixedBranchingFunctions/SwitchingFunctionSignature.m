classdef SwitchingFunctionSignature
    %this = SWITCHINGFUNCTIONSIGNATURE(rhsName, switchCond, ctrlifIndex, functionIndex)
    %
    %Uniquely identifies a model transition/switch and its corresponding switching function.
    %
    %INPUT:
    %   rhsName - Name of the RHS function
    %       char array
    %
    %   switchCond - True/False values of the conditions observed by ctrlifs before a switch.
    %   The i-th element of the array corresponds to the i-th ctrlif that was encountered in runtime.
    %   The last element always refers to a ctrlif whose condition has flipped.
    %       1xN array of logicals
    %
    %   ctrlifIndex - Ctrlif indices that were encountered before a switch (in order of appearance during runtime).
    %       1xN array of positive integers
    %
    %   functionIndex - Function indices that were encountered before a switch (in order of appearance during runtime).
    %       1xN cell array of 1x? arrays of positive integers
    %
    %OUTPUT:
    %   str - Unique string representation of an instance of this class
    %       char array
    %
    %   hash - 32-bit hash of str in hex format
    %       char array


    properties (Access=public)
        rhsName = ''
        switchCond = []
        ctrlifIndex = []
        functionIndex = {}
    end

    properties (Dependent)
        str
        hash
    end

    properties (Access=private, Hidden)
        doCacheUpdate = false
        strCached = ''
        hashCached = ''
    end

    properties (Constant, Hidden)
        RHS_NAME_SUFFIX = ':';
        SWITCH_COND_SUFFIX = '/';
        CTRLIF_INDEX_SUFFIX = '/';
        CTRLIF_INDEX_DELIMITER = '-';
        FUNCTION_INDEX_SHRINKING_DELIMITER = '-';
        FUNCTION_INDEX_CONCAT_DELIMITER = '_';
    end

    methods
        % Constructor
        function this = SwitchingFunctionSignature(rhsName, switchCond, ctrlifIndex, functionIndex)
            if nargin == 0
                return
            end

            this.rhsName = rhsName;
            this.switchCond = switchCond;
            this.ctrlifIndex = ctrlifIndex;
            this.functionIndex = functionIndex;

            this.doCacheUpdate = true;
            this = this.updateCache();
        end

        function str = toStr(this)
            %str = this.TOSTR()
            %
            %Concatenate data properties of signature into a unique string.
            %
            %The string is built according to the following format:
            %   str = <rhsName><DELIM1><switchCond><DELIM2><ctrlifIndex><DELIM3><functionIndex>
            %       <rhsName> - Name of the RHS function
            %       <switchCond> - Concatenation of the array elements (only 0/1 values so no delimiter needed)
            %       <ctrlifIndex> - Concatenation of the array elements separated by a delimiter.
            %       Required since ctrlif indices may consist of multiple digits.
            %       <functionIndex> - Numeric arrays in each cell reduced to char arrays,
            %       containing concatenation of the elements separated by a delimiter.
            %       Then char arrays are concatenated with a (different) delimiter.

            switchCondStr = sprintf('%d', this.switchCond);

            ctrlifIndexStr = arrayStrJoin(this.ctrlifIndex, this.CTRLIF_INDEX_DELIMITER, '%u');

            % Convert each cell in function index into a char array.
            functionIndexStr = cell(1, length(this.functionIndex));
            for idx=1:length(functionIndexStr)
                functionIndexStr{idx} = arrayStrJoin(this.functionIndex{idx}, this.FUNCTION_INDEX_SHRINKING_DELIMITER, '%u');
            end
            % Concatenate converted function index entries.
            functionIndexStr = arrayStrJoin(functionIndexStr, this.FUNCTION_INDEX_CONCAT_DELIMITER, '%s');

            str = [this.rhsName, this.RHS_NAME_SUFFIX, ...
                switchCondStr, this.SWITCH_COND_SUFFIX, ...
                ctrlifIndexStr, this.CTRLIF_INDEX_SUFFIX, ...
                functionIndexStr];
        end

        function hash = toHash(this)
            %hash = this.TOHASH()
            %
            %Compute 32-bit hash of string representation of signature and output in hex format

            hash = dec2hex(fnv(this.str), 8);
        end

        function this = updateCache(this)
            %this = this.UPDATECACHE()
            %
            %Update the cached values for str and hash.

            if this.doCacheUpdate
                this.strCached = this.toStr();
                this.hashCached = this.toHash();
            end
        end

        % Getters retrieve the cached value for str and hash.
        function str = get.str(this)
            str = this.strCached;
        end

        function hash = get.hash(this)
            hash = this.hashCached;
        end

        % Setters have to update the cached values for str and hash.
        function this = set.rhsName(this, val)
            this.rhsName = val;
            this = this.updateCache();
        end

        function this = set.switchCond(this, val)
            this.switchCond = val;
            this = this.updateCache();
        end

        function this = set.ctrlifIndex(this, val)
            this.ctrlifIndex = val;
            this = this.updateCache();
        end

        function this = set.functionIndex(this, val)
            this.functionIndex = val;
            this = this.updateCache();
        end
    end
end
