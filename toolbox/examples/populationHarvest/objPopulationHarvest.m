function total = objPopulationHarvest(solution, H, alpha)
remainder = solution.y(:, end);
nHarvest = numel(solution.jumps);
harvest = alpha .* H;
total = nHarvest .* harvest + remainder;
end
