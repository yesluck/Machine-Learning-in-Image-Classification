function classifyFinal = kNNa(importTrainData,importValidData,trainY,validY,type)
    
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
    
    classifyFinal=knnclassify(testData,trainData,group);

%     if type==0
%         correct=0;
%         for i=1:validY
%             error(i)=classifyFinal(i)-importValidData{2,i};
%             if(error(i)==0)
%                 correct=correct+1;
%             end
%         end
% 
%         fid=fopen('kNNaPredict.txt','w');
%         for i=1:validY
%             fprintf(fid,'%d\n',classifyFinal(i));
%         end
%         fclose(fid);  
%     end

    
end