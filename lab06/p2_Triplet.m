clear;
foldername='images/problem_2/';
filename1 = 'half_dome/halfdome-05.png';
filename2 = 'half_dome/halfdome-06.png';
filename3 = 'half_dome/halfdome-07.png';
filename4 = 'hotel/hotel-00.png';
filename5 = 'hotel/hotel-01.png';
filename6 = 'hotel/hotel-02.png';

path1=strcat(foldername,filename4);
path2=strcat(foldername,filename5);
path3=strcat(foldername,filename6);

img1org=imread(path1);
img2org=imread(path2);
img3org=imread(path3);

img1=single(im2gray(img1org));
img2=single(im2gray(img2org));
img3=single(im2gray(img3org));

peakthresh=2;
edge_thresh=10;

[f1, d1] = vl_sift(img1,'PeakThresh', peakthresh,'edgethresh', edge_thresh); 
[f2, d2] = vl_sift(img2,'PeakThresh', peakthresh,'edgethresh', edge_thresh);  
  


[matches_1, scores_1] = vl_ubcmatch(d1, d2);
[dump,scoreindex1]=sort(scores_1,'ascend');

lowesratio=0.5;
pair_num=fix(lowesratio*size(matches_1,2));

for i= (1:pair_num)  
    idx = scoreindex1(i);
    p(:,i)=[f1(1,matches_1(1,idx)); f1(2,matches_1(1,idx))];
    p_corr(:,i)=[f2(1,matches_1(2,idx)); f2(2,matches_1(2,idx))];
end


picknum=4;% 4 as required, but with SVD, we can use more
[height,width]=size(img2);
for i=(1:1000)
    randompick(:)=ceil(pair_num*rand(1,picknum));
    for m=(1:picknum)
%         randompick(m)
        matches1(:,m)=p(:,randompick(m));
        matches2(:,m)=p_corr(:,randompick(m));
    end
%     visualize_matches(img1,img2,matches1,matches2,4);

    H_tmp=Ransac4Homography(matches1,matches2);
    if(i==1)
        H1=H_tmp;
        max_inlier_ratio=0;
    end
    inlier=0;
    
    for k= (1:pair_num)  
        idx = scoreindex1(k);
        p_tmp=homography_transform(p(:,k),H_tmp);
        if(p_tmp(1)>0 && p_tmp(1)<=width && p_tmp(2)>0 && p_tmp(2)<=height)
            p_compare=p_corr(:,k);
            dis=sqrt((p_tmp(1)-p_compare(1))^2+(p_tmp(2)-p_compare(2))^2);
            if(dis<=1)
                inlier=inlier+1;
            end
        end
    end
    inlier_ratio=inlier/pair_num;
    if (inlier_ratio>max_inlier_ratio)
        H1=H_tmp;
        max_inlier_ratio=inlier_ratio;
        for m=(1:picknum)
            best11(m,:)=matches1(:,m);
            best12(m,:)=matches2(:,m);
        end
        
    end
end



% visualize_matches(img1_resize,img2,best1,best2,picknum);
[warpedImage1, leftTopUnwarpX1, leftTopUnwarpY1, warpImgWeight1]=getNewImg(H1,img1org,img2org);


% figure;
% imshow(warpedImage1);
% figure;
% imshow(warpedImage2);
% 
blendType1='weightBlend';
blendType2='maxValue';
blendType3='linearBlend';
blendType4='AvgBlend';

stitchedImage1 = blendImgs(warpedImage1, img1org, leftTopUnwarpX1, leftTopUnwarpY1, blendType1, warpImgWeight1);
% stitchedImage2 = blendImgs(warpedImage1, img1org, leftTopUnwarpX1, leftTopUnwarpY1, blendType2, warpImgWeight1);
% stitchedImage3 = blendImgs(warpedImage1, img1org, leftTopUnwarpX1, leftTopUnwarpY1, blendType3, warpImgWeight1);
% stitchedImage4 = blendImgs(warpedImage1, img1org, leftTopUnwarpX1, leftTopUnwarpY1, blendType4, warpImgWeight1);

