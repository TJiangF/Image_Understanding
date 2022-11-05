clear;
filepath="data/Question2/";
intrinsics=load(strcat(filepath,"intrinsicMatrix.mat"));
img1=imread(strcat(filepath,'1.png'));
img2=imread(strcat(filepath,'2.png'));
img1=single(im2gray(img1));
img2=single(im2gray(img2));
[height,width]=size(img1);

peakthresh=8;
edge_thresh=5;

[f1, d1] = vl_sift(img1,'PeakThresh', peakthresh,'edgethresh', edge_thresh); 
[f2, d2] = vl_sift(img2,'PeakThresh', peakthresh,'edgethresh', edge_thresh);  

[matches, scores] = vl_ubcmatch(d1, d2);
[dump,scoreindex]=sort(scores,'ascend');

% pick_ratio=0.3;
% pair_num=fix(size(matches,2)*pick_ratio);
% for i= 1:pair_num
% %     idx = scoreind(i);
%     matches1(i,:)=[f1(1,matches(1,scoreind(i))) f1(2,matches(1,scoreind(i))) 1];
%     matches2(i,:)=[f2(1,matches(2,scoreind(i))) f2(2,matches(2,scoreind(i))) 1];
% end

lowesratio=0.5;
pair_num=fix(lowesratio*size(matches,2));

for i= (1:pair_num)  
    idx = scoreindex(i);
    p(:,i)=[f1(1,matches(1,idx)); f1(2,matches(1,idx))];
    p_corr(:,i)=[f2(1,matches(2,idx)); f2(2,matches(2,idx))];
end

picknum=4;
for i=(1:1000)
    randompick(:)=ceil(pair_num*rand(1,picknum));
    for m=(1:picknum)
%         randompick(m)
        matches1(:,m)=p(:,randompick(m));
        matches2(:,m)=p_corr(:,randompick(m));
    end

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
    end
end
inlier_count=0;
for k= (1:pair_num)  
    p_tmp=homography_transform(p(:,k),H);
    if(p_tmp(1)>0 && p_tmp(1)<=width && p_tmp(2)>0 && p_tmp(2)<=height)
        p_compare=p_corr(:,k);
        dis=sqrt((p_tmp(1)-p_compare(1))^2+(p_tmp(2)-p_compare(2))^2);
        if(dis<=1)
            inlier_count=inlier_count+1;
            inlier(1:3,inlier_count)=[p(:,k);1];
            inlier_hat(1:3,inlier_count)=[p_compare;1];
        end
    end
end

randompickcorr(:)=randperm(size(inlier,2),5);
matchesInMeters = ones(5, 3, 2);
for i=(1:5)
    matchesInMeters(i,:,1)=inlier(:,randompickcorr(i));
    matchesInMeters(i,:,2)=inlier_hat(:,randompickcorr(i));
end
Es = fivePointAlgorithmSelf(matchesInMeters);

possibleES=size(Es,3);
for i=(1:possibleES)
    PossibleMatrix(:,:,i)=Es{1,1,i}(:,:);
end


Atmp(:,:)=PossibleMatrix(1,1,:).*matchesInMeters(:,1,1)+PossibleMatrix(1,2,:).*matchesInMeters(:,2,1)+PossibleMatrix(1,3,:);
Btmp(:,:)=PossibleMatrix(2,1,:).*matchesInMeters(:,1,1)+PossibleMatrix(2,2,:).*matchesInMeters(:,2,1)+PossibleMatrix(2,3,:);
Ctmp(:,:)=PossibleMatrix(3,1,:).*matchesInMeters(:,1,1)+PossibleMatrix(3,2,:).*matchesInMeters(:,2,1)+PossibleMatrix(3,3,:);

slope=-Atmp./Btmp;
cut=-Ctmp./Btmp;


[~, cols1] = size(img1);

figure, img3 = [img1, img2];  

colormap('gray');
imagesc(img3);

hold on;
x=1:1:640;
for i = 1 : 5
    plot(matchesInMeters(i,1,2)+640,matchesInMeters(i,2,2),'bo','MarkerSize',6,'MarkerFaceColor','b');
    plot(matchesInMeters(i,1,1),matchesInMeters(i,2,1),'go','MarkerSize',6,'MarkerFaceColor','g');
    for j=1:possibleES
        ytmp=slope(i,j)*x+cut(i,j);
        y=ytmp(find(ytmp>=1));
        xtmp=x(find(ytmp>=1));
        y=y(find(y<=480));
        xtmp=xtmp(find(y<=480));
        plot(xtmp+640,y,'r');
    end
end
axis image
hold off;
set(gcf,'color','w');
T=clock;

name=strcat('ES_',num2str(T(4)),'_',num2str(T(5)),'_',num2str(T(6)),'.jpg');
saveas(gcf, name);


