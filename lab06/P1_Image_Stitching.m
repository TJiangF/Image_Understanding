clear;
foldername='images/problem_1/';
filename1 = 'Golden_Gate/goldengate-02.png';
filename2 = 'Golden_Gate/goldengate-03.png';
filename3 = 'LEMS_lab/lems-01.png';
filename4 = 'LEMS_lab/lems-02.png';
filename5 = 'PVD_City_Hall/1900.jpg';
filename6 = 'PVD_City_Hall/2016.jpg';

path1=strcat(foldername,filename5);
path2=strcat(foldername,filename6);

img1org=imread(path1);
img2org=imread(path2);

img1=single(im2gray(img1org));
img2=single(im2gray(img2org));

peakthresh=2;
edge_thresh=10;

[f1, d1] = vl_sift(img1,'PeakThresh', peakthresh,'edgethresh', edge_thresh); 
[f2, d2] = vl_sift(img2,'PeakThresh', peakthresh,'edgethresh', edge_thresh);  

[matches, scores] = vl_ubcmatch(d1, d2);
[dump,scoreindex]=sort(scores,'ascend');

lowesratio=0.5;
pair_num=fix(lowesratio*size(matches,2));

for i= (1:pair_num)  
    idx = scoreindex(i);
    p(:,i)=[f1(1,matches(1,idx)); f1(2,matches(1,idx))];
    p_corr(:,i)=[f2(1,matches(2,idx)); f2(2,matches(2,idx))];
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
        H=H_tmp;
        max_inlier_ratio=0;
    end
    inlier=0;
    
    for k= (1:pair_num)  
        idx = scoreindex(k);
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
        H=H_tmp;
        max_inlier_ratio=inlier_ratio;
        for m=(1:picknum)
            best1(m,:)=matches1(:,m);
            best2(m,:)=matches2(:,m);
        end
        
    end
end
if(size(img1)~=size(img2))
    [h,w]=size(img1);
    img1_resize=imresize(img1,[height,width]);
    best1(:,2)=best1(:,2)*(height/h);
    best1(:,1)=best1(:,1)*(width/w);
end
visualize_matches(img1_resize,img2,best1,best2,picknum);
[warpedImage, leftTopUnwarpX, leftTopUnwarpY, warpImgWeight]=getNewImg(H,img1org,img2org);

blendType1='weightBlend';
blendType2='maxValue';
blendType3='linearBlend';
blendType4='AvgBlend';

stitchedImage1 = blendImgs(warpedImage, img1org, leftTopUnwarpX, leftTopUnwarpY, blendType1, warpImgWeight);
stitchedImage2 = blendImgs(warpedImage, img1org, leftTopUnwarpX, leftTopUnwarpY, blendType2, warpImgWeight);
stitchedImage3 = blendImgs(warpedImage, img1org, leftTopUnwarpX, leftTopUnwarpY, blendType3, warpImgWeight);
stitchedImage4 = blendImgs(warpedImage, img1org, leftTopUnwarpX, leftTopUnwarpY, blendType4, warpImgWeight);

imgname='cityhall';
name1=strcat(imgname,blendType1,'.jpg');
name2=strcat(imgname,blendType2,'.jpg');
name3=strcat(imgname,blendType3,'.jpg');
name4=strcat(imgname,blendType4,'.jpg');
imwrite(uint8(stitchedImage1),name1);
imwrite(uint8(stitchedImage2),name2);
imwrite(uint8(stitchedImage3),name3);
imwrite(uint8(stitchedImage4),name4);

