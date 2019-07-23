import numpy as np
import pandas as pd
import math

a = np.array([2,1,3,1])
a.shape


def sigmoid(x):
  return 1 / (1 + np.exp(-x))

ans1 = np.round(sigmoid(a),3)
print(ans1)


def sigmoidDerivative(x):
    return np.multiply(sigmoid(x),(1.0-sigmoid(x)))

np.multiply(ans1, (1.0-ans1))

ans2 = np.round(sigmoidDerivative(a),3)
print(ans2)

h = np.array([1,-1,2,-1])

ans3 = np.multiply(h, ans2)
print(ans3)


print(ans3.T.shape)
