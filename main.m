close all
clear all

loadModules();

ACRaw=readRawData('rawAGISCIGTS.xlsx');
JPRaw=readRawDataJapan('japanDataRawAll.xlsx');

ACInterp=interpolateData(ACRaw);
JPInterp=interpolateDataJapan(JPRaw);

ACProg=labelProgression(ACInterp);
JPProg=labelProgression(JPInterp);

[ JPProgTrain,JPProgTest,JPRawTrain,JPRawTest ] = splitTrainTest( JPProg,JPRaw, 0.5 );

table1=Table1(ACRawTrain,ACRawTest,ACProgTrain,ACProgTest)

[ A0 C0 Q0 R0 INITX0 INITV0 ]=initializeEM(ACProgTrain);
[A, C, Q, R, INITX, INITV, LL] = learn_kalman(ACProgTrain(2:end,3), A0, C0, Q0, R0, INITX0, INITV0,100);

getRegModel( A, C, Q, R, INITX, INITV, ACProgTrain);
o=readRegCoeff();

[acc,dd]= paretoAnalysis( A,C,Q,R,INITX,INITV,o, ACProgTrain,ACProgTest,0.01,'AC Training','AC Testing',0);


% beta = 0.98;
% rho=0.37;
% 
% save 'temp.mat'
%  [~,fd]=forwardTNT(A, C, Q, R, INITV, INITX,o,beta,rho,ACProgTest,6);
% plotTrjectory([],fd,ACRawTest,'');

