 % Flow function for RTG heat flow model. Your omegas are too high.

function res = RTGFlows(t, X)

% unpack input vector
activeFuelMass = X(1); % First element: Pu-238 mass stock
rtgHeat = X(2); % Second element: RTG heat energy stock

% define flows
dmdt = -log(2) * (1 / params.puHalfLife) * activeFuelMass; % mass flow

dQdt = dmdt * params.puEnergyPerKg + ... % radioactive decay energy
    - params.emissivity * params.stefanBoltzman * ...
    (energyToTemp(rtgHeat, params.puMass, puSpecificHeat))^4; % radiation

% pack results (mass; heat energy)
res = [dmdt; dQdt];

end

function temp = energyToTemp (energy, mass, specificHeat)

    temp = energy / (mass * specificHeat);
    
end