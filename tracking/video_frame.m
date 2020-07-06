obj = VideoReader('单人遮挡.mp4');%输入视频位置  

numFrames = obj.NumberOfFrames;% 帧的总数  NumberOfFrames  
 for k = 1 : numFrames% 读取所有帧  
     frame = read(obj,k);%读取第几帧
     frame = imrotate(frame,180);
    % imshow(frame);%显示帧
     if mod(k,2) == 0
        index = num2str(k/2) ; 
        for x = size(index,2):4
            index = ['0',index] ;
        end
        imwrite(frame,strcat('sequence/xiong/img/','songjf_',index,'.jpg'),'jpg');% 保存帧  
     end
 end