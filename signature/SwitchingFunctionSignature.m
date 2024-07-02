classdef SwitchingFunctionSignature
%SWITCHINGFUNCTIONSIGNATURE 
%   Three parameters are used to uniquely identify a switching function:
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

% These properties should never be changed after initialization. This
% allows us to cache certain results like the string representation or
% hash. If you need to change the signature, simply construct a new instance
% of this class.
    properties (SetAccess=immutable)
        switch_cond 
        ctrlif_index
        function_index
    end
    properties (Dependent)
        str
        hash
    end

    methods (Static, Access=private)
        function hash = charToHash(array)
            hash = sprintf('%d', array);
        end
    end
    methods
        function this = SwitchingFunctionSignature(switch_cond, ctrlif_index, function_index)
            %SWITCHINGFUNCTIONSIGNATURE Construct signature from ctrlif data.
            this.switch_cond = switch_cond;
            this.ctrlif_index = ctrlif_index;
            this.function_index = function_index;
        end
        
        % TODO: It might be possible to cache the string representation.
        % Need to figure out if it's worth it and how it can be implemented.
        function str = get.str(this)
            %GET.STR Concatenate signature into one string.
            %   Format: <switch_cond>a<ctrlif_index>b<function_index>
            %   <switch_cond> - Concatenation of the array elements
            %   <ctrlif_index> - Concatenation of the array elements
            %   separated by a delimiter. This is required since
            %   ctrilif indices may consists of multiple digits.
            %   <function_index> - First the numeric arrays in each cell are
            %   reduced to char arrays containing the concatenation of the 
            %   elements separated by a delimiter.
            %   Then the results are concatenated with a (different)
            %   delimiter.
            SWITCH_COND_SUFFIX = 'a';
            CTRLIF_INDEX_SUFFIX = 'b';
            CTRLIF_INDEX_DELIMITER = ',';
            FUNCTION_INDEX_SHRINKING_DELIMITER = ',';
            FUNCTION_INDEX_CONCAT_DELIMITER = ';';

            switch_cond_string = sprintf('%d', this.switch_cond);

            ctrlif_index_string = numericToCharJoin(this.ctrlif_index, CTRLIF_INDEX_DELIMITER);
            
            % Convert each cell into a char array
            convertCell = @(array) numericToCharJoin(array, FUNCTION_INDEX_SHRINKING_DELIMITER);
            function_index_string = cellfun(convertCell, this.function_index, 'UniformOutput', false);

            function_index_string = strjoin(function_index_string, FUNCTION_INDEX_CONCAT_DELIMITER);

            str = [switch_cond_string, SWITCH_COND_SUFFIX,... 
                   ctrlif_index_string, CTRLIF_INDEX_SUFFIX,...
                   function_index_string];
            % END OF MAIN FUNCTION

            % Helper function that converts a numeric array to a char array
            % with a delimiter inserted between elements.
            function out = numericToCharJoin(array, delim)
                % strjoin requires a cell array of char arrays/strings
                array = num2cell(sprintf('%d', array));
                out = strjoin(array, delim);
            end
        end
        
        function hash = get.hash(this)
            hash = this.charToHash(this.str);
        end
    end
end