% Initializes parameters for RTG model.

% Changeable variables
params.puMass = 4.8; % kg

% Plutonium geometry
params.puDensity = 19816; % kg/m^3
params.puVolume = params.puMass / params.puDensity; % m^3
params.puDiameter = .09; % m
params.puLength = params.puVolume / ((params.puDiameter/2)^2 * pi); % m

params.puSurfaceArea = params.puLength * params.puDiameter * pi; % m^2

% Other plutonium properties
params.puSpecificHeat = 1300; % J/(kg*K)
params.puDecayEnergy = 8.96 * 10^-13; % J/atom
params.puAtomsPerKg = 2.53 * 10^24; % atoms/kg
params.puEnergyPerKg = params.puDecayEnergy * params.puAtomsPerKg; % J/kg
params.puHalfLife = 87.7; % years

% Other RTG properties
params.emissivity = 0.9; % unitless 

% General Constants
params.stefanBoltzmann = 5.670e-8; % E m^-2 K^-4

