function Character(m, val_dir)
% val_dir = 'cup_dataset/valid_img_forstu/'
    if m==1
        text=importdata('cup_dataset/train_img_forstu/label.txt');
        for i=1:2857
            img=imread(['cup_dataset/train_img_forstu/',text.textdata{i+1,1}]);
            list=HOG(img);
            list=list';

            Data{1,i}=list;
            Data{2,i}=text.data(i);
            
        end
         
        save train_mine Data;
    end
    
    if m==2
        text=importdata([val_dir, '/label.txt']);
        for i=1:905
            img=imread([val_dir,'/', text.textdata{i+1,1}]);
            list=HOG(img);
            list=list';

            Data{1,i}=list;
            Data{2,i}=text.data(i);

        end
        
        save valid_mine Data;
        
    end
    
end