%% Neural Network (single-hidden-layer) train
%  input X, traning data, n*m, n items, m features
%        Y, labels, n*1
%  output w, inputValue of hidenLayer  (m+1)*hnum
%         v, inputValue of outputLayer (hnum+1)*1
%         hnum, numbers of hidenUnit

function [w,v,hnum] = nn_train(X,Y)
        acc = zeros(1,10); hnum = 1; 
        for h=1:10
            for i=1:5
                [trainSet,testSet] = validation(X,Y);
                [w,v] = train(trainSet,h);
                acc(h) = acc(h) + test(testSet,w,v)/5;              
            end
            fprintf('%f\n',acc(h));
            %fprintf('acc with %d hidden units is %f\n',h,acc(h));
        end
        
        for h=1:10
            if acc(h)>acc(hnum)
                hnum = h;
            end
        end      
        [w,v] = train([X,Y],hnum);
end


function [trainSet,testSet] = validation(X,Y)
%% Split data to two sets with 80% for training 20% for test
    split = 0.8;
    n = size(X,1);
    nperms = randperm(n);
    data = [X,Y];
    
    trainSet = data(nperms(1:fix(split*n)),:);
    testSet = data(nperms(fix(split*n)+1:n),:);   
end

function [w,v] = train(trainSet,h)
%% learn w,v from trainSet with h hidenUnits
% Z, outputValue of hidenLayer  n*(h+1)
% Yp,outputValue of outputLayer n*1
% w, inputValue of hidenLayer  (m+1)*h
% v, inputValue of outputLayer (h+1)*1
    [n,m] = size(trainSet);m = m-1;
    X = [trainSet(:,1:m),ones(n,1)];
    Y = trainSet(:,m+1);
    w = (-1.+2*rand(m+1,h))/100;
    v = (-1.+2*rand(h+1,1))/100;
    step = 0.01;
    epsilo = 0.0005;
    flag = 1;
    while flag
        Z = [sigmoid(X*w),ones(n,1)];
        Yp = sigmoid(Z*v);
        deltv = step.*Z'*(Y - Yp);
        
        deltw = step.*X'*((Y - Yp)*v(1:h)'.*Z(:,1:h).*(1.-Z(:,1:h)));
        v = v + deltv;
        w = w + deltw;
  
        if epsilo>max(max(abs(deltv))) && epsilo>max(max(abs(deltw)))
            flag = 0;
        end
        if step>0.001
            step = step*0.9;
        end 
    end
end

function acc = test(testSet,w,v)
%% find accuracy in testSet 
%
    [n,m] = size(testSet);m = m-1;
    X = [testSet(:,1:m),ones(n,1)];
    Y = testSet(:,m+1);
    Z = [sigmoid(X*w),ones(n,1)];
    Yp = sigmoid(Z*v)>0.5.*ones(n,1);
    acc = sum(Y == Yp)/n;
end