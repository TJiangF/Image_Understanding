filter1=1/9*ones(3,3);
filter2=1/16*[1 2 1;2 4 2;1 2 1];
filter3=1/3*[0 0 0;1 1 1;0 0 0];
filter4=1/3*[0 1 0;0 1 0;0 1 0];
filter5=1/5*[0 1 0;1 1 1;0 1 0];
filter6=1/25*ones(5,5);
filter7=1/25*[0 1 1 1 0;1 1 1 1 1;1 1 1 1 1;1 1 1 1 1;0 1 1 1 0];
%filter5 & 7 is not separatable

img=imread("Lenna.png");
filter=fspecial('gaussian',7,0.5)
rank(filter7);
[isSeparable,hcol,hrow] = isfilterseparable(filter);
%determine whether a matrix is separable or not

tic
img_out=conv2(img,filter,"same");

% img_out=conv2(conv2(img,hcol,'valid'),hrow,'valid');


% these written functions work as well, while in order to make comparsion
% fair, I used conv2 function and record the time.

% img_out=my_conv(img,filter)
% img_out=GaussianFilter(img,35,2);
% img_out=separate_conv(img,hcol,hrow);

toc
imshow(uint8(img_out));
