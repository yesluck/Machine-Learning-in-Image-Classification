function testLabelSet = SoftmaxB(importTrainData,importValidData,trainY,validY,type)

    for i=1:validY
        for j=1:256
            testData(i,j)=importValidData{1,i}(j);
        end
        label1(i)=importTrainData{2,i};
        if label1(i)==0
            label1(i)=6;
        end
    end
    
    trainData=zeros(trainY,256);
    group=zeros(trainY);
    for i=1:trainY
    	for j=1:256
            trainData(i,j)=(importTrainData{1,i}(j)-mean(importTrainData{1,i}))/var(importTrainData{1,i});
        end
        group(i)=importTrainData{2,i};
        if group(i)==0
            group(i)=6;
        end
    end
    
    M = trainY;     %数据集的行  
    N = 256;        %数据集的列  
    K = 6;          %划分的种类  
    alpha = 0.001;  %学习率  
    weights = ones(N, K);   %初始化权重  

    %利用随机梯度修改权重  
    weights = stochasticGradientAscent(trainData, group, M, weights, alpha);  

    %测试数据载入
    data1=testData;                      %测试样本特征集
    numTest=size(data1,1);
    testDataSet = data1;  
    label1(label1==0)=6;
    for i = 1:numTest  
    	testResult = testDataSet(i,:)*weights;  
        [C,I] = max(testResult);  
        testLabelSet(i,:) = I;  
    end 
    label1=label1';

%     if type==0
%         fid=fopen('SoftmaxBPredict.txt','w');
%         for i=1:validY
%             if testLabelSet(i)==6
%                 testLabelSet(i)=0;
%             end
%             if testLabelSet(i)>5
%                 testLabelSet(i)=5;
%             end
%             if testLabelSet(i)<0
%                 testLabelSet(i)=0;
%             end
%             fprintf(fid,'%d\n',testLabelSet(i));
%         end
%         fclose(fid);
%         correct=0;
%         for i=1:validY
%             error(i)=testLabelSet(i)-importValidData{2,i};
%             if(error(i)==0)
%                 correct=correct+1;
%             end
%         end
%         SoftmaxBaccuracy=correct/validY
    end
