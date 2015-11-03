function mass = massLookup(threshold, missionLength, Table)
    
    %check input
    if(threshold < 1)
        return
    end
    
    index = 1;
    
    while(Table(threshold-100, index) < missionLength)
        index = index + 1;
    end
    mass = index/10;
end