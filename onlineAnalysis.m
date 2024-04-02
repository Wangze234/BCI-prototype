%���ߴ���
function [MIResult] = onlineAnalysis(circBuff,numChannels)
% ����circBuff��һ��the number of Samples��the number of Channels�ľ���
%% ����
% clear all
% load('D:\�ļ��ĵ�\����\����\cupBallTask-revisionVersion\testData.mat')
% load('D:\�ļ��ĵ�\����\����\cupBallTask-revisionVersion\W.mat')
% load('D:\�ļ��ĵ�\����\����\cupBallTask-revisionVersion\svm_model.mat')
% circBuff=testData(:,:,4)';
% numChannels=size(circBuff,2);
% W=W1;
%% ###############################################
%����svmģ�ͣ�Ԥ����
load('H:\lubin\cupBallTask_revisionVersion\cupBallTask\svm_model.mat')   
load('H:\lubin\cupBallTask_revisionVersion\cupBallTask\svm_modelResting.mat')  
%����ռ��˲���W����ȡ����
load('H:\lubin\cupBallTask_revisionVersion\cupBallTask\W.mat')
load('H:\lubin\cupBallTask_revisionVersion\cupBallTask\WResting.mat')
%��ͨ�˲�
if size(circBuff,1)~=0
for nChannel=1:size(circBuff(:,1:numChannels),2)
    vector=double(circBuff(:,nChannel));
    [A,B]=butter(5,[8 30]/128);
    bandpassSignal(:,nChannel)=filtfilt(A,B,vector);
    disp(size(bandpassSignal));
    disp(size(vector));
end
prepSignal=bandpassSignal;

%��ȡ����
m=numChannels/2;
Ymotor=W'*prepSignal';
Ypmotor=Ymotor([1:m end-m+1:end],:);
denmotor=0;
for k1=1:2*m
    denmotor=denmotor+var(Ypmotor(k1,:));
end
featureMotor=log(var(Ypmotor')'/denmotor);
[Result2]=predict(svm_model,featureMotor');
MIResult=Result2;
% end
else
    MIResult=3;
end
    
