img = imread('ImageA.jpg');
[Height,Width,n]=size(img);
value=25;%value has to be postive or code has to be changed
for(i=1:Height)
    for(j=1:Width)
%         if (img(i,j)*1.1<=255)
%             img_contrast1(i,j)=img(i,j)*1.1; 
%         else
%             img_contrast1(i,j)=255;
%         end
        if(img(i,j)-value>=0)
            img_contrast1(i,j)=img(i,j)-value;
        else img_contrast1(i,j)=0;
        end
        if (img(i,j)+value<=255)
            img_contrast2(i,j)=img(i,j)+value;
        else img_contrast2(i,j)=255;
        end
    end
end
figure;
imshow(img_contrast1);
figure;
imshow(img_contrast2);
imwrite(img_contrast1,'contrast1.jpg');
imwrite(img_contrast2,'contrast2.jpg');