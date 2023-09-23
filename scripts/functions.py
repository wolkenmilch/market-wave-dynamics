import numpy as np

def Hill_pro(data, cent):
    """
    Returns the Hill Estimators Distribution from 0% till cent%
    """ 

    # sort data so that smallest value is first and largest value is last
    Y = np.sort(data)
    n = len(Y)
    c = int(n * cent / 100)

    # create array filled with zeros
    Hill_est = np.zeros(c)
    
    # k = 0,...,n-2
    for k in range(0, c): 
        summ = 0

        # i = 0, ..., k 
        for i in range(0,k+1):
            summ += np.log(Y[n-1-i]) - np.log(Y[n-2-k])
        
        # add 1 to k because of Python syntax
        Hill_est[k] = (1 / (k+1)) * summ
  
    kappa = 1. / Hill_est
    return kappa


