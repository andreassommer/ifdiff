function hash = fnv(str)
% FNV-1a hash algorithm
% Source: isthe.com/chongo/tech/comp/fnv
% 32-Bit version
FNV_PRIME = uint32(16777619);
OFFSET_BASIS = uint32(2166136261);

LOW_ORDER_MASK = uint32(0xFF);
HIGH_ORDER_MASK = bitcmp(LOW_ORDER_MASK);

MODULO = bitset(0, 33);

hash = OFFSET_BASIS;
for ch=str
    ch = uint32(ch);
    % Get low order octet and compute xor
    octet = bitand(hash, LOW_ORDER_MASK);
    octet = bitxor(octet, ch);
    % Clear low order octet and update
    hash = bitand(hash, HIGH_ORDER_MASK);
    hash = bitor(hash, octet);

    % Perform modular arithmertic. TODO: Can we make this more efficient?
    hash = uint32(mod(double(hash) * double(FNV_PRIME), MODULO));
end

hash = dec2hex(hash);
end
