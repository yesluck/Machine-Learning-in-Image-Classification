function varargout = gui(varargin)
% GUI MATLAB code for gui.fig
%      GUI, by itself, creates a new GUI or raises the existing
%      singleton*.
%
%      H = GUI returns the handle to a new GUI or the handle to
%      the existing singleton*.
%
%      GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI.M with the given input arguments.
%
%      GUI('Property','Value',...) creates a new GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui

% Last Modified by GUIDE v2.5 30-Nov-2016 14:02:51

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT
end

% --- Executes just before gui is made visible.
function gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui (see VARARGIN)

% Choose default command line output for gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);
end

% --- Outputs from this function are returned to the command line.
function varargout = gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
end


function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double
end

% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double
end

% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


%=======================================================================
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% --- Executes on button press in pushbutton1.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%=======================================================================
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
addpath DeepLearning
addpath FeatureLearning

% !!!!!!!!!!!!!!!!!
matconvnetDir = 'E:\DevEnvironment\matconvnet-1.0-beta23';

    
dir = get(handles.edit1, 'string');
pickle = get(handles.edit2, 'string');

% ========================================================================
% Vgg Net
% ========================================================================
if get(handles.radiobutton14, 'value')
    set(handles.text3, 'string', '>>> Setting up environmen...');
    pause(0.000001);
    matlabDir = [matconvnetDir, '/matlab'];
    run(fullfile(matlabDir, 'vl_setupnn.m'));

    validLabel = importdata(fullfile(dir, 'label.txt'));
    validLabel.textdata = validLabel.textdata(2:end, 1);

    set(handles.text3, 'string', '>>> Loading model');
    pause(0.000001);
    net1 = dagnn.DagNN.loadobj(load(['DeepLearning\exp-vgg','\image\net-deployed.mat'])) ;
    net1.mode = 'test' ;


    total = length(validLabel.textdata);
    correct = 0;
    name = {};
    pred = [];

    set(handles.text3, 'string', '>>> Testing...');
    pause(0.000001);

    for i = 1:length(validLabel.textdata)
        imgName = validLabel.textdata(i);
        img = imread(fullfile(dir, imgName{:}));
        label = (validLabel.data(i)+1);

        im_ = single(img);
        im_ = imresize(im_, net1.meta.normalization.imageSize(1:2)) ;

        im_ = bsxfun(@minus, im_, net1.meta.normalization.averageImage) ;
        % ??
        net1.eval({'input',im_}) ;
        scores = net1.vars(net1.getVarIndex('prob')).value ;
        scores = squeeze(gather(scores)) ;

        [bestScore, best] = max(scores) ;
        if best == label
            correct = correct + 1;
        end

        axes(handles.axes1);
        imshow(img);
        str1 = ['--  Predicted Class: ', num2str(best-1)];
        str2 = ['--  Truth Class: ', num2str(label-1)];
        str3 = ['__________________________'];
        str4 = ['-- Current Accuracy: ', num2str(100*correct/total), '%'];

        set(handles.text2, 'string', [str1, 10, str2, 10, str3, 10, 10, str4]);
        pause(0.000001);

        name{i} = imgName;
        pred(i) = best;
    end
    
    name = horzcat(name{:});
    
    set(handles.text3, 'string', '>>> Writing results to result-vgg.txt...');
    pause(0.000001);
    fid = fopen('result-vgg.txt', 'w');
    for i = 1:numel(name)
        tmp = name(i);
        fprintf(fid, '%s  %d \n', tmp{1}, pred(i)); 
    end
    fclose(fid);
    set(handles.text3, 'string', '>>> Finish. ');
end

