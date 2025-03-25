classdef SwitchingFunctionSignature
    %SWITCHINGFUNCTIONSIGNATURE Uniquely identifies a model transition/switch
    %   Three parameters are used for this purpose:
    %   - switch_cond: 1xN array of 0/1 containing the values of
    %   the conditions observed by ctrlifs before a switch. The
    %   i-th element of the array corresponds to the i-th ctrlif
    %   that was encountered in runtime. The last element always
    %   refers to a ctrlif whose condition has flipped.
    %
    %   - ctrlif_index: 1xN array of ints containing the
    %   ctrlif indices that were encountered before a switch.
    %
    %   - Nx1 cell array of 1x? array of int containing function indices that
    %   were encountered before a switch.


    properties (Access=public)
        rhsName
        switch_cond
        ctrlif_index
        function_index
    end

    properties (Dependent)
        str
        hash
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
        function this = SwitchingFunctionSignature(rhsName, switch_cond, ctrlif_index, function_index)
            %SWITCHINGFUNCTIONSIGNATURE Construct signature from ctrlif data.
            if nargin == 0
                return
            end

            this.rhsName = rhsName;
            this.switch_cond = switch_cond;
            this.ctrlif_index = ctrlif_index;
            this.function_index = function_index;
        end

        function str = get.str(this)
            %GET.STR Concatenate signature into one string.
            %   Format: <switch_cond><DELIM><ctrlif_index><DELIM><function_index>
            %   <switch_cond> - Concatenation of the array elements
            %   <ctrlif_index> - Concatenation of the array elements
            %   separated by a delimiter. This is required since
            %   ctrilif indices may consists of multiple digits.
            %   <function_index> - First the numeric arrays in each cell are
            %   reduced to char arrays containing the concatenation of the
            %   elements separated by a delimiter.
            %   Then the results are concatenated with a (different)
            %   delimiter.

            switch_cond_string = sprintf('%d', this.switch_cond);

            ctrlif_index_string = numericJoin(this.ctrlif_index, this.CTRLIF_INDEX_DELIMITER);

            % Convert each cell into a char array
            convertCell = @(array) numericJoin(array, this.FUNCTION_INDEX_SHRINKING_DELIMITER);
            function_index_string = cellfun(convertCell, this.function_index, 'UniformOutput', false);

            function_index_string = strjoin(function_index_string, this.FUNCTION_INDEX_CONCAT_DELIMITER);

            str = [this.rhsName, this.RHS_NAME_SUFFIX, ...
                switch_cond_string, this.SWITCH_COND_SUFFIX, ...
                ctrlif_index_string, this.CTRLIF_INDEX_SUFFIX, ...
                function_index_string];
        end

        function hash = get.hash(this)
            hash = fnv(this.str);
        end
    end
end
