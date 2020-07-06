clear all;
close all;
load init.mat pos
load positions.mat positions
load size.mat target_sz
load time.mat time
aa = imread('00001_full.jpg');

ground_pos = SelectTarget('00001_full.jpg');
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



new_pos = []
figure(2)
imshow(img2);
for i = 1:size(positions,1)
    y = homography_transform([(positions(i,1)+target_sz(2)/2),(positions(i,2))]', v)
    hold on 
    plot(round(y(2)),round(y(1)),'r.')
    new_pos=[new_pos;round(y(2)),round(y(1))];
end
save hh_mat.mat new_pos


