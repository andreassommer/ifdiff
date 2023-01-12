function vector_old = ctrlif_getSignaturePreallocation(value_new,vector_old, counter, caseSignature)


switch caseSignature
    case 1 % case switch_condition and ctrlif_index (vector)
        chunk_size = 30;
        
        % preallocate memory if vector_old empty
        if isempty(vector_old)
            vector_old = -ones(1,chunk_size);
        end
        
        l = length(vector_old);
        if l < counter
            vector_old_temp = vector_old;
            vector_old = -ones(1,l + chunk_size);
            index = 1:(counter-1);
            vector_old(1,index) = vector_old_temp(1,index);
        end
        
        vector_old(counter) = value_new;
        
        
        
        
    case 2 % case function_index (cell array)
        chunk_size = 30;
        
        % preallocate memory if vector_old empty
        if isempty(vector_old)
            vector_old = cell(chunk_size,1);
        end
        
        l = length(vector_old);
        if l < counter
            vector_old_temp = vector_old;
            vector_old = cell(l + chunk_size,1);
            index = 1:(counter-1);
            vector_old(index,1) = vector_old_temp(index,1);
        end
        
        vector_old{counter} = value_new;
end

end




