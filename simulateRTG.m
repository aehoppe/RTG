%% Your omegas are too high.

function [T, We] = simulateRTG(params)
%% Initialize Params

puMass = params.puMass;
puHalfLife = params.puHalfLife;
puEnergyPerKg = params.puEnergyPerKg;
emissivity = params.emissivity;
stefanBoltzmann = params.stefanBoltzmann;
puMass = params.puMass;
puSpecificHeat = params.puSpecificHeat;
puSurfaceArea = params.puSurfaceArea;

initialEnergy = 830 * puMass * puSpecificHeat;

%% Test Flow Functions

%options = odeset('OutputFcn',@outputFunction, 'Events', @events)
sol = ode45(@RTGFlows, [0, 100], [puMass, initialEnergy]);

%% Plot
%disp(1)
plot(sol.x, sol.y(2,:), 'r*');

%% ODE options functions



%% RTG Flow function
function res = RTGFlows(~, X)

% unpack input vector
activeFuelMass = X(1); % First element: Pu-238 mass stock
rtgHeat = X(2); % Second element: RTG heat energy stock

% define flows
dmdt = -(log(2) * (1 / puHalfLife) * activeFuelMass); % mass flow

dQdt = dmdt * puEnergyPerKg - ... % radioactive decay energy
    3.1569e7 * puSurfaceArea * emissivity * stefanBoltzmann * ...
    (energyToTemp(rtgHeat, puMass, puSpecificHeat)^4); % radiation

% pack results (mass; heat energy)
res = [dmdt; dQdt];

end


end

%% helper functions

function temp = energyToTemp (energy, mass, specificHeat)

    temp = energy / (mass * specificHeat);
    
end
