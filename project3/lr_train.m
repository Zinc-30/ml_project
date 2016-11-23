%% function: logistic regression train
%  input X, traning data, n*m, n items, m features
%  input Y, labels, n*1
%  output w, logistic regression model
function w = lr_train(X,Y)
    [n,m] = size(X);
    X = [X,ones(n,1)];
    m = m+1;
    w = (-1.+2*rand(m,1))/100;
    step = 0.1;
    epsilo = 0.005;
    flag = 1;
    while flag
        deltw = step.*X'*(Y - sigmoid(X*w));
        w = w + deltw;
        if epsilo>max(abs(deltw))
            flag = 0;
        end
        if step>0.001
            step = step*0.9;
        end
    end
end