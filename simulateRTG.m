function [t, We] = simulateRTG()

%% Initialize Params
InitParams;

%% Test Flow Functions

[T, X] = ode45(@RTGFlows, [0, 100], [params.puMass, 0])

%% Plo
disp(1)



end
