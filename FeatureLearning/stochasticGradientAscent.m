% ����ݶ��½���(����Ҫ��������)  
function [ weights ] = stochasticGradientAscent( dataMat, labelMat, M, weights, alpha )  
    for step = 1:1500  
        for i = 1:M%��ÿһ������  
            pop = exp(dataMat(i,:)*weights);%�������  
            popSum = sum(pop);%��ĸ  
            pop = -pop/popSum;%��ø���  
            pop(:,labelMat(i)) = pop(:,labelMat(i))+1;%��1�Ĳ���  
            weights = weights + alpha*dataMat(i,:)'*pop;  
        end  
    end  
end