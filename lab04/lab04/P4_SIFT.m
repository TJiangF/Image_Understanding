foldername='problem_3_and_4/set';
filenum1 = 1;
filenum2 = 2;
foldernum= 1;
path4H= strcat(foldername,num2str(foldernum),'/H_1to2.txt');
path1 = strcat(foldername,num2str(foldernum),'/','img',num2str(filenum1),'.png');
path2 = strcat(foldername,num2str(foldernum),'/','img',num2str(filenum2),'.png');
img1org=imread(path1);
img2org=imread(path2);
H=load(path4H);
img1=single(im2gray(img1org));
img2=single(im2gray(img2org));

peakthresh=2;
edge_thresh=10;

[f1, d1] = vl_sift(img1,'PeakThresh', peakthresh,'edgethresh', edge_thresh); 
[f2, d2] = vl_sift(img2,'PeakThresh', peakthresh,'edgethresh', edge_thresh);  

[matches, scores] = vl_ubcmatch(d1, d2);
[dump,scoreindex]=sort(scores,'ascend');

pickrate=1;
pair_num=fix(pickrate*size(matches,2));
% pair_num=3;

for i= (1:pair_num)  
    idx = scoreindex(i);
    p(:,i)=[f1(1,matches(1,idx)); f1(2,matches(1,idx))];
    p_corr(:,i)=[f2(1,matches(2,idx)); f2(2,matches(2,idx))];
end

% for i= (1:3)  
%     idx = scoreindex(i);
%     p(i,:)=[f1(1,matches(1,idx)) f1(2,matches(1,idx)) 1];
%     p_corr(i,:)=[f2(1,matches(2,idx)) f2(2,matches(2,idx)) 1];
% end
% p
% p_corr
% H=p_corr*p^(-1)
% test=H*p

%% tried to get H by SIFT, but turned out to be unnecessary in this lab
%
% H=get_homography(p,p_corr);

% tform = projective2d(H');
% img1_project = imwarp(img1,tform);
% imshow(uint8(img1_project));

% idx = scoreindex(1);
% indicator=[f1(1,matches(1,idx)); f1(2,matches(1,idx))];
% p_tmp=homography_transform(p(:,i),H)


% [f3, d3] = vl_sift(img1_project,'PeakThresh', peakthresh,'edgethresh', edge_thresh); 
% [matches2, scores2] = vl_ubcmatch(d2, d3);
% [dump2,scoreindex2]=sort(scores2,'ascend');

% for i= (1:pair_num)  
%     idx = scoreindex(i);
%     p(:,i)=[f1(1,matches(1,idx)); f1(2,matches(1,idx))];
%     p_corr(:,i)=[f2(1,matches(2,idx)); f2(2,matches(2,idx))];
% end



% imwrite(uint8(img1_project),'img1_project.jpg');

%% Eucildean distance calculation
figure;
imshow(uint8(img2org)); 
axis image
hold on


[height,width]=size(img2);
pair=0;
for i= (1:pair_num)  
    idx = scoreindex(i);
    p_tmp=homography_transform(p(:,i),H);
    if(p_tmp(1)>0 && p_tmp(1)<width && p_tmp(2)>0 && p_tmp(2)<height)
        p_compare=[f2(1,matches(2,1)); f2(2,matches(2,1))];
        dismin=sqrt((p_tmp(1)-p_compare(1))^2+(p_tmp(2)-p_compare(2))^2);
        minindex=1;
        for(j=2:size(matches,2))
            idx=scoreindex(j);
            p_compare=[f2(1,matches(2,idx)); f2(2,matches(2,idx))];
            dis=sqrt((p_tmp(1)-p_compare(1))^2+(p_tmp(2)-p_compare(2))^2);
            if(dis<dismin)
                minindex=j;
                dismin=dis;
            end
        end
        if(dismin<=2)
            plot(p_tmp(1),p_tmp(2),"wo",'LineWidth',3,'MarkerSize',5);
            pair=pair+1;
        end
    end
end
hold off
repeatability_rate=pair/pair_num



%% corners


corners1=corner_detector(img1org);
corners2=corner_detector(img2org);

% [matches2, scores2] = vl_ubcmatch(corners1,corners2);
% [dump2,scoreindex2]=sort(scores2,'ascend');

%% show the corners in two pics and the relationship (not needed)

% newfig=zeros(size(corners1,1), size(corners1,2)+size(corners2,2)); 
% newfig(:,1:size(corners1,2)) = corners1;
% newfig(1:size(corners2,1) ,(size(corners1,2)+1):end)=corners2;
% newfig=uint8(newfig);
% figure;
% imshow(uint8(newfig)); 
% axis image
% f4Moved=f4;  % move in y direction by f2 
% f4Moved(1,:) = f4Moved(1,:)+size(corners1,2);
% h3 = vl_plotframe(f3); 
% h4 = vl_plotframe(f4Moved);
% set(h3,'color','g','linewidth',2) ;
% set(h4,'color','r','linewidth',2);
% hold on
% % plot only top 15%
% plotRatio=0.15;
% for i= 1:fix(plotRatio*size(matches2,2))  
%     idx = scoreindex2(i);
%     line([f3(1,matches2(1,idx)) f4Moved(1,matches2(2,idx))],[f3(2,matches2(1,idx)) f4Moved(2,matches2(2,idx))], 'linewidth',1, 'color','b')
% end
% hold off
%% 
% pickrate2=1;
% pair_num2=fix(pickrate2*size(matches2,2));
% % pair_num=3;
% for i= (1:pair_num2)  
%     idx = scoreindex2(i);
%     pc(:,i)=[f3(1,matches2(1,idx)); f3(2,matches2(1,idx))];
%     pc_corr(:,i)=[f4(1,matches2(2,idx)); f4(2,matches2(2,idx))];
% end
figure;
imshow(uint8(img2org)); 
axis image
hold on


corners1(find(corners1(:,:)~=0))=1;
corners2(find(corners2(:,:)~=0))=1;
c1_pair_num=sum(sum(corners1(:,:)));
c2_pair_num=sum(sum(corners2(:,:)));
pair=0;
[height,width]=size(corners1);
pair_num=0;
for i=(1:height)
    for j=(1:width)
        if(corners1(i,j)==1)
            point=[i;j];
            p_tmp=homography_transform(point,H);
            if(p_tmp(1)>0 && p_tmp(1)<width && p_tmp(2)>0 && p_tmp(2)<height)
                pair_num=pair_num+1;
                dismin=100;
                for m=(1:height)
                    for n=(1:width)
                        if(corners2(m,n)==1)
                            p_compare=[m;n];
                            dis=sqrt((p_tmp(1)-p_compare(1))^2+(p_tmp(1)-p_compare(1))^2);
                            if(dis<dismin)
                                dismin=dis;
                            end
                        end
                    end
                end
                if(dismin<=2)
                    pair=pair+1;
                    plot(p_tmp(2),p_tmp(1),"wo",'LineWidth',3,'MarkerSize',5);
                end
            end
        end
    end
end
hold off

repeatability_rate2=pair/c1_pair_num




