%% corners coordinates
clear;
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
GTH=load(pathH);
img1=imread(path1);
img2=imread(path2);
img1=im2gray(img1);
img2=im2gray(img2);
[corners1,c_cood1]=corner_detector_cood(img1);
[corners2,c_cood2]=corner_detector_cood(img2);
% 
%% display corners coordinates
% figure;
% [H,W,Depth]=size(img1);
% imshow(img1),hold on,
% % for i=1:H
% %     for j=1:W
% %         if (corners1(i,j)~=0)
% %             plot(j,i,'r+')
% %         end
% %     end
% % end
% for i=(1:size(c_cood1,2))
%     plot(c_cood1(2,i),c_cood1(1,i),'r+')
% end
% hold off;     
%% region descriptors

des_type1="pixels";
des_type2="histogram";
window=7;
D1=region_descriptors(img1,c_cood1,window,des_type1);
D2=region_descriptors(img2,c_cood2,window,des_type1);


% D1=region_descriptors(img1,c_cood1,window,des_type2);
% D2=region_descriptors(img2,c_cood2,window,des_type2);

%% find matches
shownum=10;
bins=size(D1,1);
test_ratio=0.2;
ncc_ratio=0.95;

[inx_1st,inx_2nd,simi_1st,simi_2nd]=find_matches(D1,D2,"SSD");
% [inx_1st,inx_2nd,simi_1st,simi_2nd]=find_matches(D1,D2,"Chi-Square");



inx_tool=inx_1st;
inx_tool(find(simi_1st(:)<=(test_ratio*simi_2nd(:))))=1;
inx_tool(find(simi_1st(:)>(test_ratio*simi_2nd(:))))=10000000;
simi_matched(:)=simi_1st.*inx_tool;
[simi_intensity,Index_match]=sort(simi_matched(:),'ascend');
simi_matched((find(simi_matched(:)<100000)))=1;
simi_matched((find(simi_matched(:)>=100000)))=0;
pair_num=sum(simi_matched);

for i= (1:pair_num)  
    pre_p(:,i)=[c_cood1(2,Index_match(i)); c_cood1(1,Index_match(i));simi_intensity(i)];
    pre_p_corr(:,i)=[c_cood2(2,inx_1st(Index_match(i)));c_cood2(1,inx_1st(Index_match(i)));simi_intensity(i)];
end
for i= (1:pair_num)  
    p_tmp=pre_p(1:2,i);
    p_corr_tmp=pre_p_corr(1:2,i);
    simi_min=pre_p(3,i);
    for j= (1:pair_num)  
        if(p_corr_tmp==pre_p_corr(1:2,j))
            if(pre_p_corr(3,j)<=simi_min)
                simi_min=pre_p_corr(3,j);
                min_indx=j;
            end
        end
    end
    p2(:,i)=pre_p(1:2,min_indx);
    p_corr2(:,i)=pre_p_corr(1:2,min_indx);
end

%% NCC

% [inx_1st,inx_2nd,simi_1st,simi_2nd]=find_matches(D1,D2,"NCC");
% 
% inx_tool=inx_1st;
% inx_tool(find((simi_1st(:)*ncc_ratio)>simi_2nd(:)))=1;
% inx_tool(find((simi_1st(:)*ncc_ratio)<=simi_2nd(:)))=0;
% simi_matched(:)=simi_1st.*inx_tool;
% [simi_intensity,Index_match]=sort(simi_matched(:),'descend');
% 
% pair_num=sum(inx_tool);%41
% for i= (1:pair_num)  
%     pre_p(:,i)=[c_cood1(2,Index_match(i)); c_cood1(1,Index_match(i));simi_intensity(i)];
%     pre_p_corr(:,i)=[c_cood2(2,inx_1st(Index_match(i)));c_cood2(1,inx_1st(Index_match(i)));simi_intensity(i)];
% end
% for i= (1:pair_num)  
%     p_tmp=pre_p(1:2,i);
%     p_corr_tmp=pre_p_corr(1:2,i);
%     simi_max=pre_p(3,i);
%     for j= (1:pair_num)  
%         if(p_corr_tmp==pre_p_corr(1:2,j))
%             if(pre_p_corr(3,j)>=simi_max)
%                 simi_max=pre_p_corr(3,j);
%                 max_indx=j;
%             end
%         end
%     end
%     p2(:,i)=pre_p(1:2,max_indx);
%     p_corr2(:,i)=pre_p_corr(1:2,max_indx);
% end


%% matches accuracy
pair=0;
% figure;
% tform = projective2d(GTH');
% img1_project = imwarp(img1,tform);
% imshow(uint8(img1_project));




p(:,1)=p2(:,1);
p_corr(:,1)=p_corr2(:,1);
k=1;
for i= (2:pair_num) 
    flag=0;
    for j=(1:size(p,2))
        if(p2(:,i)==p(:,j))
            flag=1;
        end
    end
    if(flag==0)
        k=k+1;
        p(:,k)=p2(:,i);
        p_corr(:,k)=p_corr2(:,i);
    end
end
pair_num=size(p,2);
for i= (1:pair_num) 
%     if(p(1,i)==79)
%         p(:,i)
%     end
    p_tmp=homography_transform(p(:,i),GTH);
%     p_tmp=[p(1,i) p(2,i) 1]*GTH;
    p_compare=p_corr(:,i);
    dis=sqrt((p_tmp(1)-p_compare(1))^2+(p_tmp(2)-p_compare(2))^2);  
    if(dis<=2)
        pair=pair+1;
    end
end

repeatability_rate=pair/pair_num
