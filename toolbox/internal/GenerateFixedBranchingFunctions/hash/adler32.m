function varargout = adler32(instring)
   % hashValue = ADLER32(chararray)
   % [hashValue, hashString] = ADLER32(charrarray)
   %
   % Computes the Adler-32 hash of given chararray.
   %
   % INPUT:      string --> char array whose hash shall be computed
   %
   % OUTPUT:  hashValue --> 32bit integer value of string's Adler-32 hash
   %         hashString --> readable string representation of hashValue
   %
   % NOTE: Slow runtime, so only to be used with small strings.
   %
   % Andreas Sommer, Aug2022
   % andreas.sommer@iwr.uni-heidelberg.de
   % code@andreas-sommer.eu

   % ensure instring is a char array
   instring = char(instring);
   
   % init
   s1 = 1;
   s2 = 0;

   % walk through string
   for i = 1:length(instring)
      s1 = mod(s1 + instring(i) , 65521); % 65521 = largest prime below 2^16
      s2 = mod(s2 + s1          , 65521);
   end

   % combine the two hashes
   hashValue = s1 + 2^16 * s2;
   
   % check how many outputs were requested
   if (nargout>=0), varargout{1} = hashValue;           end
   if (nargout>=2), varargout{2} = toString(hashValue); end

   % finito
   return
   
   
   % HELPERS
   function hString = toString(hValue32)
      % input is a 32bit unsigned integer, i.e. 8 nipples (4-bit numbers)
      charTable='abcdefghijklmnopqrstuvwxyz23456789';
      hString = '________';
      for k = 1:8
         idx = bitand(hValue32, 15) + 1;   % 15 = 2^4-1
         hString(k) = charTable(idx);
         hValue32 = bitshift(hValue32, -4, 'uint32');
      end
   end
   
end
