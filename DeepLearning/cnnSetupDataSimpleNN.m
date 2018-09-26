function imdb =cnnSetupDataSimpleNN(trainDir, validDir, inputSize)

imdb.images.data=[];
imdb.images.labels=[];
imdb.images.set = [] ;
imdb.meta.sets = {'train', 'val', 'test'} ;

for i = 1:6
   imdb.meta.classes(i) = num2str(i); 
end

% trainDir = 'F:\DataAndLearning\cup_dataset\train_img_forstu';
trainLabel = importdata(fullfile(trainDir, 'label.txt'));
trainLabel.textdata = trainLabel.textdata(2:end, 1);

for i = 1:length(trainLabel.textdata)
    imgName = trainLabel.textdata(i);
    img = imread(fullfile(trainDir, imgName{:}));
    img = imresize(img, inputSize(1:2));
    img = single(img);
    imdb.images.data(:, :, :, end+1) = single(img);
    imdb.images.labels(end+1) = trainLabel.data(i)+1;
    imdb.images.set(end+1) = 1;
end

disp('Prepare data for trainning ... Done');
disp([num2str(i), ' images was processed totally. ']);

% validDir = 'F:\DataAndLearning\cup_dataset\valid_img_forstu';
validLabel = importdata(fullfile(validDir, 'label.txt'));
validLabel.textdata = validLabel.textdata(2:end, 1);

for j = 1:length(validLabel.textdata)
    imgName = validLabel.textdata(j);
    img = imread(fullfile(validDir, imgName{:}));
    img = imresize(img, inputSize(1:2));
    img = single(img);
    imdb.images.data(:, :, :, end+1) = single(img);
    imdb.images.labels(end+1) = validLabel.data(j)+1;
    imdb.images.set(end+1) = 3;
end

disp('Prepare data for trainning ... Done');
disp([num2str(j), ' images was processed totally. ']);

dataMean=mean(imdb.images.data,4);
imdb.images.data = single(bsxfun(@minus,imdb.images.data, dataMean)) ;
imdb.images.data_mean = single(dataMean);%!!!!!!!!!!!
end
