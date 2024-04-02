function data=pGetData_curry8(con,dataBuffer,chanNum,sampleRate)
% data0 = fread(con,20,'uint8');
if (get(con, 'BytesAvailable')==dataBuffer)
    dataOri = fread(con,dataBuffer,'uint8');
    dataOri = uint8(dataOri);

    temp1=typecast(dataOri, 'single');
     temp1(1:5,:)=[];
    temp2 = reshape(temp1,chanNum+1,sampleRate/8);

    k=1;
    while k<=chanNum+1
        if temp2(k,:)==0
            if k~=chanNum+1
                if k==1
                    data2(1:chanNum,:)=temp2(2:end,:);
                    data2(chanNum+1,:)=temp2(1,:);
                else
                    data2(1:(chanNum+1-k),:)=temp2(k+1:end,:);
                    data2(chanNum+2-k:chanNum,:)=temp2(1:k-1,:);
                    data2(13,:)=temp2(k,:);
                end
                break;
            else
                data2=temp2;
                break;
            end
        elseif size(find(temp2(k,:)==0),2)<sampleRate/8&&size(find(temp2(k,:)==0),2)~=0

            index=find(temp2(k,:)==0);
             if k~=chanNum+1
                if k==1
                    data2(1:chanNum,index(1):index(end))=temp2(2:end,index(1):index(end));
                    data2(chanNum+1,index(1):index(end))=temp2(1,index(1):index(end));
                else
                    data2(1:(chanNum+1-k),index(1):index(end))=temp2(k+1:end,index(1):index(end));
                    data2(chanNum+2-k:chanNum,index(1):index(end))=temp2(1:k-1,index(1):index(end));
                    data2(13,index(1):index(end))=temp2(k,index(1):index(end));
                end
                break;
            else
                data2(1:chanNum+1,index(1):index(end))=temp2(1:chanNum+1,index(1):index(end));
                break;
            end
        else
            k=k+1;
        end
    end
    
    
    
    data1=data2';        
%     data1 = temp2';
    % data1 = reshape(temp1, 0.2*sampleRate, chanNum+1);
    data=double(data1);
else
    data=[];
end

