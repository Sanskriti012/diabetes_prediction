% Read Data
clc 
clear all
close all
data = readtable("C:\Users\sansk\OneDrive - IIT Kanpur\Desktop\diabetes.csv")
%%
%Cheaking if null value present or not
a=sum(ismissing(data));
%%
%Sequential pattern mining (SPM)
data.Pregnancies=(data.Pregnancies-min(data.Pregnancies))/(max(data.Pregnancies)-min(data.Pregnancies));
data.Glucose=(data.Glucose-min(data.Glucose))/(max(data.Glucose)-min(data.Glucose));
data.BloodPressure=(data.BloodPressure-min(data.BloodPressure))/(max(data.BloodPressure)-min(data.BloodPressure));
data.SkinThickness=(data.SkinThickness-min(data.SkinThickness))/(max(data.SkinThickness)-min(data.SkinThickness));
data.Insulin=(data.Insulin-min(data.Insulin))/(max(data.Insulin)-min(data.Insulin));
data.BMI=(data.BMI-min(data.BMI))/(max(data.BMI)-min(data.BMI));
data.Age=(data.Age-min(data.Age))/(max(data.Age)-min(data.Age));
data.DiabetesPedigreeFunction=(data.DiabetesPedigreeFunction-min(data.DiabetesPedigreeFunction))/(max(data.DiabetesPedigreeFunction)-min(data.DiabetesPedigreeFunction));
%%
%Partitoning my data set into train and test
% split the data into train test
cv = cvpartition(size(data,1),'HoldOut',0.2);
idx= cv.test;
% Separate to training and test data
dataTrain= data(~idx,:);
dataTest = data(idx,:);
%%
%Handle the 0 values for features of training set
g=(dataTrain.Glucose==0);
k=(dataTrain.BloodPressure==0);
l=(dataTrain.SkinThickness==0);
m=(dataTrain.Insulin==0);
n=(dataTrain.BMI==0);
o=(dataTrain.DiabetesPedigreeFunction==0);
p=(dataTrain.Age==0);
impactical=[sum(g) sum(k) sum(l) sum(m) sum(n) sum(o) sum(p)];

%Replace those with average of the corresponding columns of training data
g=(dataTrain.Glucose==0);
msa=(dataTrain.Outcome==1);
ks=mean(dataTrain.Glucose(~g & msa));
dataTrain.Glucose(g & msa) = ks;
ks=mean(dataTrain.Glucose(~g & ~msa));
dataTrain.Glucose(g & ~msa) = ks;

g=(dataTrain.BloodPressure==0);
ks=mean(dataTrain.BloodPressure(~g & msa));
dataTrain.BloodPressure(g & msa) = ks;
ks=mean(dataTrain.BloodPressure(~g & ~msa));
dataTrain.BloodPressure(g & ~msa) = ks;

g=(dataTrain.SkinThickness==0);
ks=mean(dataTrain.SkinThickness(~g & msa));
dataTrain.SkinThickness(g & msa) = ks;
ks=mean(dataTrain.SkinThickness(~g & ~msa));
dataTrain.SkinThickness(g & ~msa) = ks;

g=(dataTrain.Insulin==0);
ks=mean(dataTrain.Insulin(~g & msa));
dataTrain.Insulin(g & msa) = ks;
ks=mean(dataTrain.Insulin(~g & ~msa));
dataTrain.Insulin(g & ~msa) = ks;

g=(dataTrain.BMI==0);
ks=mean(dataTrain.BMI(~g & msa));
dataTrain.BMI(g & msa) = ks;
ks=mean(dataTrain.BMI(~g & ~msa));
dataTrain.BMI(g & ~msa) = ks;

g=(dataTrain.DiabetesPedigreeFunction==0);
ks=mean(dataTrain.DiabetesPedigreeFunction(~g & msa));
dataTrain.DiabetesPedigreeFunction(g & msa) = ks;
ks=mean(dataTrain.DiabetesPedigreeFunction(~g & ~msa));
dataTrain.DiabetesPedigreeFunction(g & ~msa) = ks;
dataTrain.Age(p)=mean(dataTrain.Age(~p));
%%
%Handle the 0 values for some features of test set
g=(dataTest.Glucose==0);
k=(dataTest.BloodPressure==0);
l=(dataTest.SkinThickness==0);
m=(dataTest.Insulin==0);
n=(dataTest.BMI==0);
o=(dataTest.DiabetesPedigreeFunction==0);
p=(dataTest.Age==0);
impactical=[sum(g) sum(k) sum(l) sum(m) sum(n) sum(o) sum(p)];
%%
%Replace those with average of the corresponding columns of test data
g=(dataTest.Glucose==0);
msa=(dataTest.Outcome==1);
ks=mean(dataTest.Glucose(~g & msa));
dataTest.Glucose(g & msa) = ks;
ks=mean(dataTest.Glucose(~g & ~msa));
dataTest.Glucose(g & ~msa) = ks;

g=(dataTest.BloodPressure==0);
ks=mean(dataTest.BloodPressure(~g & msa));
dataTest.BloodPressure(g & msa) = ks;
ks=mean(dataTest.BloodPressure(~g & ~msa));
dataTest.BloodPressure(g & ~msa) = ks;

g=(dataTest.SkinThickness==0);
ks=mean(dataTest.SkinThickness(~g & msa));
dataTest.SkinThickness(g & msa) = ks;
ks=mean(dataTest.SkinThickness(~g & ~msa));
dataTest.SkinThickness(g & ~msa) = ks;

g=(dataTest.Insulin==0);
ks=mean(dataTest.Insulin(~g & msa));
dataTest.Insulin(g & msa) = ks;
ks=mean(dataTest.Insulin(~g & ~msa));
dataTest.Insulin(g & ~msa) = ks;

g=(dataTest.BMI==0);
ks=mean(dataTest.BMI(~g & msa));
dataTest.BMI(g & msa) = ks;
ks=mean(dataTest.BMI(~g & ~msa));
dataTest.BMI(g & ~msa) = ks;

g=(dataTest.DiabetesPedigreeFunction==0);
ks=mean(dataTest.DiabetesPedigreeFunction(~g & msa));
dataTest.DiabetesPedigreeFunction(g & msa) = ks;
ks=mean(dataTest.DiabetesPedigreeFunction(~g & ~msa));
dataTest.DiabetesPedigreeFunction(g & ~msa) = ks;
dataTest.Age(p)=mean(dataTest.Age(~p));
%%
%Train model using Training sets
classification_model=fitcsvm(dataTrain,'Outcome~Pregnancies+Glucose+BloodPressure+SkinThickness+Insulin+BMI+DiabetesPedigreeFunction+Age');
%%
%Accuracy
gs=dataTest(:,1:8);
mk=predict(classification_model,gs);
accuracy_check=((sum((mk==table2array(dataTest(:,9)))))/size(dataTest,1))*100;
disp(accuracy_check);