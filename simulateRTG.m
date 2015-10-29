function [T, We] = simulateRTG(params)

%% Initialize Params
puMass = params.puMass;

%% Test Flow Functions

sol = ode45(@RTGFlows, [0, 100], [puMass, 0]);

%% Plot
%disp(1)
plot(T,X);

end
