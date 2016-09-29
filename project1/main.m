%% test all datasets
% dataset shuold be in filefold ./datasets

function main()
    s = {'australian','breast-cancer','diabetes','german-numer','heart'};
    for e=s
        fprintf('==========%s============\n',e{1});
        maintest(e{1});
    end
        
end

function [trainAcc,testAcc] = maintest(filename)
%% test data using ANN and logistic regression
% input: filename to load data
%       {trainX,training data, n1*m;  trainY,n1*1
%        testX,test data,n2*m; testY,n2*1 
% output: trainAc, traning accuracy
%         testAc, test accuracy
    load(strcat('./datasets/',filename,'_train.mat'));
    trainX = X;
    trainY = Y;
    load(strcat('./datasets/',filename,'_test.mat'));
    testX = X;
    testY = Y;
%% test Neural Network 
    tic;
    n = size(trainX,1);
    [w,v,h] = nn_train(trainX,trainY);
    yp = nn_predict(trainX,w,v);
    trainAcc = sum(yp==trainY)/n;
       
    n = size(testX,1);
    yp = nn_predict(testX,w,v);
    testAcc = sum(yp==testY)/n;
    timeCost = toc;
    fprintf('[Neural Network]:\ntraining acc:%f,test acc:%f,time:%f s,hiden unites:%d\n',trainAcc,testAcc,timeCost,h);
%% logistic regression
    tic;
    n = size(trainX,1);
    w = lr_train(trainX,trainY);
    yp = lr_predict(trainX,w);
    trainAcc = sum(yp==trainY)/n;
    
    n = size(testX,1);
    yp = lr_predict(testX,w);
    testAcc = sum(yp==testY)/n;
    timeCost = toc;
    fprintf('[logistic regression]:\ntraining acc:%f,test acc:%f,time:%f s\n',trainAcc,testAcc,timeCost);
end
