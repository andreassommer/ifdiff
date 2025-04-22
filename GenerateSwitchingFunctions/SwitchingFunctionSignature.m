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
        end

        function str = get.str(this)
            %str = this.str
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

            % Concatenate switch condition
            switchCondString = sprintf('%d', this.switchCond);
            % Concatenate ctrlif index
            ctrlifIndexString = numericJoin(this.ctrlifIndex, this.CTRLIF_INDEX_DELIMITER);
            % First, convert each cell in function index into a char array
            convertCell = @(array) numericJoin(array, this.FUNCTION_INDEX_SHRINKING_DELIMITER);
            functionIndexString = cellfun(convertCell, this.functionIndex, 'UniformOutput', false);
            % Concatenate function index
            functionIndexString = strjoin(functionIndexString, this.FUNCTION_INDEX_CONCAT_DELIMITER);
            % Concatenate results
            str = [this.rhsName, this.RHS_NAME_SUFFIX, ...
                switchCondString, this.SWITCH_COND_SUFFIX, ...
                ctrlifIndexString, this.CTRLIF_INDEX_SUFFIX, ...
                functionIndexString];
        end

        function hash = get.hash(this)
            %hash = this.hash
            %
            %Compute 32-bit hash of string representation of signature and output in hex format
            hash = dec2hex(fnv(this.str), 8);
        end
    end
end
