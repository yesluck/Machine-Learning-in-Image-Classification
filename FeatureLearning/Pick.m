function [a] = Pick(filename)
    if ~exist(filename,'file')
        error('%s is not a file',filename);
    end
    outname = [filename '.mat'];
    
    if 1% ~exist(outname, 'file')
        pyscript = ['import cPickle as pickle;import sys;import scipy.io;file=open(''' filename ''',''rb+'');dat=pickle.load(file);file.close();scipy.io.savemat(''' outname ''', {''dat'':dat})'];
        command = ['python.exe -c "' pyscript '"'];
        disp(command);
        system(command);
    end
    a = load(outname);
end