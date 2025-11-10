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

signatures = data.SWP_detection.signature(idxChatterStart:end);
% Make sure we don't consider any signatures from previous Filippov modes.
% Filippov signatures are stored as cells with two signatures.
isFilippov = cellfun(@iscell, signatures);
if any(isFilippov)
    % Unsure if this case can be handled gracefully, for now abort.
    throw(filippovSignatureChatteringException);
end

% Find unique signatures among chattering. Stop and throw if we find more than two.
uniqueChatteringSignatures = signatures(1);
for idxNew=2:length(signatures)
    isNewSignature = true;
    for idxOld=1:length(uniqueChatteringSignatures)
        if signatures{idxNew} == signatures{idxOld}
            % Signature already included.
            isNewSignature = false;
            break
        end
    end

    if isNewSignature
        % New signature, add to list.
        uniqueChatteringSignatures{end + 1} = signatures{idxNew}; %#ok<AGROW>
    end

    if length(uniqueChatteringSignatures) > 2
        break
    end
end


if length(uniqueChatteringSignatures) ~= 2
    throw(invalidNumberOfChatteringSwitches);
end

% output
[signature1, signature2] = uniqueChatteringSignatures{:};
end

%% Exceptions
function e = filippovSignatureChatteringException
msg = [ ...
    'Unable to determine chattering signature:\n' ...
    'One of the chattering signature candidates is a Filippov signature.\n'];
e = MException('IFDIFF:ChatteringInvolvesFilippov', msg);
end

function e = invalidNumberOfChatteringSwitches
msg = 'Chattering does not involve exactly two signatures.\n';
e = MException('IFDIFF:ChatteringInvolvesSeveralSwitches', msg);
end
