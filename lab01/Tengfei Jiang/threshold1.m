img = imread('white_blood_cells.png');
imgR=img(:,:,1);
imgG=img(:,:,2);
imgB=img(:,:,3);
[Height,Width,n]=size(img);

for(i=1:Height)
    for(j=1:Width)
        if (imgR(i,j)>230) && (imgG(i,j)>230) && (imgB(i,j)>230)
            imgR(i,j)=0;
            imgG(i,j)=0;
            imgB(i,j)=0;
        end
        img_threshold(i,j,1)=imgR(i,j);
        img_threshold(i,j,2)=imgG(i,j);
        img_threshold(i,j,3)=imgB(i,j);
    end
end
imshow(img_threshold);
imwrite(img_threshold,'threshold.jpg');

              