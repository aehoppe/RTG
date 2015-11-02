X = [];
Y = [];
Z = [];

for i = 1:20
    X(i) = i;
    for j = 101:300
       Y(j-100) = j;
       Z((j-100), i) = simulateRTG(i, j, params);
    end
end

contourf(X, Y, Z);
title('Operational time of an RTG')
xlabel('Mass of Plutonium (kg)')
ylabel('Power Threshold (W)')