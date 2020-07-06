clear all;close all;clc;

img1=imread('lenna.jpg');
[h1 w1]=size(img1);
mask=uint8(ones(h1,w1));    %��ֵģ�壬�������ĺϳ�

img2=imread('pai.jpg');
[h2 w2]=size(img2);

imshow(img1);
figure;imshow(img2);

p1=[1,1;w1,1;1,h1;w1,h1];
%p2=ginput();        %���ε�����������ϡ����ϡ����¡�����
p2=[107,8;435,111;93,157;442,229]
T=calc_homography(p1,p2);   %���㵥Ӧ�Ծ���
T=maketform('projective',T);   %ͶӰ����

[imgn X Y]=imtransform(img1,T);     %ͶӰ
mask=imtransform(mask,T);
imshow(imgn)
T2=eye(3);
if X(1)>0, T2(3,1)= X(1); end
if Y(1)>0, T2(3,2)= Y(1); end
T2=maketform('affine',T2);      %�������

imgn=imtransform(imgn,T2,'XData',[1 w2],'YData',[1 h2]);    %����
mask=imtransform(mask,T2,'XData',[1 w2],'YData',[1 h2]);
figure;
imshow(imgn)
hold on 
plot(109,11,'b*')
img=img2.*(1-mask)+imgn.*mask;  %�ϳ�
figure;imshow(img,[])