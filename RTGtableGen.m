%% Build data set
X = zeros(1,90);
Y = zeros(1,200);
Z =zeros(200,90);

for i = 1:90
    X(i) = i/10;
    disp([num2str(i/(9/10)), ' percent'])
    for j = 1:200
       Y(j) = j+100;
       Z((j), i) = simulateRTG(i, j+100, params);
    end
end

%% plot
contourf(X, Y, Z);
title('Operational time of an RTG')
xlabel('Mass of Plutonium (kg)')
ylabel('Power Threshold (W)')