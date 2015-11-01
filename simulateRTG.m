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

%initialEnergy = 830 * puMass * puSpecificHeat;
initialEnergy = 830 * 4.8 * 1300;

%% Test Flow Functions

%options = odeset('OutputFcn',@outputFunction, 'Events', @events)
%sol = ode45(@RTGFlows, [0, 100], [puMass, initialEnergy]);

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

%% Plot
%disp(1)
%plot(sol.x, sol.y(2,:), 'r*');
hold on
plot(Times, energyToTemp(Energy, puMass, puSpecificHeat), 'r*-');
%plot(Times, Masses, 'b*-');
xlabel('Years');
%% ODE options functions



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

envTemp = 100; %environment temperature
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
