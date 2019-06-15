'''
Created on 22-Mar-2018

@author: aii32199
'''
import pickle

import cv2
from sklearn.linear_model import LogisticRegression

import matplotlib.pyplot as plt
import numpy as np


npoints = 512


def Signature(boundary):
    centroid = np.mean(boundary,axis=0)
    distance = np.sqrt(np.sum(np.square(boundary-centroid),axis=1))
    return distance,centroid

def getFeatures(im,npoints=32,isBinary=False):
    
    imshape = np.shape(im)
    
    if imshape[2]==3:
        im = cv2.cvtColor(im,cv2.COLOR_BGR2GRAY)                            
    
    if not isBinary:
        _,im = cv2.threshold(im,200,255,cv2.THRESH_BINARY_INV)
    #cv2.imshow('',im)
    #cv2.waitKey()
        
    _, contours, _= cv2.findContours(im,cv2.RETR_TREE,cv2.CHAIN_APPROX_NONE)    
     
    features = []
    centers =[]
    
    for contour in contours:
        contour = np.reshape(contour,[len(contour),2])
        sig,cent = Signature(contour)
        sig = sig/np.max(sig)
        points = np.linspace(0, len(sig)-1, npoints,dtype="uint16")
        sigComp = sig[points]
        features.append(sigComp)
        centers.append(cent)
        
    return np.array(features),np.array(centers),contours
     
def CreateDataset():
    
    path2read = 'D:/testim/Ovaries/Code/datachallenge_cods2016/'
    images2read = ['Pentagons.png','Rectangles.png','Triangles.png','Circles.png']
    
    
    labels = []    
    data = np.array(np.zeros((1,npoints),dtype='uint16'));
    class_var = 0
    for image_name in images2read: 
            im = cv2.imread(path2read+image_name)
            features,_,_ = getFeatures(im, npoints,True)
            
            data = np.append(data,features,axis=0)            
            lab = [class_var for i in range(len(features))]
            class_var+=1            
            labels = np.append(labels,lab)
            
            #plt.subplot(2,3,plot_id)
            #plt.plot(sigComp)
            
        #plt.show()
    data = np.delete(data, (0), axis=0)
    return np.array(data),np.array(labels)

def main():
    
    sign,labels = CreateDataset()
    model = LogisticRegression()
    model.fit(sign, labels)    
    prob = model.predict_proba(sign)    
    predictions = np.argmax(prob,1)
    
    for pred,lab in zip(predictions,labels):
        print('Predicted: %.f Actual: %.f'%(pred,lab))
    
    model_path = 'D:/testim/Ovaries/Code/datachallenge_cods2016/shape_logistic.sav'
    pickle.dump(model,open(model_path,'wb'))
    
def test():
    
    #testPath = 'D:/testim/Ovaries/Code/datachallenge_cods2016/shapes.png'
    testPath = 'E:/GoogleDrive/TechDocuments/Webinars/LogisticRegression/Code/various shapes.png' 
    model_path = 'D:/testim/Ovaries/Code/datachallenge_cods2016/shape_logistic.sav'
    
    im = cv2.imread(testPath)      
    features,centers,contours = getFeatures(im, npoints,False)
           
    model = pickle.load(open(model_path,'rb'))
    prob = model.predict_proba(features)
    predictions = np.argmax(prob,1)    
    
    for i in range(len(predictions)):      
        
        #centx,centy = np.int16(centers[i])
        mx_prob = np.max(prob[i])
        cnt = contours[i]
        x,y,w,h = cv2.boundingRect(cnt)        
        if mx_prob<=0.6:
            text='Unknown'
            BoxColor = (0,0,255)
        else:
            BoxColor = (0,255,0)  
            if predictions[i]==0:text = 'Pentagon'
            if predictions[i]==1:text = 'Rectangle'
            if predictions[i]==2:text = 'Triangle'
            if predictions[i]==3:text = 'Circle'
                
        cv2.putText(im,text,(x-10,y-10), cv2.FONT_HERSHEY_SIMPLEX, 0.5, (255, 0, 255), 2)
        im = cv2.rectangle(im,(x,y),(x+w,y+h),BoxColor,2)
    cv2.imwrite('D:/testim/Ovaries/Code/datachallenge_cods2016/various_shapes_Annot.png',im)
    plt.show()
    cv2.imshow(" ",im)
    cv2.waitKey()


test()