clc;
clear;
%����curry8�Ļ����������á���������������������������������������������������������������������������������������
channelNum = 12; %����ͨ����(�������¼�ͨ��MGFP)��c3,c4,p3,p4,o1,o2,cz
displayTime = 2;
% global sampleRate;
sampleRate = 256;%������
params.dataLength = displayTime;
params.serverPort = 4455;
params.ipAddress = '192.168.137.1';%һ̨���ԣ�����ip��ַ����̨����ʱ���޸�Ϊ�ɼ�����ip��ַ
% getSignal;
buffSize = round(sampleRate*params.dataLength); % buffSize = 2400
circBuff = zeros(buffSize,channelNum+1); % circBuff��һ��2400*8�ľ���
%%��Ҫע��,20������ͷ��200�ǲɼ�ʱ��200ms��4��4���ֽڣ�һ��ͨ��������8λ16��������ʾ
dataBuffer = round((channelNum+1)*4*(sampleRate/8)+20);
% -------------------------------------------------------------------------
%��ʼ��������ָ��
startheader = initHeader('CTRL',...
    controlCode('CTRL_FromClient'),...
    requestType('RequestStreamingStart'),...
    0,0,0);
% -------------------------------------------------------------------------
%ֹͣ��������ָ��
stopheader = initHeader('CTRL',...
    controlCode('CTRL_FromClient'),...
    requestType('RequestStreamingStop'),...
    0,0,0);
% -------------------------------------------------------------------------
%tcpip�˿�����
con = tcpclient(params.ipAddress, params.serverPort);
set(con,'InputBufferSize',dataBuffer);
set(con,'ByteOrder','littleEndian');
fopen(con);

%��������������������������������������������������������������������������������������������������������������������������������
continueFlag = true;  
while(continueFlag)
    %%  BCI��ʽ
    % �趨һ����ʱ������
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
        
        % ��unityͨ��
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
                   
% ֹͣ�������ݡ�����������������������������������������������������������������������������������������������
fwrite(con, stopheader,'uchar');
% stop(fixTime);
fclose(con);
delete(con);
