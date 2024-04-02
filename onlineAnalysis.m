%在线处理
function [MIResult] = onlineAnalysis(circBuff,numChannels)
% 假设circBuff是一个the number of Samples×the number of Channels的矩阵
%% 测试
% clear all
% load('D:\文件文档\课题\程序\cupBallTask-revisionVersion\testData.mat')
% load('D:\文件文档\课题\程序\cupBallTask-revisionVersion\W.mat')
% load('D:\文件文档\课题\程序\cupBallTask-revisionVersion\svm_model.mat')
% circBuff=testData(:,:,4)';
% numChannels=size(circBuff,2);
% W=W1;
%% ###############################################
%导入svm模型，预测结果
load('H:\lubin\cupBallTask_revisionVersion\cupBallTask\svm_model.mat')   
load('H:\lubin\cupBallTask_revisionVersion\cupBallTask\svm_modelResting.mat')  
%导入空间滤波器W，提取特征
load('H:\lubin\cupBallTask_revisionVersion\cupBallTask\W.mat')
load('H:\lubin\cupBallTask_revisionVersion\cupBallTask\WResting.mat')
%带通滤波
if size(circBuff,1)~=0
for nChannel=1:size(circBuff(:,1:numChannels),2)
    vector=double(circBuff(:,nChannel));
    [A,B]=butter(5,[8 30]/128);
    bandpassSignal(:,nChannel)=filtfilt(A,B,vector);
    disp(size(bandpassSignal));
    disp(size(vector));
end
prepSignal=bandpassSignal;

%提取特征
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
    
