function net = prepareVggNet(net,opts)
%=========================================================================
% prepareVggNet : prepare the vgg-net for training
%=========================================================================

nCls = 6; % number of classes

% -------------------------------------------------------------------------
%                                                               Replace fc8
% -------------------------------------------------------------------------
fc8l = cellfun(@(a) strcmp(a.name, 'fc8'), net.layers)==1;
sizeW = size(net.layers{fc8l}.weights{1});

% -------------------------------------------------------------------------
%                                                     Change the fc8 layers
% -------------------------------------------------------------------------
if sizeW(4)~=nCls
  net.layers{fc8l}.weights = ...
        {zeros(sizeW(1),sizeW(2),sizeW(3),nCls,'single'), ...
        zeros(1, nCls, 'single')};
end

% -------------------------------------------------------------------------
%                                                        Change loss layers 
% -------------------------------------------------------------------------
net.layers{end} = struct('name','loss', 'type','softmaxloss') ;

% -------------------------------------------------------------------------
%                                                    Convert to dagnn dagnn
% -------------------------------------------------------------------------
net = dagnn.DagNN.fromSimpleNN(net, 'canonicalNames', true) ;

net.addLayer('top1err', dagnn.Loss('loss', 'classerror'), ...
             {'prediction','label'}, 'top1err') ;
net.addLayer('top5err', dagnn.Loss('loss', 'topkerror', ...
             'opts', {'topK',5}), {'prediction','label'}, 'top5err') ;
         
         
         