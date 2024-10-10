function expectedSwitches = bounceballSwitches(numSwitches, v0, g, gamma)
%BOUNCEBALLSWITCHES Compute the first n (numSwitches) switching points expected in the bouncing ball problem.
% In the exact version, switch #i is computed as (2*v0/g)*(1 + gamma + ... + gamma^(i-1))
    expectedSwitches = zeros(1, numSwitches);
    firstBounce = (2*v0/g);
    swp = firstBounce;
    expectedSwitches(1) = swp;
    for i=2:numSwitches
        swp = swp*gamma + firstBounce;
        expectedSwitches(i) = swp;
    end
end