% ========================================================================
% Res Net - 50
% ========================================================================
if get(handles.radiobutton15, 'value')
    set(handles.text3, 'string', '>>> Setting up environmen...');
    pause(0.000001);
    matlabDir = [matconvnetDir, '/matlab'];
    run(fullfile(matlabDir, 'vl_setupnn.m'));

    validLabel = importdata(fullfile(dir, 'label.txt'));
    validLabel.textdata = validLabel.textdata(2:end, 1);

    set(handles.text3, 'string', '>>> Loading model');
    pause(0.000001);
    net1 = dagnn.DagNN.loadobj(load(['DeepLearning\exp-res1','\image\net-deployed.mat'])) ;
    net1.mode = 'test' ;


    total = length(validLabel.textdata);
    correct = 0;
    name = {};
    pred = [];

    set(handles.text3, 'string', '>>> Testing...');
    pause(0.000001);

    for i = 1:length(validLabel.textdata)
        imgName = validLabel.textdata(i);
        img = imread(fullfile(dir, imgName{:}));
        label = (validLabel.data(i)+1);

        im_ = single(img);
        im_ = imresize(im_, net1.meta.normalization.imageSize(1:2)) ;

        im_ = bsxfun(@minus, im_, net1.meta.normalization.averageImage) ;
        % ??
        net1.eval({'input',im_}) ;
        scores = net1.vars(net1.getVarIndex('prob')).value ;
        scores = squeeze(gather(scores)) ;

        [bestScore, best] = max(scores) ;
        if best == label
            correct = correct + 1;
        end

        axes(handles.axes1);
        imshow(img);
        str1 = ['--  Predicted Class: ', num2str(best-1)];
        str2 = ['--  Truth Class: ', num2str(label-1)];
        str3 = ['__________________________'];
        str4 = ['-- Current Accuracy: ', num2str(100*correct/total), '%'];

        set(handles.text2, 'string', [str1, 10, str2, 10, str3, 10, 10, str4]);
        pause(0.000001);

        name{i} = imgName;
        pred(i) = best;
    end
    
    name = horzcat(name{:});
    
    set(handles.text3, 'string', '>>> Writing results to result-res-50.txt...');
    pause(0.000001);
    fid = fopen('result-res-50.txt', 'w');
    for i = 1:numel(name)
        tmp = name(i);
        fprintf(fid, '%s  %d \n', tmp{1}, pred(i)); 
    end
    fclose(fid);
    set(handles.text3, 'string', '>>> Finish. ');
end

% ========================================================================
% Res Net - 152
% ========================================================================
if get(handles.radiobutton18, 'value')
    set(handles.text3, 'string', '>>> Setting up environmen...');
    pause(0.000001);
    matlabDir = [matconvnetDir, '/matlab'];
    run(fullfile(matlabDir, 'vl_setupnn.m'));

    validLabel = importdata(fullfile(dir, 'label.txt'));
    validLabel.textdata = validLabel.textdata(2:end, 1);

    set(handles.text3, 'string', '>>> Loading model');
    pause(0.000001);
    net1 = dagnn.DagNN.loadobj(load(['DeepLearning\exp-res2','\image\net-deployed.mat'])) ;
    net1.mode = 'test' ;


    total = length(validLabel.textdata);
    correct = 0;
    name = {};
    pred = [];

    set(handles.text3, 'string', '>>> Testing...');
    pause(0.000001);

    for i = 1:length(validLabel.textdata)
        imgName = validLabel.textdata(i);
        img = imread(fullfile(dir, imgName{:}));
        label = (validLabel.data(i)+1);

        im_ = single(img);
        im_ = imresize(im_, net1.meta.normalization.imageSize(1:2)) ;

        im_ = bsxfun(@minus, im_, net1.meta.normalization.averageImage) ;
        % ??
        net1.eval({'input',im_}) ;
        scores = net1.vars(net1.getVarIndex('prob')).value ;
        scores = squeeze(gather(scores)) ;

        [bestScore, best] = max(scores) ;
        if best == label
            correct = correct + 1;
        end

        axes(handles.axes1);
        imshow(img);
        str1 = ['--  Predicted Class: ', num2str(best-1)];
        str2 = ['--  Truth Class: ', num2str(label-1)];
        str3 = ['__________________________'];
        str4 = ['-- Current Accuracy: ', num2str(100*correct/total), '%'];

        set(handles.text2, 'string', [str1, 10, str2, 10, str3, 10, 10, str4]);
        pause(0.000001);

        name{i} = imgName;
        pred(i) = best;
    end
    
    name = horzcat(name{:});
    
    set(handles.text3, 'string', '>>> Writing results to result-res-152.txt...');
    pause(0.000001);
    fid = fopen('result-res-152.txt', 'w');
    for i = 1:numel(name)
        tmp = name(i);
        fprintf(fid, '%s  %d \n', tmp{1}, pred(i)); 
    end
    fclose(fid);
    set(handles.text3, 'string', '>>> Finish. ');
    
end


