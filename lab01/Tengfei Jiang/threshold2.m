img = imread('snowman.jpg');
[Height,Width,n]=size(img);
for(i=1:Height)
    for(j=1:Width)
        if (img(i,j)<90) || (img(i,j)>185) 
            img_threshold2(i,j)=0;
        else img_threshold2(i,j)=255;
        end
    end
end
imshow(img_threshold2);
imwrite(img_threshold2,'threshold2.jpg');