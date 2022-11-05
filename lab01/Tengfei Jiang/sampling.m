img = imread('white_blood_cells.png');
[Height,Width,n]=size(img);
sampling_factor=2;
for(i=1:sampling_factor:Height)
    for(j=1:sampling_factor:Width)
        img_sampling((i+sampling_factor-1)/sampling_factor,(j+sampling_factor-1)/sampling_factor,1:3)=img(i,j,1:3);
    end
end
imshow(img_sampling);
imwrite(img_sampling,'sampling.jpg');