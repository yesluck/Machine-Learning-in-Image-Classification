% 随机梯度下降法(这里要用上升法)  
function [ weights ] = stochasticGradientAscent( dataMat, labelMat, M, weights, alpha )  
    for step = 1:1500  
        for i = 1:M%对每一个样本  
            pop = exp(dataMat(i,:)*weights);%计算概率  
            popSum = sum(pop);%分母  
            pop = -pop/popSum;%求好概率  
            pop(:,labelMat(i)) = pop(:,labelMat(i))+1;%加1的操作  
            weights = weights + alpha*dataMat(i,:)'*pop;  
        end  
    end  
end