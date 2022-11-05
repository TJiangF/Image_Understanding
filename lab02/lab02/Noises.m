img1=imread("salt_and_pepper_coins.png");
img2=imread("traffic.jpg");
spgauss=GaussianFilter(img1,7,2);
boxfilter=1/16*[1 2 1;2 4 2;1 2 1];
spbox=my_conv(img1,boxfilter);
% figure();
% imshow(uint8(spbox));
% figure();
% imshow(uint8(spgauss));
imwrite(uint8(spbox),"spbox.jpg");
imwrite(uint8(spgauss),"spgauss72.jpg");
img_Min=Min_Filter(img2,5);
img_Max=Max_Filter(img2,5);
img_Med=Med_Filter(img2,5);
imwrite(img_Min,"traffic_min5.jpg");
imwrite(img_Max,"traffic_max5.jpg");
imwrite(img_Med,"traffic_med5.jpg");