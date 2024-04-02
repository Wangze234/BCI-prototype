function [] = chuangkoushujushuchu()
	%实时打印串口数据2017/4/25---2016/4/26
	%pc板发送数据，MATLAB调用串口接收pc板发送的数据，并打印实时的图像；
	s=serial('COM8');
	set(s,'BaudRate',115200,'StopBits',1,'DataBits',8,'Parity','none','InputBufferSize',128);%设置串口波特率，奇偶校验位 ， 触发方式
	fopen(s);
	t=0;
	x=[0,1,2,33,4,5,6,7,8,99];
	% x='kfdakjf';
	while t<100
    		fprintf(s,'%d  ',x);
    		t=t+1;
	end
	% stopasync(s);
	fclose(s);
	end
