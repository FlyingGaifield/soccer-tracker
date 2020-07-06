clear all 
close all
currentFolder = pwd;
addpath(genpath(currentFolder));

video_name = 'match';

%get image file names, initial state, and ground truth for evaluation
video_path = ['sequence\', video_name,'\img\'];
img_dir = dir(video_path);
img_files  = cell((size(img_dir)-2)/2);
for i = 1: (size(img_dir)-2)/2
    img_files(i) = cellstr(img_dir(i*2+2).name); 
end

% read the first frame
init_pic_name = char(img_files(1));
% locate the bounding of playground
ground_pos = SelectTarget([video_path ,init_pic_name]);
ground_sz(1) = [ground_pos(1,2)- ground_pos(1,1)];
ground_sz(2) = [ground_pos(2,3)- ground_pos(2,1)];
% [top-left , bottom-left , top-right , bottom-right ]
% [y]               2*4
% [x]
% p2 
%            
%    (1;1) ___________ (1;120)
%         |           | 
%         |           |
%         |           |
%         |           |
%(90;1)  |___________|(90;120)
p2=[1,90,1,90;1,1,120,120];
img2 = ones(90,120);
p1=ground_pos;
v = homography_solve(p1,p2);
%{
%  test homography point transfrom
figure(2)
imshow(init_pic_name)
hold on 
plot(1600,702,'b*')
figure(3)
imshow(img2)
hold on 
y = homography_transform([702,1600]', v)
plot(y(2),y(1),'b*')
%}


% locate the bounding box 
init_pos = SelectTarget([video_path ,init_pic_name]);
target_sz(1) = [init_pos(1,2)- init_pos(1,1)];
target_sz(2) = [init_pos(2,3)- init_pos(2,1)];
pos(1) = init_pos(1,1) + target_sz(1) /2;
pos(2) = init_pos(2,1) + target_sz(2) /2;
%{
for i =1:1%length(img_files)
     jj= imread( [file_name,'/',img_files(3).name] ) ;
     imshow(jj)
     hold on 
     plot(pos(2),pos(1),'*')
     plot(pos(2)-target_sz(2)/2,pos(1)-target_sz(1)/2,'*')
     plot(pos(2)-target_sz(2)/2,pos(1)+target_sz(1)/2,'*')
     plot(pos(2)+target_sz(2)/2,pos(1)+target_sz(1)/2,'*')
     plot(pos(2)+target_sz(2)/2,pos(1)-target_sz(1)/2,'*')
     pause(2)
end
%}

%default settings
kernel.type =  'linear';
padding = 2;  %extra area surrounding the target
lambda1 = 1e-4;     %regularization
lambda2 = 0.4;
interp_factor = 0.005;  %linear interpolation factor for adaptation
output_sigma_factor = 0.1; %spatial bandwidth (proportional to target)

features.gray = false;
features.hog = false;
features.hogcolor = true;
features.hog_orientations = 12;

cell_size = 2;
show_visualization = 0;

%call tracker function with all the relevant parameters
[positions,~, time] = tracker(video_path, img_files, pos, target_sz, ...
            padding, kernel, lambda1, lambda2, output_sigma_factor, interp_factor, ...
			cell_size, features, show_visualization,v);
		



