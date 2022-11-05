path1='images/planar_rotation_change/img1.png';
path2='images/planar_rotation_change/img2.png';
pathH='images/planar_rotation_change/H_1to2.txt';
% path1='images/scale_rotation_change/img1.png';
% path2='images/scale_rotation_change/img2.png';
% pathH='images/scale_rotation_change/H_1to2.txt';
% path1='images/illumination_change/img1.png';
% path2='images/illumination_change/img2.png';
% pathH='images/illumination_change/H_1to2.txt';
% path1='images/view_change/img1.png';
% path2='images/view_change/img2.png';
% pathH='images/view_change/H_1to2.txt';
H=load(pathH);
img1=imread(path1);
img2=imread(path2);
img1=single(im2gray(img1));
img2=single(im2gray(img2));
shownum=20;
peakthresh=8;
edge_thresh=5;
Lowetest_ratio=0.9;

[f1, d1] = vl_sift(img1,'PeakThresh', peakthresh,'edgethresh', edge_thresh); 
[f2, d2] = vl_sift(img2,'PeakThresh', peakthresh,'edgethresh', edge_thresh);  

[matches, scores] = vl_ubcmatch(d1, d2);
[dump,scoreind]=sort(scores,'ascend');
for i= 1:shownum
%     idx = scoreind(i);
    matches1(i,1:2)=[f1(1,matches(1,scoreind(i))) f1(2,matches(1,scoreind(i)))];
    matches2(i,1:2)=[f2(1,matches(2,scoreind(i))) f2(2,matches(2,scoreind(i)))];
end
visualize_matches(img1,img2,matches1,matches2,shownum);
pair_num=Lowetest_ratio*size(matches,2);
for i= (1:pair_num)  
    idx = scoreind(i);
    p(:,i)=[f1(1,matches(1,idx)); f1(2,matches(1,idx))];
    p_corr(:,i)=[f2(1,matches(2,idx)); f2(2,matches(2,idx))];
end
[height,width]=size(img2);
pair=0;
for i= (1:pair_num)  
    idx = scoreind(i);
    p_tmp=homography_transform(p(:,i),H);
    if(p_tmp(1)>0 && p_tmp(1)<width && p_tmp(2)>0 && p_tmp(2)<height)
        p_compare=p_corr(:,i);
        dis=sqrt((p_tmp(1)-p_compare(1))^2+(p_tmp(2)-p_compare(2))^2);
        if(dis<=2)
            pair=pair+1;
        end
    end
end

repeatability_rate=pair/pair_num
