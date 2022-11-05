window_size=3;
k_size=(window_size-1)/2;
sigma=0.5;
ParaSum=0;
for(i=1:window_size)
    for(j=1:window_size)
        H(i,j)=double(exp((-((i-k_size-1)^2)-(j-k_size-1)^2)/(2*sigma*sigma)));
        ParaSum=ParaSum+H(i,j);
    end
end
for(i=1:window_size)
    for(j=1:window_size)
        H(i,j)=H(i,j)/ParaSum;
    end
end
% image1=imread("Lenna.png");
% image2=imread("traffic.jpg");
% Lenna_Gaus1=my_conv(image1,H);
% Traffic_Gaus1=my_conv(image2,H);
% imwrite(uint8(Lenna_Gaus1),'Lenna_Gaus72.jpg');
% imwrite(uint8(Traffic_Gaus1),'Traffic_Gaus72.jpg');
% H
% H_compare=fspecial('gaussian',3,0.5)
