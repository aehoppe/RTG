 % Flow function for RTG heat flow model. Your omegas are too high.

function res = RTGFlows(~, X)

% unpack input vector
activeFuelMass = X(1); % First element: Pu-238 mass stock
rtgHeat = X(2); % Second element: RTG heat energy stock

puHalfLife = params.puHalfLife;
puEnergyPerKg = params.EnergyPerKg;
emissivity = params.emissivity;
stefanBoltzman = params.stefanBoltzman;
puMass = params.puMass;

% define flows
dmdt = -log(2) * (1 / puHalfLife) * activeFuelMass; % mass flow

dQdt = dmdt * puEnergyPerKg + ... % radioactive decay energy
    - emissivity * stefanBoltzman * ...
    (energyToTemp(rtgHeat, puMass, puSpecificHeat))^4; % radiation

% pack results (mass; heat energy)
res = [dmdt; dQdt];

end

function temp = energyToTemp (energy, mass, specificHeat)

    temp = energy / (mass * specificHeat);
    
end