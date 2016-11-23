import random
import numpy as np
from collections import defaultdict
from matplotlib import pyplot as plt


def sigmoid(z):
    return 1.0 / (1 + np.exp(-z))

def dsigmoid(z):
    return np.exp(-z)/(1+np.exp(-z))**2
def rmse(Rp,R):
    error = 0.0
    nums = 0
    for u in R:
        for i in R[u]:
            error += (R[u][i]-Rp[u][i])**2
            nums += 1
    return np.sqrt(error/nums)
def reverseR(R):
    Rr=defaultdict(dict)
    for u in R:
        for i in R[u]:
            Rr[i][u] = R[u][i]
    return Rr

def PMF(R,N,M,K, lambdaU,lambdaV):
    def costL(U,V,*args):
        R,Rr=args
        cost=0.0
        for u in R:
            for i in R[u]:
                cost += 0.5 * (R[u][i] - sigmoid(U[u].dot(V[i])))**2
        cost += lambdaU/2 * np.linalg.norm(U)+lambdaV/2 * np.linalg.norm(V)
        return cost
    def gradient(U,V, *args):
        R,Rr=args
        dU = np.zeros(U.shape)
        dV = np.zeros(V.shape)
        for u in R:
            for i in R[u]:
                tmp = U[u].dot(V[i])
                dU[u] += V[i] * dsigmoid(tmp) * (sigmoid(tmp)-R[u][i]) 
            dU[u] += lambdaU * U[u]
        for i in Rr:
            for u in Rr[i]:
                tmp = U[u].dot(V[i])
                dV[i] += U[u] * dsigmoid(tmp) * (sigmoid(tmp)-R[u][i])
            dV[i] += lambdaV * V[i]
        return dU,dV
    def train(U,V):
        args=R,Rr
        res=[]
        t0=10
        steps=10**3
        learn_rate = 0.1
        tol=1e-3
        stage = max(steps/100 , 1)
        for step in xrange(steps):
            dU,dV = gradient(U,V,*args)
            rate=learn_rate/(t0+step)
            U -= rate * dU
            V -= rate * dV
            if not step%stage:
                e = costL(U,V,*args)
                print step, e
                res.append(e)
            if e < tol:
                break
        plt.plot(res)
        plt.show()
        print 'step:%d, e: %f' %(step, e)
        return U, V

    U = np.random.normal(0,0.01,size=(N,K))
    V = np.random.normal(0,0.01,size=(M,K))
    Rr = reverseR(R)
    return train(U,V)


def t_movielens():
    #data from: http://files.grouplens.org/datasets/movielens/ml-100k.zip
    def gen_data(fname):
        N,M = 0,0
        tmps = []
        for line in open(fname):
            tmps.append(line.split())
            N=max(N,u)
            M=max(M,i)
        N+=1
        M+=1
        return tmps,N,M
    def get_R(data,l):
        R = defaultdict(dict)
        for li in l:
            u,i,r = [int(x) for x in tmps[li][0:3]]
            R[u][i] = r/max_r
        return R
    def test(K,lambdaU,lambdaV):

        sumrmse = 0.0
            for t in range(5):
                idlist = np.random.permutation(trainNum)
                RList = idlist[:int(0.8*trainNum)]]
                valList = idlist[int(0.8*trainNum):]]
                R = get_R(tmps,RList)
                R_val = get_R(tmps,valList)
                print 'N:%d, M:%d, K:%d, lambdaU:%s, lambdaV:%s' \
                        %(N,M,K,lambdaU,lambdaV)
                U,V = PMF(R,N,M,K,lambdaU,lambdaV) 
                for u in R_val:
                    for i in R_val[u]:
                        R_hat[u][i] = sigmoid(U[u].dot(V[i])) *max_r
                sumrmse += rmse(R_hat,R_val)
        return sumrmse/5
    max_r = 5.0
    tmps,N,M = gen_data("./u.data")
    rateNum = len(tmps)
#+++++++++++++++++80% train++++++++++++++++
    ratio = 0.8
    trainNum = int(ratio*rateNum)
    R_test = get_R(tmps,range(trainNum,rateNum))
#======================================= lambda
    lambdaList = [0.1,1,10,100]
    K = 2 
    resUV = defaultdict(dict)
    lambdaU_ = 0.1
    lambdaV_ = 0.1
    minrmse = 1000000
    for lambdaU in lambdaList:
        for lambdaV in lambdaList:
            sumrmse = test(K,lambdaU,lambdaV)
            if sumrmse < minrmse:
                minrmse = sumrmse
                lambdaU_ = lambdaU
                lambdaV_ = lambdaV
            resUV[lambdaU][lambdaV] = sumrmse
#======================================= k
    Klist = [1,2,3,4,5]
    minrmse = 1000000
    resK = []
    K_ = 2
    for K in Klist:
        sumrmse = test(K,lambdaU_,lambdaV_)
        if sumrmse < minrmse:
            minrmse = sumrmse
            K_ = K
        resK.append(sumrmse)

#++++++++++++++++++20% train++++++++++++++++++++++
    ratio = 0.2
    trainNum = int(ratio*rateNum)
    R_test = get_R(tmps,range(trainNum,rateNum))
    testList = rateList[int(ratio*rateNum):]

    


    





if __name__ == "__main__":
   t_movielens()
