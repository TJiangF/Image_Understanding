%% corners coordinates

path1='images/planar_rotation_change/img1.png';
path2='images/planar_rotation_change/img2.png';
pathH='images/planar_rotation_change/H_1to2.txt';
path1='images/scale_rotation_change/img1.png';
path2='images/scale_rotation_change/img2.png';
pathH='images/scale_rotation_change/H_1to2.txt';
path1='images/illumination_change/img1.png';
path2='images/illumination_change/img2.png';
pathH='images/illumination_change/H_1to2.txt';
% path1='images/view_change/img1.png';
% path2='images/view_change/img2.png';
% pathH='images/view_change/H_1to2.txt';
GTH=load(pathH);
img1=imread(path1);
img2=imread(path2);
img1=im2gray(img1);
img2=im2gray(img2);
[height,width]=size(img1);
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
test_ratio=0.5;
ncc_ratio=0.99;
maxdis=height*width;

% 
simi_type="SSD";
% simi_type="Chi-Square";
[finx_1st,finx_2nd,fsimi_1st,fsimi_2nd]=find_matches(D1,D2,simi_type);
[binx_1st,binx_2nd,bsimi_1st,bsimi_2nd]=find_matches(D2,D1,simi_type);


finx_tool=finx_1st;
finx_tool(find(fsimi_1st(:)<=(test_ratio*fsimi_2nd(:))))=1;
finx_tool(find(fsimi_1st(:)>(test_ratio*fsimi_2nd(:))))=(maxdis*10);
fsimi_matched(:)=fsimi_1st.*finx_tool;
[fsimi_intensity,fIndex_match]=sort(fsimi_matched(:),'ascend');


fsimi_matched(find(fsimi_matched(:)<maxdis))=1;
fsimi_matched((find(fsimi_matched(:)>=maxdis)))=0;
fpair_num=min(size(c_cood2,2),sum(fsimi_matched));

binx_tool=binx_1st;
binx_tool(find(bsimi_1st(:)<=(test_ratio*bsimi_2nd(:))))=1;
binx_tool(find(bsimi_1st(:)>(test_ratio*bsimi_2nd(:))))=(maxdis*10);
bsimi_matched(:)=bsimi_1st.*binx_tool;
[bsimi_intensity,bIndex_match]=sort(bsimi_matched(:),'ascend');
bsimi_matched(find(bsimi_matched(:)<maxdis))=1;
bsimi_matched((find(bsimi_matched(:)>=maxdis)))=0;
bpair_num=min(size(c_cood1,2),sum(bsimi_matched));



% simi_type="NCC";
% [finx_1st,finx_2nd,fsimi_1st,fsimi_2nd]=find_matches(D1,D2,simi_type);
% [binx_1st,binx_2nd,bsimi_1st,bsimi_2nd]=find_matches(D2,D1,simi_type);
% 
% finx_tool=finx_1st;
% finx_tool(find((fsimi_1st(:)*ncc_ratio)>fsimi_2nd(:)))=1;
% finx_tool(find((fsimi_1st(:)*ncc_ratio)<=fsimi_2nd(:)))=0;
% fsimi_matched(:)=fsimi_1st.*finx_tool;
% [fsimi_intensity,fIndex_match]=sort(fsimi_matched(:),'descend');
% fpair_num=min(size(c_cood2,2),sum(finx_tool));
% 
% binx_tool=binx_1st;
% binx_tool(find((bsimi_1st(:)*ncc_ratio)>bsimi_2nd(:)))=1;
% binx_tool(find((bsimi_1st(:)*ncc_ratio)<=bsimi_2nd(:)))=0;
% bsimi_matched(:)=bsimi_1st.*binx_tool;
% [bsimi_intensity,bIndex_match]=sort(bsimi_matched(:),'descend');
% bpair_num=min(size(c_cood1,2),sum(binx_tool));


%% matches accuracy
pair=0;
total_pair=0;
% figure;
% tform = projective2d(GTH');
% img1_project = imwarp(img1,tform);
% imshow(uint8(img1_project));



% [dump,scoreindex]=sort(scores,'ascend');
for i= (1:fpair_num) 
    fp_tmp=[c_cood1(2,fIndex_match(i)); c_cood1(1,fIndex_match(i))];
    fp_corr_tmp=[c_cood2(2,finx_1st(fIndex_match(i)));c_cood2(1,finx_1st(fIndex_match(i)))];
    for j=(1:bpair_num)
        bp_tmp=[c_cood2(2,bIndex_match(j)); c_cood2(1,bIndex_match(j))];
        
        bp_corr_tmp=[c_cood1(2,binx_1st(bIndex_match(j)));c_cood1(1,binx_1st(bIndex_match(j)))];
        if(bp_tmp==fp_corr_tmp)
            if(bp_corr_tmp==fp_tmp)
                total_pair=total_pair+1;
                p(:,total_pair)=fp_tmp;
                p_corr(:,total_pair)=fp_corr_tmp;
            end
        end
    end
end

for i= (1:total_pair) 
    p_tmp=homography_transform(p(:,i),GTH);
    p_compare=p_corr(:,i);
    dis=sqrt((p_tmp(1)-p_compare(1))^2+(p_tmp(2)-p_compare(2))^2);  
    if(dis<=2)
        pair=pair+1;
    end
end

repeatability_rate=pair/total_pair


 





