function [] = chuangkoushujushuchu()
	%ʵʱ��ӡ��������2017/4/25---2016/4/26
	%pc�巢�����ݣ�MATLAB���ô��ڽ���pc�巢�͵����ݣ�����ӡʵʱ��ͼ��
	s=serial('COM8');
	set(s,'BaudRate',115200,'StopBits',1,'DataBits',8,'Parity','none','InputBufferSize',128);%���ô��ڲ����ʣ���żУ��λ �� ������ʽ
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
