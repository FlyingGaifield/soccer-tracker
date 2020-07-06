clear all;close all;clc;
addpath('ImageStitching')
fileName1='610（左）.mp4';
fileName2='610（右）.mov';
frames = 3300;
frame_flip = 1;



t1 = clock;

dir_left = dir('ImageStitching\imgs\left\');
if size(dir_left,1) == 2
    obj1=VideoReader(fileName1);
    numFrames = obj1.NumberOfFrames;
     for k = 16 : frames+15% 读取所有帧  
         frame = read(obj1,k);%读取第几帧
         if mod(k-15,frame_flip) == 0
            index = num2str((k-15)/frame_flip) ; 
            for x = size(index,2):4
                index = ['0',index] ;
            end
            imwrite(frame,strcat('ImageStitching\imgs\left\','left_',index,'.jpg'),'jpg');% 保存帧  
         end
         %imshow(frame)
         %break
     end
end
dir_left = dir('ImageStitching\imgs\left\');
img_files_left  = cell(size(dir_left)-2);
for i = 1: size(dir_left)-2
    img_files_left(i) = cellstr(dir_left(i+2).name); 
end


dir_right = dir('ImageStitching\imgs\right\');
if size(dir_right,1) == 2
    obj2=VideoReader(fileName2);
    numFrames = obj2.NumberOfFrames;
     for k = 1 : frames% 读取所有帧  
         frame = read(obj2,k);%读取第几帧
         if mod(k,frame_flip) == 0
            index = num2str(k/frame_flip) ; 
            for x = size(index,2):4
                index = ['0',index] ;
            end
            imwrite(frame,strcat('ImageStitching\imgs\right\','right_',index,'.jpg'),'jpg');% 保存帧  
         end
         
         %hold on
         %imshow(frame)
         %break
     end

end
dir_right = dir('ImageStitching\imgs\right\');
img_files_right  = cell(size(dir_right)-2);
for i = 1: size(dir_right)-2
    img_files_right(i) = cellstr(dir_right(i+2).name); 
end




disp(['reading done cost',num2str(etime(clock,t1))]);
readtime = etime(clock,t1);


run('ImageStitching/lib/vlfeat-0.9.20/toolbox/vl_setup');


path = 'ImageStitching\imgs\';
h=[];
for k =1 :1: frames/frame_flip
     t3 = clock ; 
     img1 = imread([path,'left\',char(img_files_left(k))]);
     img2 = imread([path,'right\',char(img_files_right(k))]);
     img2_0(:,:,1) = imresize(img2(:,:,1),1.5);
     img2_0(:,:,2) = imresize(img2(:,:,2),1.5);
     img2_0(:,:,3) = imresize(img2(:,:,3),1.5);
     %img1 = imrotate(img1,180);
     img1_1 = img1(531:end-100,1:end,:);
     img2_1 = img2_0(531:end-100,1:end,:);
     %imwrite(img1_1,'img1.jpg');
     %imwrite(img2_1,'img2.jpg');
     %imshow(img2_1)
     img3(:,:,1) = imresize(img1_1(:,:,1),0.5);
     img3(:,:,2) = imresize(img1_1(:,:,2),0.5);
     img3(:,:,3) = imresize(img1_1(:,:,3),0.5);
     img4(:,:,1) = imresize(img2_1(:,:,1),0.5);
     img4(:,:,2) = imresize(img2_1(:,:,2),0.5);
     img4(:,:,3) = imresize(img2_1(:,:,3),0.5);
     %figure(1)
     %imshow(img3)
     %figure(2)
     %imshow(img2)
     %imwrite(img3,'img1.jpg')
     %imwrite(img2,'img2.jpg')
     imgs(:,:,:,1)=img3;
     imgs(:,:,:,2)=img4;

     matchExp = false ;
     blend = 'Alpha' ; 
     [full_img,h] = createPanoramaPla(imgs, matchExp, blend,k,h);
     index = num2str(k) ; 
     for x = size(index,2):4
         index = ['0',index] ;
     end
     imshow(full_img);
     %imwrite(full_img, ['result\no_blending\',index,'_full.jpg']);
     disp(['current procedure is ',num2str(k*100/(frames/frame_flip)),' % , time cost ',num2str(etime(clock,t3)),' seconds.']);
end  
wholetime = etime(clock,t1);
disp(['panorama time is ',num2str(wholetime),' seconds'])