% ========================================================================
% Our net
% ========================================================================
if get(handles.radiobutton16, 'value')
    set(handles.text3, 'string', '>>> Setting up environmen...');
    pause(0.000001);
    matlabDir = [matconvnetDir, '/matlab'];
    run(fullfile(matlabDir, 'vl_setupnn.m'));

    validLabel = importdata(fullfile(dir, 'label.txt'));
    validLabel.textdata = validLabel.textdata(2:end, 1);

    set(handles.text3, 'string', '>>> Loading model');
    pause(0.000001);
    net1 = load(['DeepLearning\exp-mynet','\image\net-deployed.mat']) ;
    imdb_mean = load(['DeepLearning\exp-mynet', '\image\imdb-data_mean.mat']);

    total = length(validLabel.textdata);
    correct = 0;
    name = {};
    pred = [];

    set(handles.text3, 'string', '>>> Testing...');
    pause(0.000001);

    for i = 1:length(validLabel.textdata)
        imgName = validLabel.textdata(i);
        img = imread(fullfile(dir, imgName{:}));
        label = (validLabel.data(i)+1);

        im_ = single(img);
        im_ = imresize(im_, [128, 128]) ;

        im_ = bsxfun(@minus, im_, imdb_mean.dm) ;
        % ??
        res = vl_simplenn(net1, im_,[],[],...
                      'accumulate', 0, ...
                      'mode', 'test', ...
                      'backPropDepth', inf, ...
                      'sync', 0, ...
                      'cudnn', 1) ;

        scores = res(22).x(1,1,:);

        [bestScore, best] = max(scores) ;
        if best == label
            correct = correct + 1;
        end

        axes(handles.axes1);
        imshow(img);
        str1 = ['--  Predicted Class: ', num2str(best-1)];
        str2 = ['--  Truth Class: ', num2str(label-1)];
        str3 = ['__________________________'];
        str4 = ['-- Current Accuracy: ', num2str(100*correct/total), '%'];

        set(handles.text2, 'string', [str1, 10, str2, 10, str3, 10, 10, str4]);
        pause(0.000001);

        name{i} = imgName;
        pred(i) = best;
    end
    
    name = horzcat(name{:});
    
    set(handles.text3, 'string', '>>> Writing results to result-res-152.txt...');
    pause(0.000001);
    fid = fopen('result-res-152.txt', 'w');
    for i = 1:numel(name)
        tmp = name(i);
        fprintf(fid, '%s  %d \n', tmp{1}, pred(i)); 
    end
    fclose(fid);
    set(handles.text3, 'string', '>>> Finish. ');
    
end


% ========================================================================
% SVM
% ========================================================================
if get(handles.radiobutton11, 'value')
    if length(strfind(pickle, 'HOG')) == 1
        % Character(1);
        set(handles.text3, 'string', '>>> Extracting HOG feature...');
        pause(0.000001);
        importTrainData = importdata('train_mine.mat');
        Character(2, dir);
        importValidData = importdata('valid_mine.mat');
    else
        % Pick('train_forstu.pickle');
        set(handles.text3, 'string', '>>> Convert pickle to mat format...');
        pause(0.000001);
        importTrainData = importdata('train_forstu.pickle.mat');
        Pick(pickle);
        importValidData = importdata('valid_forstu.pickle.mat');
    end
    
    set(handles.text3, 'string', '>>> Reading data and training...');
    pause(0.000001);
    
%     importTrainData = importdata('train_forstu.pickle.mat');
%     importValidData = importdata('valid_forstu.pickle.mat');
    [~,trainY] = size(importTrainData);
    [~,validY] = size(importValidData);
    validLabel = importdata(fullfile(dir, 'label.txt'));
    validLabel.textdata = validLabel.textdata(2:end, 1);
    
    set(handles.text3, 'string', '>>> Testing...');
    classifyFinal = SVMa(importTrainData,importValidData,trainY,validY,0);
    
    total = length(validLabel.textdata);
    correct = 0;
    name = {};
    pred = [];

    set(handles.text3, 'string', '>>> Testing...');
    pause(0.000001);

    for i = 1:length(validLabel.textdata)
        imgName = validLabel.textdata(i);
        img = imread(fullfile(dir, imgName{:}));
        
        label = (validLabel.data(i));
        best = classifyFinal(i);
        if label == best
            correct = correct + 1;
        end
        
        axes(handles.axes1);
        imshow(img);
        str1 = ['--  Predicted Class: ', num2str(best)];
        str2 = ['--  Truth Class: ', num2str(label)];
        str3 = ['__________________________'];
        str4 = ['-- Current Accuracy: ', num2str(100*correct/total), '%'];

        set(handles.text2, 'string', [str1, 10, str2, 10, str3, 10, 10, str4]);
        pause(0.05);

        name{i} = imgName;
        pred(i) = best;
    end
    
    name = horzcat(name{:});
    
    set(handles.text3, 'string', '>>> Writing results to result-svm.txt...');
    pause(0.000001);
    fid = fopen('result-svm.txt', 'w');
    for i = 1:numel(name)
        tmp = name(i);
        fprintf(fid, '%s  %d \n', tmp{1}, pred(i)); 
    end
    fclose(fid);
    set(handles.text3, 'string', '>>> Finish. ');
    
