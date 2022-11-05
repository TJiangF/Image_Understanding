foldername='problem_3_and_4/set';
filenum1 = 1;
filenum2 = 2;
foldernum= 1;
path1 = strcat(foldername,num2str(foldernum),'/','img',num2str(filenum1),'.png');
path2 = strcat(foldername,num2str(foldernum),'/','img',num2str(filenum2),'.png');
img1org=imread(path1);
img2org=imread(path2);

img1=single(im2gray(img1org));
img2=single(im2gray(img2org));

peakthresh=8;
edge_thresh=5;

[f1, d1] = vl_sift(img1,'PeakThresh', peakthresh,'edgethresh', edge_thresh); 
[f2, d2] = vl_sift(img2,'PeakThresh', peakthresh,'edgethresh', edge_thresh);  

[matches, scores] = vl_ubcmatch(d1, d2);
[dump,scoreind]=sort(scores,'ascend');
 
 
%% decide the combiniton depend upon rgb or gray images
if(size(img1org,3)~=1)
    newfig=zeros(size(img1,1), size(img1,2)+size(img2,2),3); 
    newfig(:,1:size(img1,2),:) = img1org;
    newfig(1:size(img2,1) ,(size(img1,2)+1):end,:)=img2org;
    newfig=uint8(newfig);
else 
    newfig=zeros(size(img1,1), size(img1,2)+size(img2,2)); 
    newfig(:,1:size(img1,2)) = img1org;
    newfig(1:size(img2,1) ,(size(img1,2)+1):end)=img2org;
    newfig=uint8(newfig);
end



%% plot features pairs with each other
figure;
imshow(uint8(newfig)); 
axis image
f2Moved=f2;  % move in y direction by f2 
f2Moved(1,:) = f2Moved(1,:)+size(img1,2);
h1 = vl_plotframe(f1); 
h2 = vl_plotframe(f2Moved);
set(h1,'color','g','linewidth',2) ;
set(h2,'color','r','linewidth',2);
hold on
% plot only top 15%
plotRatio=0.15;
for i= 1:fix(plotRatio*size(matches,2))  
    idx = scoreind(i);
    line([f1(1,matches(1,idx)) f2Moved(1,matches(2,idx))],[f1(2,matches(1,idx)) f2Moved(2,matches(2,idx))], 'linewidth',1, 'color','b')
end
hold off
