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

peakthresh=2;
edge_thresh=10;
[f1, d1] = vl_sift(img1); 
[f2, d2] = vl_sift(img2);
[f3, d3] = vl_sift(img3,'PeakThresh', peakthresh,'edgethresh', edge_thresh);
[f4, d4] = vl_sift(img4,'PeakThresh', peakthresh,'edgethresh', edge_thresh);
[f5, d5] = vl_sift(img5,'PeakThresh', peakthresh,'edgethresh', edge_thresh);


[matches, scores] = vl_ubcmatch(d1, d2);
[dump,scoreindex]=sort(scores,'ascend');
pickrate=1;
pair_num=fix(pickrate*size(matches,2));
for i= (1:pair_num)  
    idx = scoreindex(i);
    p(:,i)=[f1(1,matches(1,idx)); f1(2,matches(1,idx))];
%     p_corr(:,i)=[f2(1,matches(2,idx)); f2(2,matches(2,idx))];
end
f_org=f1;
matches_org=matches;
[pair1_2,p_org1]=find_correspondences(d1,d2,f1,f2,f_org,p,p,matches_org,H1,img2,pair_num);
[pair2_3,p_org2]=find_correspondences(d2,d3,f2,f3,f_org,pair1_2,p_org1,matches_org,H2,img3,size(pair1_2,2));
[pair3_4,p_org3]=find_correspondences(d3,d4,f3,f4,f_org,pair2_3,p_org2,matches_org,H3,img4,size(pair2_3,2));
[pair4_5,p_org4]=find_correspondences(d4,d5,f4,f5,f_org,pair3_4,p_org3,matches_org,H4,img5,size(pair3_4,2));

plotRatio=1;
p_base=p_org4;
figure;
imshow(uint8(img1)); 
axis image
% h1 = vl_plotframe(f1); 
% 
% set(h1,'color','g','linewidth',2) ;
hold on
for j= 1:fix(plotRatio*size(p_org4,2))  
    plot(p_base(1,j), p_base(2,j),'ro','LineWidth',2,'MarkerSize',5);
end
for i=(1:4)
    Hp=H(:,:,i);
    p_proj=homography_transform(p_base(:,:),Hp);
    for j= 1:fix(plotRatio*size(p_org4,2))  
        plot(p_proj(1,j), p_proj(2,j),'rx','LineWidth',2,'MarkerSize',5)
        line([p_base(1,j) p_proj(1,j)],[p_base(2,j) p_proj(2,j)], 'linewidth',1, 'color','b')
    end
    p_base=p_proj;
end
    outputname=strcat('P5_sift.jpg');
    saveas(gca,[outputname]);
hold off








