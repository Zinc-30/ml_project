%% logistic regression predict
% input X, test data, n*m, n items, m features
%       w, logistic regression model, m*1
% output y, predict value
function y = lr_predict(X,w)
    [n,m] = size(X);
    X = [X,ones(n,1)];
    y = sigmoid(X*w)>(0.5.*ones(n,1)); 
end