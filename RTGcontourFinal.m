%% Build vector set
Time = zeros(1,400);
Threshold = zeros(1,200);
Mass = zeros(200,400);

for i = 1:400
    Time (i) = i;
    disp([num2str(i/4), ' percent'])
    for j = 1:200
       Threshold(j) = j+100;
       Mass((j), i) = massLookup(j+100, i, Z);
    end
end

%% plot
imagesc(Time, Threshold, Mass);
colorbar
set(gca, 'YDir', 'normal')
title('Minimum Pu Mass for RTG Mission')
xlabel('Mission Duration (years)')
ylabel('Power Threshold (W)')