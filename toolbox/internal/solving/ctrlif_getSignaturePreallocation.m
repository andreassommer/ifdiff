function vector_old = ctrlif_getSignaturePreallocation(value_new,vector_old, counter, caseSignature)
config = makeConfig();


switch caseSignature
    case 1 % case switch_condition and ctrlif_index (vector)
        
        % preallocate memory if vector_old empty
        if isempty(vector_old)
            vector_old = -ones(1,config.ctrlif_signaturePreallocationChunkSize);
        end
        
        l = length(vector_old);
        if l < counter
            vector_old_temp = vector_old;
            vector_old = -ones(1,l + config.ctrlif_signaturePreallocationChunkSize);
            index = 1:(counter-1);
            vector_old(1,index) = vector_old_temp(1,index);
        end
        
        vector_old(counter) = value_new;
        
        
        
        
    case 2 % case function_index (cell array)
        
        % preallocate memory if vector_old empty
        if isempty(vector_old)
            vector_old = cell(config.ctrlif_signaturePreallocationChunkSize,1);
        end
        
        l = length(vector_old);
        if l < counter
            vector_old_temp = vector_old;
            vector_old = cell(l + config.ctrlif_signaturePreallocationChunkSize,1);
            index = 1:(counter-1);
            vector_old(index,1) = vector_old_temp(index,1);
        end
        
        vector_old{counter} = value_new;
end

end




