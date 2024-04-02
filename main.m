clc;
clear;
%连接curry8的基本参数设置————————————————————————————————————————————
channelNum = 12; %所有通道数(不包括事件通道MGFP)，c3,c4,p3,p4,o1,o2,cz
displayTime = 2;
% global sampleRate;
sampleRate = 256;%采样率
params.dataLength = displayTime;
params.serverPort = 4455;
params.ipAddress = '192.168.137.1';%一台电脑，本机ip地址；两台电脑时，修改为采集电脑ip地址
% getSignal;
buffSize = round(sampleRate*params.dataLength); % buffSize = 2400
circBuff = zeros(buffSize,channelNum+1); % circBuff是一个2400*8的矩阵
%%需要注释,20是数据头，200是采集时间200ms，4是4个字节，一个通道数据是8位16进制数表示
dataBuffer = round((channelNum+1)*4*(sampleRate/8)+20);
% -------------------------------------------------------------------------
%开始传输数据指令
startheader = initHeader('CTRL',...
    controlCode('CTRL_FromClient'),...
    requestType('RequestStreamingStart'),...
    0,0,0);
% -------------------------------------------------------------------------
%停止传输数据指令
stopheader = initHeader('CTRL',...
    controlCode('CTRL_FromClient'),...
    requestType('RequestStreamingStop'),...
    0,0,0);
% -------------------------------------------------------------------------
%tcpip端口设置
con = tcpclient(params.ipAddress, params.serverPort);
set(con,'InputBufferSize',dataBuffer);
set(con,'ByteOrder','littleEndian');
fopen(con);

%————————————————————————————————————————————————————————————————
continueFlag = true;  
while(continueFlag)
    %%  BCI方式
    % 设定一个计时器对象
     Buff=[];
     for i=1:16
        newset=pGetData_curry8(con,dataBuffer,channelNum,sampleRate);
        WaitSecs(0.2);
        Buff =[Buff;newset];
     end
        circBuff=Buff;
        fwrite(con, startheader,'uchar');
        disp(circBuff);
        MIResult = onlineAnalysis(circBuff,12);
        
        % 与unity通信
        tcpipClient = tcpip('127.0.0.1',55001,'NetworkRole','Client');
        set(tcpipClient,'Timeout',30);
        fopen(tcpipClient);
        if MIResult == 1
            a='1';
        end
        fwrite(tcpipClient,a);
        fclose(tcpipClient);
        
        if (strcmpi(inputMode,'KB'))
            [keyIsDown,~,keyCode]=KbCheck;
            if keyIsDown
                kc=find(keyCode);
                kc = kc(end);
                if kc ~= None
                    continueFlag = False;
                end
            end
        end
end
                   
% 停止发送数据————————————————————————————————————————————————
fwrite(con, stopheader,'uchar');
% stop(fixTime);
fclose(con);
delete(con);
