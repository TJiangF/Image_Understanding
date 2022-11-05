img = imread('white_blood_cells.png');

img_inversion1=imcomplement(img);%function

figure;
imshow(img_inversion1);
imwrite(img_inversion1,'inversion1.jpg');

%process each pixel
imgR=img(:,:,1);
imgG=img(:,:,2);
imgB=img(:,:,3);
[Height,Width,n]=size(img);
for(i=1:Height)
    for(j=1:Width)
        img_inversion2(i,j,1)=255-imgR(i,j);
        img_inversion2(i,j,2)=255-imgG(i,j);
        img_inversion2(i,j,3)=255-imgB(i,j);
    end
end

figure;
imshow(img_inversion2);
imwrite(img_inversion2,'inversion2.jpg');