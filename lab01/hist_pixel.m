img_path='Noise_20pcs\';
img_list=dir(strcat(img_path,'*.jpg'));
img_num=length(img_list);
img_sample=imread(strcat(img_path,img_list(1).name));
[Height,Width,n]=size(img_sample);
x=1200;
y=1400;
for(i=1:img_num)
    img_tmp=imread(strcat(img_path,img_list(i).name));
    RGB(1:3)=[img_tmp(x,y,1),img_tmp(x,y,2),img_tmp(x,y,3)];
    img_gray_tmp=rgb2gray(img_tmp);
    PixelGray(i)=img_gray_tmp(x,y);
    PixelRGB(i,1:3)=[RGB(1),RGB(2),RGB(3)];
end

pixel_gray_intens=PixelGray(1:img_num);

figure('Name','Gray_intensity');
imhist(pixel_gray_intens);
figure('Name','R_intensity');
imhist(PixelRGB(1:20,1));
figure('Name','G_intensity');
imhist(PixelRGB(1:20,2));
figure('Name','B_intensity');
imhist(PixelRGB(1:20,3));
% [Pixel_R,pics]=hist(Pixel(1:img_num,1),1:img_num);