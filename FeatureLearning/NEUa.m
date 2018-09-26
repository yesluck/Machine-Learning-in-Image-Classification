function classifybayesResult = NEUa(importTrainData,importValidData,trainY,validY,type)
    
    for i=1:trainY
        for j=1:256
            trainData(i,j)=importTrainData{1,i}(j);
        end
        group(i)=importTrainData{2,i};
    end
    
    for i=1:validY
        for j=1:256
            testData(i,j)=importValidData{1,i}(j);
        end
    end
%     
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     %LMÍøÂç10²ã
%     for i=1:validY
%         classifylmResult(i)=round(lmNeuralNetworkFunction(testData(i)));
%         if(classifylmResult(i)>5)
%             classifylmResult(i)=5;
%         end
%         if(classifylmResult(i)<0)
%             classifylmResult(i)=0;
%         end
%     end
%     
%     if type==0
%         correct=0;
%         for i=1:validY
%             error(i)=classifylmResult(i)-importValidData{2,i};
%             if(error(i)==0)
%                 correct=correct+1;
%             end
%         end
%         lmNEUaccuracy=correct/validY
% 
%         fid=fopen('lmNEUPredict.txt','w');
%         for i=1:validY
%             fprintf(fid,'%d\n',classifylmResult(i));
%         end
%         fclose(fid);
%     end
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     %LMÍøÂç20²ã
%     for i=1:validY
%         classifylm2Result(i)=round(lm2NeuralNetworkFunction(testData(i)));
%         if(classifylm2Result(i)>5)
%             classifylm2Result(i)=5;
%         end
%         if(classifylm2Result(i)<0)
%             classifylm2Result(i)=0;
%         end
%     end
%     
%     if type==0
%         correct=0;
%         for i=1:validY
%             error(i)=classifylm2Result(i)-importValidData{2,i};
%             if(error(i)==0)
%                 correct=correct+1;
%             end
%         end
%         lm2NEUaccuracy=correct/validY
% 
%         fid=fopen('lm2NEUPredict.txt','w');
%         for i=1:validY
%             fprintf(fid,'%d\n',classifylm2Result(i));
%         end
%         fclose(fid);
%     end


    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %BayesÍøÂç10²ã
    for i=1:validY
        classifybayesResult(i)=round(bayesNeuralNetworkFunction(testData(i)));
        if(classifybayesResult(i)>5)
            classifybayesResult(i)=5;
        end
        if(classifybayesResult(i)<0)
            classifybayesResult(i)=0;
        end
    end
    
%     if type==0
%         correct=0;
%         for i=1:validY
%             error(i)=classifybayesResult(i)-importValidData{2,i};
%             if(error(i)==0)
%                 correct=correct+1;
%             end
%         end
%         bayesNEUaccuracy=correct/validY
%  
%         fid=fopen('bayesNEUPredict.txt','w');
%         for i=1:validY
%             fprintf(fid,'%d\n',classifybayesResult(i));
%         end
%         fclose(fid);
%     end
    
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     %BayesÍøÂç20²ã
%     for i=1:validY
%         classifybayes2Result(i)=round(bayes2NeuralNetworkFunction(testData(i)));
%         if(classifybayes2Result(i)>5)
%             classifybayes2Result(i)=5;
%         end
%         if(classifybayes2Result(i)<0)
%             classifybayes2Result(i)=0;
%         end
%     end
%     
%     if type==0
%         correct=0;
%         for i=1:validY
%             error(i)=classifybayes2Result(i)-importValidData{2,i};
%             if(error(i)==0)
%                 correct=correct+1;
%             end
%         end
%         bayes2NEUaccuracy=correct/validY
% 
%         fid=fopen('bayes2NEUPredict.txt','w');
%         for i=1:validY
%             fprintf(fid,'%d\n',classifybayes2Result(i));
%         end
%         fclose(fid);
%     end
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     %SCÍøÂç10²ã
%     for i=1:validY
%         classifyscResult(i)=round(scNeuralNetworkFunction(testData(i)));
%         if(classifyscResult(i)>5)
%             classifyscResult(i)=5;
%         end
%         if(classifyscResult(i)<0)
%             classifyscResult(i)=0;
%         end
%     end
%     
%     if type==0
%         correct=0;
%         for i=1:validY
%             error(i)=classifyscResult(i)-importValidData{2,i};
%             if(error(i)==0)
%                 correct=correct+1;
%             end
%         end
%         scNEUaccuracy=correct/validY
% 
%         fid=fopen('scNEUPredict.txt','w');
%         for i=1:validY
%             fprintf(fid,'%d\n',classifyscResult(i));
%         end
%         fclose(fid);
%     end
%     
end