img_path='Noise_20pcs\';
img_list=dir(strcat(img_path,'*.jpg'));
img_num=length(img_list);
img_sample=imread(strcat(img_path,img_list(1).name));
[Height,Width,n]=size(img_sample);
img_mean=imread('img_mean.jpg');
img_mean_gray=imread('img_gray_mean.jpg');
for(i=1:img_num)
    img_tmp=imread(strcat(img_path,img_list(i).name));
    errorRGB(:,:,:)=double(img_mean)-double(img_tmp);
    img_gray_tmp=rgb2gray(img_tmp);
    errorGray(:,:)=double(img_mean_gray)-double(img_gray_tmp);
end
MD_RGB=max(max(errorRGB))
MD_Gray=max(max(errorGray))
%it doesn't depend on the mean
