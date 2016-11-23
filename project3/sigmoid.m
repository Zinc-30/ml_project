%% sigmod function
% input x, n*1, n items,
% output sigmod(X)
function o = sigmoid(x)
    o = 1./(1.+exp(-x));
end
