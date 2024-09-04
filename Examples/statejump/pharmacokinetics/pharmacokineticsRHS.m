function dx = pharmacokineticsRHS(t, x, p)
%PHARMACOKINETICSRHS a model for how the concentration of a drug in a patient's bloodstream might vary over time
% with regular oral administrations of a drug.
% The drug in the bloodstream decays exponentially, with `serumHalfLife=p(3)` determining how quickly.
% To model absorption, we have a second state component that describes how much of the drug is in the patient's
% stomach. This also decays exponentially at a rate determined by `stomachHalfLife=p(4)`, with the blood
% concentration growing in proportion to amount of drug the stomach loses, modified by the parameters
% `bioavailability=p(5)` and `bloodVolume=p(6)` (in liters, needed to convert the absolute amount in the stomach
% to a concentration). Every `frequency=p(2)` time units (hours), a new dose is administered,
% modeled by the state jumping by [0; dose=p(1)].
    dose            = p(1);
    frequency       = p(2);
    serumHalfLife   = p(3);
    stomachHalfLife = p(4);
    bioavailability = p(5);
    bloodVolume     = p(6);

    lambdaSerum   = log(1/2) / serumHalfLife;
    lambdaStomach = log(1/2) / stomachHalfLife;

    serumConcentration = x(1);
    stomachAmount      = x(2);

    dx = zeros(2, 1);

    absorptionAmount = lambdaStomach * stomachAmount; % negative, since stomach amount decays exponentially
    dx(1) = lambdaSerum * serumConcentration - bioavailability*absorptionAmount/bloodVolume;
    dx(2) = absorptionAmount;

    % the sine has no meaning, i just needed any function that crosses zero every `frequency` time units
    ifdiff_jumpif(sin(pi*t / frequency), 0, [0; dose]);
end

