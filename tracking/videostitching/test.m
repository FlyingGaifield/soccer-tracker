fullImageHeight = 1193;
minX =907 ;
maxX = 2914 ; 
deltaX = 2007;
load('img.mat','img');
load('transform.mat','transform')

transImg = zeros(fullImageHeight, deltaX, 3, 'uint8');

% change the two level for into matrix

[X,~]=meshgrid(1:fullImageHeight);
B1=repmat(X(1,:),maxX-minX+1,1);
outer = reshape(B1,1,size(B1,1)*size(B1,2));
[X,Y]=meshgrid(minX:maxX);
iner =repmat(Y(:,1)',1,fullImageHeight);

total_t = [outer ; iner; ones(1,(maxX-minX+1)*fullImageHeight)];
% do homography
total_tran = transform \ total_t;
z_y = total_tran(1,:)./total_tran(3,:)  ;
z_x = total_tran(2,:)./total_tran(3,:)  ; 
%find index of which satisfy the condition
ind_y_1 = find( z_y >= 1 );
ind_y_2 = find( z_y  < size(img,1) );
ind_x_1 = find( z_x >= 1 );
ind_x_2 = find( z_x  < size(img,2) );
ind_y = intersect(ind_y_1,ind_y_2);
ind_x = intersect(ind_x_1,ind_x_2);
ind = intersect(ind_x,ind_y);
% get value according to the index
test_y = total_t(1,:);    %original y 
before_y = test_y(ind); 
after_y = z_y(ind) ;
test_x = total_t(2,:);    %original x
before_x = test_x(ind); 
after_x = z_x(ind) ;
i = floor(after_x) ;
a = after_x - i ;
j = floor(after_y) ;
b = after_y - j ;


transImg_1 = transImg(:,:,1);
transImg_2 = transImg(:,:,2);
transImg_3 = transImg(:,:,3);
img_1_h = img(:,:,1);
img_2_h = img(:,:,2);
img_3_h = img(:,:,3);
jj = before_x- minX + 1 ;
%sub2ind(size(transImg_1),before_y,jj) ;
aaaaaa = find(jj >= 2007)

transImg_1(sub2ind(size(transImg_1),before_y,before_x- minX + 1) ) =  im2uint8(1-a)./255.*im2uint8(1-b)./255.*img_1_h(sub2ind(size(img_1_h),j,i) )...
                    + im2uint8(a)./255 .* im2uint8(1 - b)./255.*img_1_h(sub2ind(size(img_1_h),j,i+1) ) ...
                   + im2uint8(a) ./255.* im2uint8(b)./255 .*img_1_h(sub2ind(size(img_1_h),j+1,i+1) ) ...
                    + im2uint8(1 - a)./255 .* im2uint8(b)./255 .*img_1_h(sub2ind(size(img_1_h),j+1,i) ) ;
transImg_2(sub2ind(size(transImg_2),before_y,before_x- minX + 1) ) =  im2uint8(1-a)./255.*im2uint8(1-b)./255.*img_2_h(sub2ind(size(img_2_h),j,i) )...
                    + im2uint8(a) ./255.* im2uint8(1 - b)./255.*img_2_h(sub2ind(size(img_2_h),j,i+1) ) ...
                   + im2uint8(a)./255.* im2uint8(b)./255 .*img_2_h(sub2ind(size(img_2_h),j+1,i+1) ) ...
                    + im2uint8(1 - a) ./255.* im2uint8(b)./255 .*img_2_h(sub2ind(size(img_2_h),j+1,i) ) ;
transImg_3(sub2ind(size(transImg_3),before_y,before_x- minX + 1) ) =  im2uint8(1-a)./255.*im2uint8(1-b)./255.*img_3_h(sub2ind(size(img_3_h),j,i) )...
                    + im2uint8(a) ./255.* im2uint8(1 - b)./255.*img_3_h(sub2ind(size(img_3_h),j,i+1) ) ...
                   + im2uint8(a) ./255.* im2uint8(b)./255 .*img_3_h(sub2ind(size(img_3_h),j+1,i+1) ) ...
                    + im2uint8(1 - a)./255 .* im2uint8(b)./255 .*img_3_h(sub2ind(size(img_3_h),j+1,i) ) ;
output_hhhh(:,:,1)= transImg_1;
output_hhhh(:,:,2)= transImg_2;
output_hhhh(:,:,3)= transImg_3;
transImg = output_hhhh ; 
                 
imshow(transImg)

