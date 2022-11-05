img_path='Noise_20pcs\';
img_list=dir(strcat(img_path,'*.jpg'));
img_num=length(img_list);
img_sample=imread(strcat(img_path,img_list(1).name));
[Height,Width,n]=size(img_sample);
for(k=1:img_num)
    img_tmp=imread(strcat(img_path,img_list(k).name));
    img(k,1:Height,1:Width,1:3)=img_tmp(1:Height,1:Width,1:3);
%   img_gray_tmp=rgb2gray(img_tmp);
%   img_double=double(img_tmp);
%   imshow(img_gray)
%   img_gray(1:Height,1:Width,k)=img_gray_tmp(1:Height,1:Width);

end

% img_tmp(:,:,1:3)=img(1,:,:,1:3);
% imshow(img_tmp);
% imshow(img_gray(:,:,2));

for(i=1:Height)
    for(j=1:Width)
          img_mean(i,j,1:3)=mean(img(1:img_num,i,j,1:3));

          img_std1(i,j,1)=std2(double(img(1:img_num,i,j,1)));
          img_std2(i,j,1)=std2(double(img(1:img_num,i,j,2)));
          img_std3(i,j,1)=std2(double(img(1:img_num,i,j,3)));

%----------------gray image mean-----------------------------------
%             img_gray_mean(i,j)=mean(img_gray(i,j,1:img_num));
%------------------------------------------------------------------

%             pixelR=round(mean(imgR(1:img_num,i,j)));
%             pixelG=round(mean(imgG(1:img_num,i,j)));
%             pixelB=round(mean(imgB(1:img_num,i,j)));
%             img_mean(i,j,1)=pixelR;
%             img_mean(i,j,2)=pixelG;
%             img_mean(i,j,3)=pixelB;
    end
    i
end

% imshow(uint8(img_gray_mean));
% imwrite(uint8(img_gray_mean),'img_gray_mean.jpg');


img_std(:,:,1)=img_std1;
img_std(:,:,2)=img_std2;
img_std(:,:,3)=img_std3;

figure;
imshow(img_std);

figure;
imshow(uint8(img_mean));

imwrite(uint8(img_mean),'img_mean.jpg');
imwrite(img_std,'img_std.jpg');





