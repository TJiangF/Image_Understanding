% function corners = corner_detector(image)
% name = ('bds');
% filenum = 6;
% path = strcat(name,num2str(filenum));
path='gantrycrane.png';
% path='problem_3_and_4/set4/img2.png';
% path='board.png';
% path='Problem_2/rubix/rubik000.jpg';
% path='coliseum.jpg';
img=imread(path);
[H,W]=size(rgb2gray(img));
% imshow(img);

% I=checkerboard(50,10,10);

corners=corner_detector(img);

imshow(img),hold on,
for i=1:H
    for j=1:W
        if (corners(i,j)~=0)
            plot(j,i,'r+')
        end
    end
end
hold off;      

