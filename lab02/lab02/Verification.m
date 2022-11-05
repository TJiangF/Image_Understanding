% image=magic(10);
image=imread("ImageB.jpg");
% filter=1/6*ones(3,3);
filter=[0 1 0;1 -4 1;0 1 0];
matlab_output=imfilter(image,filter);
my_output=my_conv(image,filter);
test=double(matlab_output)-double(my_output);

figure;
imshow(uint8(my_output));
figure;
imshow(matlab_output);