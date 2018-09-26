function Interface(picturename,txt)
    
    Pick('train_forstu.pickle');
    importTrainData = importdata('train_forstu.pickle.mat');
    
    Pick('valid_forstu.pickle');
    importValidData = importdata('valid_forstu.pickle.mat');
    
    [~,trainY] = size(importTrainData);
    [~,validY] = size(importValidData);
    
    %Interface('101.jpg', 'cup_dataset/valid_img_forstu/label.txt')
    text=importdata(txt);
    for i=1:validY
        if(strcmp(picturename,text.textdata{i+1,1})==1)
%             text=importdata(txt);
%             iIndex=strfind(text.textdata{i+1,1},'.');
%             for j=1:iIndex-1
%                 digit(j)=text.textdata{i+1,1}(j);
%             end
%             d=str2num(digit);

            %ÑµÁ·
            SVMa(importTrainData,importValidData(2*i-1),trainY,1,1);
            kNNa(importTrainData,importValidData(2*i-1),trainY,1,1);
            %NEUa(importTrainData,importValidData(i-1),trainY,1,1);
            
            break;
        end
    end
    
    
    

end