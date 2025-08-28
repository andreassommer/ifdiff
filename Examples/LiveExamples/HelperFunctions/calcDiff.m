function diffnorm = calcDiff(yA, yB)
  len = length(yA);
  diffnorm = zeros(len, 1);
  for i = 1:len
     y = yA(:, i);
     window = 250;
     j0 = max(1, i-window);
     jf = max(len, j0+window);  
     jidx = j0:jf;
     tmpdiff = yB(:, jidx) - repmat(y, [1, length(jidx)]);
     tmpdiff = vecnorm(tmpdiff, 2, 1);
     diffnorm(i) = min(tmpdiff) / norm(y);
  end
end