obj = VideoReader('�����ڵ�.mp4');%������Ƶλ��  

numFrames = obj.NumberOfFrames;% ֡������  NumberOfFrames  
 for k = 1 : numFrames% ��ȡ����֡  
     frame = read(obj,k);%��ȡ�ڼ�֡
     frame = imrotate(frame,180);
    % imshow(frame);%��ʾ֡
     if mod(k,2) == 0
        index = num2str(k/2) ; 
        for x = size(index,2):4
            index = ['0',index] ;
        end
        imwrite(frame,strcat('sequence/xiong/img/','songjf_',index,'.jpg'),'jpg');% ����֡  
     end
 end