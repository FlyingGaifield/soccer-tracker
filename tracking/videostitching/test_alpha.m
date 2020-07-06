load('newImg.mat','newImg');
load('imgs.mat','imgs');
load('mask.mat','mask');
load('backTransforms.mat','backTransforms');
newHeight = 491 ; 
newWidth = 2864 ;
nChannels = 3 ;
nImgs = 2;
height = 293 ;
width = 1248 ;

[X,~]=meshgrid(1:newHeight);
B1=repmat(X(1,:),newWidth,1);
outer = reshape(B1,1,size(B1,1)*size(B1,2));
[X,Y]=meshgrid(1:newWidth);
iner =repmat(Y(:,1)',1,newHeight);

total_t = [outer ; iner; ones(1,newHeight*newWidth)];
pixelSum = zeros(size(total_t));
alphaSum = zeros(1,size(total_t,2));

for k =1 : 2
    total_tran = backTransforms(:,:,k) * total_t;
    z_y = total_tran(1,:)./total_tran(3,:)  ;
    z_x = total_tran(2,:)./total_tran(3,:)  ; 
    %find index of which satisfy the condition
    ind_y_1 = find( z_y >= 1 );
    ind_y_2 = find( z_y  < height );
    ind_x_1 = find( z_x >= 1 );
    ind_x_2 = find( z_x  < width );
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

    imgs_1 = imgs(:, :, 1, k);
    imgs_2 = imgs(:, :, 2, k);
    imgs_3 = imgs(:, :, 3, k);
    pixel_1 = im2uint8(1 - a)./255 .* im2uint8(1 - b)./255 .* imgs_1(sub2ind(size(imgs_1),j,i)) ...
                + im2uint8(a)./255 .* im2uint8(1 - b)./255 .* imgs_1(sub2ind(size(imgs_1),j,i+1))...
                + im2uint8(a)./255 .* im2uint8(b)./255 .* imgs_1(sub2ind(size(imgs_1),j+1,i+1))...
                + im2uint8(1 - a)./255 .* im2uint8(b)./255 .* imgs_1(sub2ind(size(imgs_1),j+1,i));
    pixel_2 = im2uint8(1 - a)./255 .* im2uint8(1 - b)./255 .* imgs_2(sub2ind(size(imgs_2),j,i)) ...
                + im2uint8(a)./255 .* im2uint8(1 - b)./255 .* imgs_2(sub2ind(size(imgs_2),j,i+1))...
                + im2uint8(a)./255 .* im2uint8(b)./255 .* imgs_2(sub2ind(size(imgs_2),j+1,i+1))...
                + im2uint8(1 - a)./255 .* im2uint8(b)./255 .* imgs_2(sub2ind(size(imgs_2),j+1,i));
    pixel_3 = im2uint8(1 - a)./255 .* im2uint8(1 - b)./255 .* imgs_3(sub2ind(size(imgs_3),j,i)) ...
                + im2uint8(a)./255 .* im2uint8(1 - b)./255 .* imgs_3(sub2ind(size(imgs_3),j,i+1))...
                + im2uint8(a)./255 .* im2uint8(b)./255 .* imgs_3(sub2ind(size(imgs_3),j+1,i+1))...
                + im2uint8(1 - a)./255 .* im2uint8(b)./255 .* imgs_3(sub2ind(size(imgs_3),j+1,i));        
    alpha = (1 - a) .* (1 - b) .* double(mask(sub2ind(size(mask),j,i))) ...
                + a .* (1 - b) .* double(mask(sub2ind(size(mask),j,i+1)))...
                + a .* b .* double(mask(sub2ind(size(mask),j+1,i+1)))...
                + (1 - a) .* b .* double(mask(sub2ind(size(mask),j+1,i)));
    pixelSum(1,ind) =  pixelSum(1,ind)  + double(pixel_1).* alpha; 
    pixelSum(2,ind) =  pixelSum(2,ind)  + double(pixel_2).* alpha;
    pixelSum(3,ind) =  pixelSum(3,ind)  + double(pixel_3).* alpha;
    alphaSum(1,ind) =  alphaSum(1,ind) + alpha;       


end
        
        
    
newImg_1 = newImg(:,:,1);
newImg_2 = newImg(:,:,2);
newImg_3 = newImg(:,:,3);

newImg_1(sub2ind(size(newImg_1),outer,iner) ) = pixelSum(1,:) ./alphaSum(1,:) ; 
newImg_2(sub2ind(size(newImg_2),outer,iner) ) = pixelSum(2,:) ./alphaSum(1,:) ; 
newImg_3(sub2ind(size(newImg_2),outer,iner) ) = pixelSum(3,:) ./alphaSum(1,:) ; 
newImg(:,:,1) = newImg_1;
newImg(:,:,2) = newImg_2;
newImg(:,:,3) = newImg_3;
imshow(newImg)


