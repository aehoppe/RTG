%% Your omegas are too high.

function [T, We] = simulateRTG(params)
%% Initialize Params

puMass = params.puMass;

%% Test Flow Functions

sol = ode45(@RTGFlows, [0, 100], [puMass, 0]);

%% Plot
%disp(1)
plot(T,X);

%% Flow function for RTG heat flow model.
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


end

%% helper functions

function temp = energyToTemp (energy, mass, specificHeat)

    temp = energy / (mass * specificHeat);
    
end