end


% ========================================================================
% KNN
% ========================================================================
if get(handles.radiobutton17, 'value')
    if length(strfind(pickle, 'HOG')) == 1
        % Character(1);
        set(handles.text3, 'string', '>>> Extracting HOG feature...');
        pause(0.000001);
        importTrainData = importdata('train_mine.mat');
        Character(2, dir);
        importValidData = importdata('valid_mine.mat');
    else
        % Pick('train_forstu.pickle');
        set(handles.text3, 'string', '>>> Convert pickle to mat format...');
        pause(0.000001);
        importTrainData = importdata('train_forstu.pickle.mat');
        Pick(pickle);
        importValidData = importdata('valid_forstu.pickle.mat');
    end
    
    set(handles.text3, 'string', '>>> Reading data and training...');
    pause(0.000001);
    
%     importTrainData = importdata('train_forstu.pickle.mat');
%     importValidData = importdata('valid_forstu.pickle.mat');
    [~,trainY] = size(importTrainData);
    [~,validY] = size(importValidData);
    validLabel = importdata(fullfile(dir, 'label.txt'));
    validLabel.textdata = validLabel.textdata(2:end, 1);
    
    set(handles.text3, 'string', '>>> Testing...');
    classifyFinal = kNNa(importTrainData,importValidData,trainY,validY,0);
    
    total = length(validLabel.textdata);
    correct = 0;
    name = {};
    pred = [];

    set(handles.text3, 'string', '>>> Testing...');
    pause(0.000001);

    for i = 1:length(validLabel.textdata)
        imgName = validLabel.textdata(i);
        img = imread(fullfile(dir, imgName{:}));
        
        label = (validLabel.data(i));
        best = classifyFinal(i);
        if label == best
            correct = correct + 1;
        end
        
        axes(handles.axes1);
        imshow(img);
        str1 = ['--  Predicted Class: ', num2str(best)];
        str2 = ['--  Truth Class: ', num2str(label)];
        str3 = ['__________________________'];
        str4 = ['-- Current Accuracy: ', num2str(100*correct/total), '%'];

        set(handles.text2, 'string', [str1, 10, str2, 10, str3, 10, 10, str4]);
        pause(0.05);

        name{i} = imgName;
        pred(i) = best;
    end
    
    name = horzcat(name{:});
    
    set(handles.text3, 'string', '>>> Writing results to result-knn.txt...');
    pause(0.000001);
    fid = fopen('result-knn.txt', 'w');
    for i = 1:numel(name)
        tmp = name(i);
        fprintf(fid, '%s  %d \n', tmp{1}, pred(i)); 
    end
    fclose(fid);
    set(handles.text3, 'string', '>>> Finish. ');
    
end

% ========================================================================
% SoftmaxB
% ========================================================================
if get(handles.radiobutton13, 'value')
    if length(strfind(pickle, 'HOG')) == 1
        % Character(1);
        set(handles.text3, 'string', '>>> Extracting HOG feature...');
        pause(0.000001);
        importTrainData = importdata('train_mine.mat');
        Character(2, dir);
        importValidData = importdata('valid_mine.mat');
    else
        % Pick('train_forstu.pickle');
        set(handles.text3, 'string', '>>> Convert pickle to mat format...');
        pause(0.000001);
        importTrainData = importdata('train_forstu.pickle.mat');
        Pick(pickle);
        importValidData = importdata('valid_forstu.pickle.mat');
    end
    
    set(handles.text3, 'string', '>>> Reading data and training...');
    pause(0.000001);
    