stitchedImage_single=single(stitchedImage1(:,:,1));
[f1, d1] = vl_sift(stitchedImage_single,'PeakThresh', peakthresh,'edgethresh', edge_thresh);
[f2, d2] = vl_sift(img3,'PeakThresh', peakthresh,'edgethresh', edge_thresh);
[matches_2, scores_2] = vl_ubcmatch(d1, d2);
[dump,scoreindex2]=sort(scores_2,'ascend');

lowesratio=0.5;
pair_num2=fix(lowesratio*size(matches_2,2));

for i= (1:pair_num2)  
    idx = scoreindex2(i);
    p2(:,i)=[f1(1,matches_2(1,idx)); f1(2,matches_2(1,idx))];
    p_corr2(:,i)=[f2(1,matches_2(2,idx)); f2(2,matches_2(2,idx))];
end

picknum=4;% 4 as required, but with SVD, we can use more
[height,width]=size(img3);
for i=(1:1000)
    randompick(:)=ceil(pair_num2*rand(1,picknum));
    for m=(1:picknum)
%         randompick(m)
        matches1(:,m)=p2(:,randompick(m));
        matches2(:,m)=p_corr2(:,randompick(m));
    end
%     visualize_matches(img1,img2,matches1,matches2,4);

    H_tmp=Ransac4Homography(matches1,matches2);
    if(i==1)
        H2=H_tmp;
        max_inlier_ratio=0;
    end
    inlier=0;
    
    for k= (1:pair_num2)  
        idx = scoreindex2(k);
        p_tmp=homography_transform(p2(:,k),H_tmp);
        if(p_tmp(1)>0 && p_tmp(1)<=width && p_tmp(2)>0 && p_tmp(2)<=height)
            p_compare=p_corr2(:,k);
            dis=sqrt((p_tmp(1)-p_compare(1))^2+(p_tmp(2)-p_compare(2))^2);
            if(dis<=1)
                inlier=inlier+1;
            end
        end
    end
    inlier_ratio=inlier/pair_num2;
    if (inlier_ratio>max_inlier_ratio)
        H2=H_tmp;
        max_inlier_ratio=inlier_ratio;
        for m=(1:picknum)
            best21(m,:)=matches1(:,m);
            best22(m,:)=matches2(:,m);
        end
        
    end
end


[warpedImage2, leftTopUnwarpX2, leftTopUnwarpY2, warpImgWeight2]=getNewImg(H2,stitchedImage1,img3org);


stitchedImage5 = blendImgs(warpedImage2, stitchedImage1, leftTopUnwarpX2, leftTopUnwarpY2, blendType1, warpImgWeight2);
% stitchedImage6 = blendImgs(warpedImage2, stitchedImage1, leftTopUnwarpX2, leftTopUnwarpY2, blendType1, warpImgWeight2);
% stitchedImage7 = blendImgs(warpedImage2, stitchedImage1, leftTopUnwarpX2, leftTopUnwarpY2, blendType1, warpImgWeight2);
% stitchedImage8 = blendImgs(warpedImage2, stitchedImage1, leftTopUnwarpX2, leftTopUnwarpY2, blendType1, warpImgWeight2);
% figure;
% imshow(uint8(stitchedImage5));
% % 
imgname='hotel';
name1=strcat(imgname,blendType1,'.jpg');
% name2=strcat(imgname,blendType2,'.jpg');
% name3=strcat(imgname,blendType3,'.jpg');
% name4=strcat(imgname,blendType4,'.jpg');
imwrite(uint8(stitchedImage5),name1);
% imwrite(uint8(stitchedImage6),name2);
% imwrite(uint8(stitchedImage7),name3);
% imwrite(uint8(stitchedImage8),name4);
% 
