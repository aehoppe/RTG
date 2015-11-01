%% Your omegas are too high.

function [T, We] = simulateRTG(params)
%% Initialize Params
InitParams;

puMass = params.puMass;
puHalfLife = params.puHalfLife;
puEnergyPerKg = params.puEnergyPerKg;
emissivity = params.emissivity;
stefanBoltzmann = params.stefanBoltzmann;
puMass = params.puMass;
puSpecificHeat = params.puSpecificHeat;
puSurfaceArea = params.puSurfaceArea;

simulationTimeout = 300;

initialEnergy = 1499 * puMass * puSpecificHeat;

%% ODE options functions

%options = odeset('OutputFcn',@outputFunction, 'Events', @events)

%% Test Flow Functions

[Times, Stocks] = ode23s(@RTGFlows, [0, simulationTimeout], [puMass, initialEnergy]);
Masses = Stocks(:,1);
Energy = Stocks(:,2);

%{
activeMass = puMass;
currentEnergy = initialEnergy;

Times = zeros(1,100);
Energy = zeros(1,100);
Masses = zeros(1,100);

for i=1:10 * 1e5
    Times(i) = i * 1e-5;
    Energy(i) = currentEnergy;
    Masses(i) = activeMass;
    results = 1e-5*RTGFlows(Times(i),[activeMass, currentEnergy]);
    activeMass = activeMass + results(1);
    currentEnergy = currentEnergy + results(2);
end
%}
%% Plot

%hold on
figure();
plot(Times, energyToTemp(Energy, puMass, puSpecificHeat), 'r*-');
title(['RTG Temperature over ',char(simulationTimeout),' years']);
xlabel('Time(years)');
ylabel('Temperature(K)');
figure();
plot(Times, Masses, 'b*-');
title(['Active Fuel Mass over ',char(simulationTimeout),' years']);
xlabel('Time(years)');
ylabel('Mass(kg)');

%% RTG Flow function
function res = RTGFlows(~, X)

% unpack input vector
activeFuelMass = X(1); % First element: Pu-238 mass stock
rtgHeat = X(2); % Second element: RTG heat energy stock

% define flows
dmdt = log(2) * (1 / puHalfLife) * activeFuelMass; % mass flow
if rtgHeat < 0
    %disp('get mad');
end

heatGenerated = dmdt * puEnergyPerKg; % radioactive decay energy

envTemp = 2; %environment temperature
myTemp = energyToTemp(rtgHeat, puMass, puSpecificHeat);

heatLost =  3.1569e7 * puSurfaceArea * emissivity * stefanBoltzmann * ...
    (myTemp - envTemp)^4; % radiation
   
if myTemp < envTemp
    heatLost = -abs(heatLost);
end

% pack results (mass; heat energy)
res = [-dmdt; heatGenerated - heatLost];

end


end

%% helper functions

function temp = energyToTemp (energy, mass, specificHeat)

    temp = energy / (mass * specificHeat);
    
end
