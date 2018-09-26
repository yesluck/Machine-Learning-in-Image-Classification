function classifyFinal = SVMa(importTrainData,importValidData,trainY,validY,type)
    
    flag=zeros(6);
    for i=1:trainY-1
        if(importTrainData{2,i}~=importTrainData{2,i+1})
            for j=1:5
                if(importTrainData{2,i}==j-1)
                	flag(j)=i;
                end
            end
        end
    end
    flag(6)=trainY;
    
    %测试集导入
    for i=1:validY
        for j=1:256
            testData(i,j)=importValidData{1,i}(j);
        end
    end
    
    %训练集导入
    %SVM仅能进行两组间的分类，为了能够分类为6组，需要进行两两训练，共需要进行15组训练
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %第1组训练：0 pk 1
    
    for i=1:flag(2)
        for j=1:256
        	trainData1(i,j)=importTrainData{1,i}(j);
        end
        group1(i)=importTrainData{2,i};
    end
    
%     size(trainData1)
%     size(group1)
    
    svmStruct = svmtrain(trainData1,group1);
    classifyGroup1 = svmclassify(svmStruct,testData);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %第2组训练：1 pk 2
    
    for i=flag(1)+1:flag(3)
        for j=1:256
        	trainData2(i-flag(1),j)=importTrainData{1,i}(j);
        end
        group2(i-flag(1))=importTrainData{2,i};
    end
    
    svmStruct = svmtrain(trainData2,group2);
    classifyGroup2 = svmclassify(svmStruct,testData);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %第3组训练：2 pk 3
    
    for i=flag(2)+1:flag(4)
        for j=1:256
        	trainData3(i-flag(2),j)=importTrainData{1,i}(j);
        end
        group3(i-flag(2))=importTrainData{2,i};
    end
    
    svmStruct = svmtrain(trainData3,group3);
    classifyGroup3 = svmclassify(svmStruct,testData);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %第4组训练：3 pk 4
    
    for i=flag(3)+1:flag(5)
        for j=1:256
        	trainData4(i-flag(3),j)=importTrainData{1,i}(j);
        end
        group4(i-flag(3))=importTrainData{2,i};
    end
    
    svmStruct = svmtrain(trainData4,group4);
    classifyGroup4 = svmclassify(svmStruct,testData);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %第5组训练：4 pk 5
    
    for i=flag(4)+1:flag(6)
        for j=1:256
        	trainData5(i-flag(4),j)=importTrainData{1,i}(j);
        end
        group5(i-flag(4))=importTrainData{2,i};
    end
    
    svmStruct = svmtrain(trainData5,group5);
    classifyGroup5 = svmclassify(svmStruct,testData);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %第6组训练：0 pk 2
    
    for i=1:flag(1)
        for j=1:256
        	trainData6(i,j)=importTrainData{1,i}(j);
        end
        group6(i)=importTrainData{2,i};
    end
    for i=flag(2)+1:flag(3)
        for j=1:256
        	trainData6(i+flag(1)-flag(2),j)=importTrainData{1,i}(j);
        end
        group6(i+flag(1)-flag(2))=importTrainData{2,i};
    end
    
    svmStruct = svmtrain(trainData6,group6);
    classifyGroup6 = svmclassify(svmStruct,testData);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %第7组训练：1 pk 3
    
    for i=flag(1)+1:flag(2)
        for j=1:256
        	trainData7(i-flag(1),j)=importTrainData{1,i}(j);
        end
        group7(i-flag(1))=importTrainData{2,i};
    end
    for i=flag(3)+1:flag(4)
        for j=1:256
        	trainData7(i-flag(1)+flag(2)-flag(3),j)=importTrainData{1,i}(j);
        end
        group7(i-flag(1)+flag(2)-flag(3))=importTrainData{2,i};
    end
    
    svmStruct = svmtrain(trainData7,group7);
    classifyGroup7 = svmclassify(svmStruct,testData);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %第8组训练：2 pk 4
    
    for i=flag(2)+1:flag(3)
        for j=1:256
        	trainData8(i-flag(2),j)=importTrainData{1,i}(j);
        end
        group8(i-flag(2))=importTrainData{2,i};
    end
    for i=flag(4)+1:flag(5)
        for j=1:256
        	trainData8(i-flag(2)+flag(3)-flag(4),j)=importTrainData{1,i}(j);
        end
        group8(i-flag(2)+flag(3)-flag(4))=importTrainData{2,i};
    end
    
    svmStruct = svmtrain(trainData8,group8);
    classifyGroup8 = svmclassify(svmStruct,testData);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %第9组训练：3 pk 5
    
    for i=flag(3)+1:flag(4)
        for j=1:256
        	trainData9(i-flag(3),j)=importTrainData{1,i}(j);
        end
        group9(i-flag(3))=importTrainData{2,i};
    end
    for i=flag(5)+1:flag(6)
        for j=1:256
        	trainData9(i-flag(3)+flag(4)-flag(5),j)=importTrainData{1,i}(j);
        end
        group9(i-flag(3)+flag(4)-flag(5))=importTrainData{2,i};
    end
    
    svmStruct = svmtrain(trainData9,group9);
    classifyGroup9 = svmclassify(svmStruct,testData);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %第10组训练：0 pk 3
    
    for i=1:flag(1)
        for j=1:256
        	trainData10(i,j)=importTrainData{1,i}(j);
        end
        group10(i)=importTrainData{2,i};
    end
    for i=flag(3)+1:flag(4)
        for j=1:256
        	trainData10(i+flag(1)-flag(3),j)=importTrainData{1,i}(j);
        end
        group10(i+flag(1)-flag(3))=importTrainData{2,i};
    end
    
    svmStruct = svmtrain(trainData10,group10);
    classifyGroup10 = svmclassify(svmStruct,testData);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %第11组训练：1 pk 4
    
    for i=flag(1)+1:flag(2)
        for j=1:256
        	trainData11(i-flag(1),j)=importTrainData{1,i}(j);
        end
        group11(i-flag(1))=importTrainData{2,i};
    end
    for i=flag(4)+1:flag(5)
        for j=1:256
        	trainData11(i-flag(1)+flag(2)-flag(4),j)=importTrainData{1,i}(j);
        end
        group11(i-flag(1)+flag(2)-flag(4))=importTrainData{2,i};
    end
    
    svmStruct = svmtrain(trainData11,group11);
    classifyGroup11 = svmclassify(svmStruct,testData);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %第12组训练：2 pk 5
    
    for i=flag(2)+1:flag(3)
        for j=1:256
        	trainData12(i-flag(2),j)=importTrainData{1,i}(j);
        end
        group12(i-flag(2))=importTrainData{2,i};
    end
    for i=flag(5)+1:flag(6)
        for j=1:256
        	trainData12(i-flag(2)+flag(3)-flag(5),j)=importTrainData{1,i}(j);
        end
        group12(i-flag(2)+flag(3)-flag(5))=importTrainData{2,i};
    end
    
    svmStruct = svmtrain(trainData12,group12);
    classifyGroup12 = svmclassify(svmStruct,testData);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %第13组训练：0 pk 4
    
    for i=1:flag(1)
        for j=1:256
        	trainData13(i,j)=importTrainData{1,i}(j);
        end
        group13(i)=importTrainData{2,i};
    end
    for i=flag(4)+1:flag(5)
        for j=1:256
        	trainData13(i+flag(1)-flag(4),j)=importTrainData{1,i}(j);
        end
        group13(i+flag(1)-flag(4))=importTrainData{2,i};
    end
    
    svmStruct = svmtrain(trainData13,group13);
    classifyGroup13 = svmclassify(svmStruct,testData);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %第14组训练：1 pk 5
    
    for i=flag(1)+1:flag(2)
        for j=1:256
        	trainData14(i-flag(1),j)=importTrainData{1,i}(j);
        end
        group14(i-flag(1))=importTrainData{2,i};
    end
    for i=flag(5)+1:flag(6)
        for j=1:256
        	trainData14(i-flag(1)+flag(2)-flag(5),j)=importTrainData{1,i}(j);
        end
        group14(i-flag(1)+flag(2)-flag(5))=importTrainData{2,i};
    end
    
    svmStruct = svmtrain(trainData14,group14);
    classifyGroup14 = svmclassify(svmStruct,testData);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %第15组训练：0 pk 5
    
    for i=1:flag(1)
        for j=1:256
        	trainData15(i,j)=importTrainData{1,i}(j);
        end
        group15(i)=importTrainData{2,i};
    end
    for i=flag(5)+1:flag(6)
        for j=1:256
        	trainData15(i-flag(1)+flag(2)-flag(6),j)=importTrainData{1,i}(j);
        end
        group15(i-flag(1)+flag(2)-flag(6))=importTrainData{2,i};
    end
    
    svmStruct = svmtrain(trainData15,group15);
    classifyGroup15 = svmclassify(svmStruct,testData);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    for i=1:validY
        a=[classifyGroup1(i),classifyGroup2(i),classifyGroup3(i),classifyGroup4(i),classifyGroup5(i),classifyGroup6(i),classifyGroup7(i),classifyGroup8(i),classifyGroup9(i),classifyGroup10(i),classifyGroup11(i),classifyGroup12(i),classifyGroup13(i),classifyGroup14(i),classifyGroup15(i)];
        b=0:5;
        c=histc(a,b);
        [~, max_index] = max(c);
        max_element=b(max_index);
        classifyFinal(i)=max_element;
    end

%     if type==0
%         correct=0;
%         for i=1:validY
%             error(i)=classifyFinal(i)-importValidData{2,i};
%             if(error(i)==0)
%                 correct=correct+1;
%             end
%         end
%         SVMaccuracy=correct/validY
% 
%         fid=fopen('SVMaPredict.txt','w');
%         for i=1:validY
%             fprintf(fid,'%d\n',classifyFinal(i));
%         end
%         fclose(fid);  
%     end
%     
%     if type==1
%         a=[classifyGroup1(1),classifyGroup2(1),classifyGroup3(1),classifyGroup4(1),classifyGroup5(1),classifyGroup6(1),classifyGroup7(1),classifyGroup8(1),classifyGroup9(1),classifyGroup10(1),classifyGroup11(1),classifyGroup12(1),classifyGroup13(1),classifyGroup14(1),classifyGroup15(1)];
%         b=0:5;
%         c=histc(a,b);
%         [~, max_index] = max(c);
%         max_element=b(max_index)
%     end
end