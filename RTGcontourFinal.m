%% Build vector set
Time = zeros(1,300);
Threshold = zeros(1,200);
Mass = zeros(200,300);

for i = 1:300
    Time (i) = i;
    disp([num2str(i/3), ' percent'])
    for j = 1:200
       Threshold(j) = j+100;
       Mass((j), i) = massLookup(j+100, i, Z);
    end
end

%% plot
imagesc(Time, Threshold, Mass);
hcb=colorbar;
set(gca, 'YDir', 'normal')
title('Minimum ^{238}Pu Mass for RTG Missions')
xlabel('Mission Duration (years)')
ylabel('Power Threshold (W)')
ylabel(hcb, 'Required ^{238}Pu Mass (kg)')
