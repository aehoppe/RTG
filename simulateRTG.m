%% Your omegas are too high.

function [T] = simulateRTG(mass, threshold, params)
%% Unpack Params

puMass = mass;
puHalfLife = params.puHalfLife;
puEnergyPerKg = params.puEnergyPerKg;
emissivity = params.emissivity;
stefanBoltzmann = params.stefanBoltzmann;
puSpecificHeat = params.puSpecificHeat;
puSurfaceArea = params.puSurfaceArea;
powerThreshold = threshold;

simulationTimeout = 3000;

initialEnergy = 1499 * puMass * puSpecificHeat;

%% ODE options functions

options = odeset('OutputFcn', @output_fcn, 'MaxStep', 4);

%hard code vector for tracking electrical power output
%currentPowerOutput = 1;
We = [];

    function status = output_fcn(t, Y, flag)
        %calculate flows again, to see if we should stop.
        
        %don't run when flag
        if (strcmp(flag,'done'))
            return;
        end
        
        % unpack input vector
        rtgHeat = Y(2); % Second element: RTG heat energy stock

        envTemp = params.spaceTemp; %environment temperature
        myTemp = energyToTemp(rtgHeat, puMass, puSpecificHeat);

        heatLostWatts = puSurfaceArea * emissivity * stefanBoltzmann * ...
            (myTemp - envTemp)^4; % radiation
        
        % 6 percent efficient generation
        electricalPower = heatLostWatts * 0.064;
        
        %currentPowerOutput = electricalPower;
        %add to power tracking vector
        We = [We, electricalPower];
        
        %Stop if electricalPower is below the threshold
        if (electricalPower < powerThreshold)
            status = 1;
            simulationTimeout = t;
        else
            status = 0;
        end
        
    end
    
%     function [value, isterminal, direction] = events(~, ~)
%         value = currentPowerOutput - powerThreshold;
%         isterminal = 1;
%         direction = 0;
%     end

%% Test Flow Functions

[Times, Stocks] = ode23s(@RTGFlows, [0, simulationTimeout], [puMass, initialEnergy], options);
Masses = Stocks(:,1);
Energy = Stocks(:,2);

%if abs(We(end) - powerThreshold) < abs(We(end-1) - powerThreshold)
%    T = Times(end);
%else
    T = Times(end-1);
    simulationTimeout = Times(end-1);
%end

% length(Times)
% length(We)

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
%% Debugging/Validation Plotting
%{
hold on
figure();
plot(Times, energyToTemp(Energy, puMass, puSpecificHeat), 'r*-');
title(['RTG Temperature over ',num2str(simulationTimeout),' years']);
xlabel('Time(years)');
ylabel('Temperature(K)');
figure();
plot(Times, Masses, 'b*-');
title(['Active Fuel Mass over ',num2str(simulationTimeout),' years']);
xlabel('Time(years)');
ylabel('Mass(kg)');
figure();
plot(Times, We, 'g*-');
refline(0, params.powerThreshold);
title(['Power Output over ',num2str(simulationTimeout),' years']);
xlabel('Time(years)');
ylabel('Power(watts)');
%}
%% RTG Flow function
function res = RTGFlows(~, Y)

    % unpack input vector
    activeFuelMass = Y(1); % First element: Pu-238 mass stock
    rtgHeat = Y(2); % Second element: RTG heat energy stock

    % define flows
    dmdt = log(2) * (1 / puHalfLife) * activeFuelMass; % mass flow

    heatGenerated = dmdt * puEnergyPerKg; % radioactive decay energy

    envTemp = params.spaceTemp; %environment temperature
    myTemp = energyToTemp(rtgHeat, puMass, puSpecificHeat);

    heatLost =  3.1569e7 * puSurfaceArea * emissivity * stefanBoltzmann * ...
        (myTemp - envTemp)^4; % radiation


    % pack results (mass; heat energy)
    res = [-dmdt; heatGenerated - heatLost];

end


end

%% helper functions

function temp = energyToTemp (energy, mass, specificHeat)

    temp = energy / (mass * specificHeat);
    
end
