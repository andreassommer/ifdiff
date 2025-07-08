function hash = fnv(str)
%hash = FNV(str)
%
%Compute the 32-bit FNV-1a hash of a string.
%Source: isthe.com/chongo/tech/comp/fnv
%
%INPUT:
%   str - String to be hashed
%       char array
%
%OUTPUT:
%   hash - 32-bit hash of the string
%       uint32


% Reference for these numbers: isthe.com/chongo/tech/comp/fnv
FNV_PRIME = uint32(16777619);
OFFSET_BASIS = uint32(2166136261);

% Convert string to array of bytes
bytes = unicode2native(str, 'UTF-8');
% Store each byte as uint32 (upper 24-bits are zero) since bitwise operands in MATLAB have to be same type.
bytes = uint32(bytes);

hash = OFFSET_BASIS;
for byte=bytes
    % XOR low order octet
    % Note that upper 24-bits of hash are unaffected since upper 24-bits of byte are zero.
    hash = bitxor(hash, byte);
    % Perform multiplication modulo 2^32 (equivalent to truncating at 32-bits)
    % Note that MATLAB handles overflows in integer arithmetic via saturation and NOT wrapping (e.g. unlike C).
    % Therefore, we need to manually perform the truncation after computing the product.
    % Also note that storing the product of two uint32 in a uint64 is safe (i.e. overflow is not possible).
    product = uint64(hash) * uint64(FNV_PRIME);
    % From profiling: Using bitshift to clear the upper 32 bits is faster than using a bitmask with bitand or typecast.
    hash = uint32(bitshift(bitshift(product, 32), -32));
end
end
