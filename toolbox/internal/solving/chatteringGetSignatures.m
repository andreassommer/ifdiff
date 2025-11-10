function [signature1, signature2] = chatteringGetSignatures(datahandle, t)
% [signature1, signature2] = chatteringGetSignatures(datahandle, t)
% 
% For a chattering solution, determines the signatures that appeared 
% since timepoint t. If there are more than two, throws an error since the
% program is not capable of computing a Filippov solution in that case.
%
%
% INPUT:
%   datahandle:     datahandle containing switching point information     
%                       handle
% 
%   t:              timepoint, ignore signatures before this point
%                       scalar
%
% OUTPUT:
%   signature1:     Signature that has been encountered.
%                       struct
%   
%   signature2:     Signature that has been encountered.
%                       struct


data = datahandle.getData();
switchingpoints = cell2mat(data.SWP_detection.switchingpoints);

% Assume switching points are sorted. If not, something went very wrong...
idxChatterStart = find(switchingpoints >= t, 1);

signatures = data.SWP_detection.signature;
ctrlif_indices      = signatures.ctrlif_index(idxChatterStart:end);
function_indices    = signatures.function_index(idxChatterStart:end);
switch_conds        = signatures.switch_cond(idxChatterStart:end);

k = length(ctrlif_indices);

uniqueChatteringSignatures.ctrlif_index     = ctrlif_indices(1);
uniqueChatteringSignatures.function_index   = function_indices(1);
uniqueChatteringSignatures.switch_cond      = switch_conds(1);

for i=2:k
    exists = false;
    ctrlif_index    = ctrlif_indices{i};
    function_index  = function_indices{i};
    switch_cond     = switch_conds{i};

    for j=1:length(uniqueChatteringSignatures.ctrlif_index)
        ctrlif_index_ref    = uniqueChatteringSignatures.ctrlif_index{j};
        function_index_ref  = uniqueChatteringSignatures.function_index{j};
        switch_cond_ref     = uniqueChatteringSignatures.switch_cond{j};
        if compareSignatures( ...
                ctrlif_index, ctrlif_index_ref, ...
                function_index, function_index_ref, ...
                switch_cond, switch_cond_ref)
            exists = true;
        end
    end
    % signature not seen yet
    if ~exists
        uniqueChatteringSignatures.ctrlif_index{end+1}      = ctrlif_index;
        uniqueChatteringSignatures.function_index{end+1}    = function_index;
        uniqueChatteringSignatures.switch_cond{end+1}       = switch_cond;
    end
end

if length(uniqueChatteringSignatures.ctrlif_index) ~= 2
    error('IFDIFF:ChatteringInvolvesSeveralSwitches', 'Chattering does not involve exactly two signatures.\n');
end

% output
signature1.ctrlif_index     = uniqueChatteringSignatures.ctrlif_index{1};
signature1.function_index   = uniqueChatteringSignatures.function_index{1};
signature1.switch_cond      = uniqueChatteringSignatures.switch_cond{1};

signature2.ctrlif_index     = uniqueChatteringSignatures.ctrlif_index{2};
signature2.function_index   = uniqueChatteringSignatures.function_index{2};
signature2.switch_cond      = uniqueChatteringSignatures.switch_cond{2};

end