%     importTrainData = importdata('train_forstu.pickle.mat');
%     importValidData = importdata('valid_forstu.pickle.mat');
    [~,trainY] = size(importTrainData);
    [~,validY] = size(importValidData);
    validLabel = importdata(fullfile(dir, 'label.txt'));
    validLabel.textdata = validLabel.textdata(2:end, 1);
    
    set(handles.text3, 'string', '>>> Testing...');
    classifyFinal = SoftmaxB(importTrainData,importValidData,trainY,validY,0);
    
    total = length(validLabel.textdata);
    correct = 0;
    name = {};
    pred = [];

    set(handles.text3, 'string', '>>> Testing...');
    pause(0.000001);

    for i = 1:length(validLabel.textdata)
        imgName = validLabel.textdata(i);
        img = imread(fullfile(dir, imgName{:}));
        
        label = (validLabel.data(i));
        best = classifyFinal(i);
        if label == best
            correct = correct + 1;
        end
        
        axes(handles.axes1);
        imshow(img);
        str1 = ['--  Predicted Class: ', num2str(best)];
        str2 = ['--  Truth Class: ', num2str(label)];
        str3 = ['__________________________'];
        str4 = ['-- Current Accuracy: ', num2str(100*correct/total), '%'];

        set(handles.text2, 'string', [str1, 10, str2, 10, str3, 10, 10, str4]);
        pause(0.05);

        name{i} = imgName;
        pred(i) = best;
    end
    
    name = horzcat(name{:});
    
    set(handles.text3, 'string', '>>> Writing results to result-softmax.txt...');
    pause(0.000001);
    fid = fopen('result-softmax.txt', 'w');
    for i = 1:numel(name)
        tmp = name(i);
        fprintf(fid, '%s  %d \n', tmp{1}, pred(i)); 
    end
    fclose(fid);
    set(handles.text3, 'string', '>>> Finish. ');
    
end


% ========================================================================
% NEU
% ========================================================================
if get(handles.radiobutton12, 'value')
    if length(strfind(pickle, 'HOG')) == 1
        % Character(1);
        set(handles.text3, 'string', '>>> Extracting HOG feature...');
        pause(0.000001);
        importTrainData = importdata('train_mine.mat');
        Character(2, dir);
        importValidData = importdata('valid_mine.mat');
    else
        % Pick('train_forstu.pickle');
        set(handles.text3, 'string', '>>> Convert pickle to mat format...');
        pause(0.000001);
        importTrainData = importdata('train_forstu.pickle.mat');
        % Pick(pickle);
        importValidData = importdata('valid_forstu.pickle.mat');
    end
    
    set(handles.text3, 'string', '>>> Reading data and training...');
    pause(0.000001);
    
    importTrainData = importdata('train_forstu.pickle.mat');
    importValidData = importdata('valid_forstu.pickle.mat');
    [~,trainY] = size(importTrainData);
    [~,validY] = size(importValidData);
    validLabel = importdata(fullfile(dir, 'label.txt'));
    validLabel.textdata = validLabel.textdata(2:end, 1);
    
    set(handles.text3, 'string', '>>> Testing...');
    classifyFinal = NEUa(importTrainData,importValidData,trainY,validY,0);
    
    total = length(validLabel.textdata);
    correct = 0;
    name = {};
    pred = [];

    set(handles.text3, 'string', '>>> Testing...');
    pause(0.000001);

    for i = 1:length(validLabel.textdata)
        imgName = validLabel.textdata(i);
        img = imread(fullfile(dir, imgName{:}));
        
        label = (validLabel.data(i));
        best = classifyFinal(i);
        if label == best
            correct = correct + 1;
        end
        
        axes(handles.axes1);
        imshow(img);
        str1 = ['--  Predicted Class: ', num2str(best)];
        str2 = ['--  Truth Class: ', num2str(label)];
        str3 = ['__________________________'];
        str4 = ['-- Current Accuracy: ', num2str(100*correct/total), '%'];

        set(handles.text2, 'string', [str1, 10, str2, 10, str3, 10, 10, str4]);
        pause(0.05);

        name{i} = imgName;
        pred(i) = best;
    end
    
    name = horzcat(name{:});
    
    set(handles.text3, 'string', '>>> Writing results to result-nue.txt...');
    pause(0.000001);
    fid = fopen('result-nue.txt', 'w');
    for i = 1:numel(name)
        tmp = name(i);
        fprintf(fid, '%s  %d \n', tmp{1}, pred(i)); 
    end
    fclose(fid);
    set(handles.text3, 'string', '>>> Finish. ');
    
end


end
