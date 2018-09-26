function SoftmaxA(importTrainData,importValidData,trainY,validY,type)
    
    for i=1:validY
        for j=1:256
            testData(i,j)=importValidData{1,i}(j);
        end
    end
    
    group=zeros(trainY,6);
    for i=1:trainY
            for j=1:256
                trainData(i,j)=(importTrainData{1,i}(j)-mean(importTrainData{1,i}))/var(importTrainData{1,i});
            end
            if importTrainData{2,i} == 0
                group(i,1)=1;
            end
            if importTrainData{2,i} == 1
                group(i,2)=1; 
            end
            if importTrainData{2,i} == 2
                group(i,3)=1; 
            end
            if importTrainData{2,i} == 3
                group(i,4)=1; 
            end
            if importTrainData{2,i} == 4
                group(i,5)=1; 
            end
            if importTrainData{2,i} == 5
                group(i,6)=1; 
            end
    end

    net=trainSoftmaxLayer(trainData',group','MaxEpochs',3000);
    trainMatrix=net(testData')';
    
    for i=1:validY
        [~, max_index] = max(trainMatrix(i));
        for j=1:6
            if trainMatrix(i,j)==max_index
                classifyFinal(i)=j-1;
            end
        end
    end
    
    if type==0
        correct=0;
        for i=1:validY
            error(i)=classifyFinal(i)-importValidData{2,i};
            if(error(i)==0)
                correct=correct+1;
            end
        end
        SoftmaxAaccuracy=correct/validY

        fid=fopen('SoftmaxAPredict.txt','w');
        for i=1:validY
            fprintf(fid,'%d\n',classifyFinal(i));
        end
        fclose(fid);  
    end
    
    if type==1
        classifyFinal
    end
    
end