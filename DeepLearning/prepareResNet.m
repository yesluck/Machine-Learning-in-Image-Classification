function net = prepareResNet(net,opts)
%=========================================================================
% prepareResNet : prepare the res-net for training
%=========================================================================


net.renameVar('data', 'input');

% -------------------------------------------------------------------------
%                                                             remove 'prob'
% -------------------------------------------------------------------------
removeLayer(net, net.layers(end).name);

% -------------------------------------------------------------------------
%                                                               remove 'fc'
% -------------------------------------------------------------------------
[h,w,in,out] = size(zeros(net.layers(end).block.size));
out = 6;
lName = net.layers(end).name;
net.removeLayer(net.layers(end).name);

pName = net.layers(end).name;
lName = 'prediction';
block = dagnn.Conv('size', [h,w,in,out], 'hasBias', true, 'stride', 1, 'pad', 0);
net.addLayer(lName, block, pName, lName, {[lName '_f'], [lName '_b']});
p = net.getParamIndex(net.layers(end).params) ;
params = net.layers(end).block.initParams() ;
params = cellfun(@gather, params, 'UniformOutput', false) ;
[net.params(p).value] = deal(params{:}) ;


% -------------------------------------------------------------------------
%                                                          add error layers
% -------------------------------------------------------------------------
net.addLayer('objective', dagnn.Loss('loss', 'softmaxlog'), ...
             {'prediction', 'label'}, 'objective');
net.addLayer('top1err', dagnn.Loss('loss', 'classerror'), ...
             {'prediction','label'}, 'top1err') ;
net.addLayer('top5err', dagnn.Loss('loss', 'topkerror', ...
             'opts', {'topK',5}), ...
             {'prediction','label'}, 'top5err') ;

net.layers