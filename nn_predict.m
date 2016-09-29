%% Neural Network predict (single-hidden-layer)
% input X, test data, n*m, n items, m features
%       w, inputValue of hidenLayer  (m+1)*hnum
%       v, inputValue of outputLayer (hnum+1)*1
% output y, predict value

function y = nn_predict(X,w,v)
    [n,m] = size(X);
    X = [X,ones(n,1)];
    Z = [sigmoid(X*w),ones(n,1)];
    y = sigmoid(Z*v)>0.5.*ones(n,1);
end
