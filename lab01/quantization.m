img = imread('white_blood_cells.png');
depth=8;
%depth 8 or 16 or ...
imgR=img(:,:,1);
imgG=img(:,:,2);
imgB=img(:,:,3);
[Height,Width,n]=size(img);
for(i=1:Height)
    for(j=1:Width)
        for(k=0:7)
            if((imgR(i,j)>=k*256/depth)&&(imgR(i,j)<256/depth*(k+1)))
                imgR(i,j)=256/depth/2+256*k/depth;
            end
            if((imgG(i,j)>=k*256/depth)&&(imgG(i,j)<256/depth*(k+1)))
                imgG(i,j)=256/depth/2+256*k/depth;
            end
            if((imgB(i,j)>=k*256/depth)&&(imgB(i,j)<256/depth*(k+1)))
                imgB(i,j)=256/depth/2+256*k/depth;
            end
        end
        img_quantization(i,j,1)=imgR(i,j);                
        img_quantization(i,j,2)=imgG(i,j);
        img_quantization(i,j,3)=imgB(i,j);
    end
end
imshow(img_quantization);
imwrite(img_quantization,'quantization.jpg');
