foldername='problem_5';
for i=(1:4)
    path = strcat(foldername,'/',num2str(i),'.png');
    path4H= strcat(foldername,'/H_',num2str(i),'to',num2str(i+1),'.txt');
    img(:,:,i)=im2gray(imread(path));
    H(:,:,i)=load(path4H);
end
img1=single(img(:,:,1));
img2=single(img(:,:,2));
img3=single(img(:,:,3));
img4=single(img(:,:,4));
path = strcat(foldername,'/',num2str(5),'.png');
img5=single(im2gray(imread(path)));
H1=H(:,:,1);
H2=H(:,:,2);
H3=H(:,:,3);
H4=H(:,:,4);

corners1=corner_detector(img1);
corners2=corner_detector(img2);
corners3=corner_detector(img3);
corners4=corner_detector(img4);
corners5=corner_detector(img5);

[height,width]=size(corners1);

pairnum1=0;
pairnum2=0;
pairnum3=0;
pairnum4=0;
pairnum5=0;

for i=(1:height)
    for j=(1:width)
        if(corners1(i,j)~=0)
            pairnum1=pairnum1+1;
            p1(:,pairnum1)=[i,j,pairnum1];
            p1c(:,pairnum1)=[i,j];
%             pindex(pairnum1)=pairnum1;
        end
        if(corners2(i,j)~=0)
            pairnum2=pairnum2+1;
            p2c(:,pairnum2)=[i,j];
        end
        if(corners3(i,j)~=0)
            pairnum3=pairnum3+1;
            p3c(:,pairnum3)=[i,j];
        end
        if(corners4(i,j)~=0)
            pairnum4=pairnum4+1;
            p4c(:,pairnum4)=[i,j];
        end
        if(corners5(i,j)~=0)
            pairnum5=pairnum5+1;
            p5c(:,pairnum5)=[i,j];
        end
    end
end



% pindex=p1c;
% p_org=p1c;

p_proj2=find_correspondences_corners(p1,p2c,H1,height,width);
p_proj3=find_correspondences_corners(p_proj2,p3c,H2,height,width);
p_proj4=find_correspondences_corners(p_proj3,p4c,H3,height,width);
p_proj5=find_correspondences_corners(p_proj4,p5c,H4,height,width);

corners(1:2,:)=p1(1:2,p_proj5(3,:));
figure;
imshow(uint8(img1)); 
axis image
hold on
for j= 1:fix(size(corners,2))  
    plot(corners(1,j), corners(2,j),'ro','LineWidth',2,'MarkerSize',5)
end

for i=(1:4)
    Hp=H(:,:,i);
    p_proj=homography_transform(corners(:,:),Hp);
    for j= 1:fix(size(p_proj5,2))  
        plot(p_proj(1,j), p_proj(2,j),'rx','LineWidth',2,'MarkerSize',5)
        line([corners(1,j) p_proj(1,j)],[corners(2,j) p_proj(2,j)], 'linewidth',1, 'color','b')
    end
    corners=p_proj;
end
hold off
% [pair2,pindex]=find_correspondences_corners(corners2,corners3,H2,pindex);
% for i=(1:pairnum)
%     plot(pair1(1,i), pair1(2,i),'r+');
% end
% 
% [pair2,pair3]=find_correspondences_corners(corners1,corners2,H1);
% 



