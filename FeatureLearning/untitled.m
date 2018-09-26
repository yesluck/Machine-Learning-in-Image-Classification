    for i=1:validY
        for j=1:256
            testData(i,j)=importValidData{1,i}(j);
        end
    end
    
    for i=1:trainY
        for j=1:256
            trainData(i,j)=importTrainData{1,i}(j);
        end
        group(i)=importTrainData{2,i};
    end
    groupIn=group';
    
    save testData;
    save trainData;
    save groupIn;