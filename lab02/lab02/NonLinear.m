img=imread("salt_and_pepper_coins.png");
size=3;
img_Min=Min_Filter(img,size);
img_Max=Max_Filter(img,size);
img_Med=Med_Filter(img,size);
% test=double(img_Med2)-double(img_Med1);
imwrite(uint8(img_Min),"s&p_min3.jpg");
imwrite(uint8(img_Max),"s&p_max3.jpg");
imwrite(uint8(img_Med),"s&p_med3.jpg");