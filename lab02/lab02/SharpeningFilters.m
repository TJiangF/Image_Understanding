img=imread("Circuit_Board_degraded.png");
% img=imread("eyechart_degraded.jpg");
H=fspecial('laplacian',0);
R = imfilter(img,H);%Laplacian
edgeImage = abs(R);
H1 = [0 -1 0;-1 5 -1 ;0 -1 0];
sharpImage = imfilter(img,H1);%Laplacian sharpening filter
figure;
imshow(uint8(sharpImage));
imwrite(uint8(sharpImage),"LaplacianSharpening_Circuit.jpg");
% imwrite(uint8(sharpImage),"LaplacianSharpening_Eye_chart.jpg");

BW = edge(gray,'sobel');
H1 = [-1 -2 -1 ; 0 0 0 ; 1 2 1 ];
H2 = [-1 0 1 ;-2 0 2 ;-1 0 1];
R1 = imfilter(img,H1);
R2 = imfilter(img,H2);
edgeImage=abs(R1)+abs(R2);
sharpImage = img+edgeImage;
figure;
imshow(uint8(sharpImage));
imwrite(uint8(sharpImage),"SobelSharpening_Circuit.jpg");
% imwrite(uint8(sharpImage),"SobelSharpening_Eye_chart.jpg");


