clear;
filepath="data/";
img1_raw=imread(strcat(filepath,"1.jpg"));
img1=img1_raw;
img2=imread(strcat(filepath,"2.jpg"));
intrinsics=load(strcat(filepath,"cameraIntrinsicMatrix.mat"));
Intri_mat=intrinsics.K;
%% resize

img1=imresize(img1, 0.25,'bicubic');
img2=imresize(img2, 0.25,'bicubic');
%% sift feature extraction
img1_color=img1;
img2_color=img2;

img1=single(im2gray(img1));
img2=single(im2gray(img2));
[height,width]=size(img1);

peakthresh=8;
edge_thresh=8;

[f1, d1] = vl_sift(img1,'PeakThresh', peakthresh,'edgethresh', edge_thresh); 
[f2, d2] = vl_sift(img2,'PeakThresh', peakthresh,'edgethresh', edge_thresh);  

[matches, scores] = vl_ubcmatch(d1, d2);
[dump,scoreindex]=sort(scores,'ascend');
%% RANSAC
lowesratio=1;
pair_num=fix(lowesratio*size(matches,2));

for i= (1:pair_num)  
    idx = scoreindex(i);
    p(:,i)=[f1(1,matches(1,idx)); f1(2,matches(1,idx))];
    p_corr(:,i)=[f2(1,matches(2,idx)); f2(2,matches(2,idx))];
end
[E,inlierIndx]=Ransac4Essential(p,p_corr,Intri_mat);%E is in meters
%%
% plotnum=5;
% for i=(1:plotnum)
%     matchesInMeters(i,:,1) = [p(:,inlierIndx(i));1];
%     matchesInMeters(i,:,2) = [p_corr(:,inlierIndx(i));1];
% end
% Ep=transpose(inv(Intri_mat))*E*inv(Intri_mat);
% Atmp(:)=Ep(1,1).*matchesInMeters(:,1,1)+Ep(1,2).*matchesInMeters(:,2,1)+Ep(1,3);
% Btmp(:)=Ep(2,1).*matchesInMeters(:,1,1)+Ep(2,2).*matchesInMeters(:,2,1)+Ep(2,3);
% Ctmp(:)=Ep(3,1).*matchesInMeters(:,1,1)+Ep(3,2).*matchesInMeters(:,2,1)+Ep(3,3);
% 
% slope=-Atmp./Btmp;
% cut=-Ctmp./Btmp;
% [~, cols1] = size(img1);
% 
% figure, img3 = [img1, img2];  
% 
% colormap('gray');
% imagesc(img3);
% 
% hold on;
% x=1:1:768;
% for i = 1 : plotnum
%     plot(matchesInMeters(i,1,2)+768,matchesInMeters(i,2,2),'bo','MarkerSize',6,'MarkerFaceColor','b');
%     plot(matchesInMeters(i,1,1),matchesInMeters(i,2,1),'go','MarkerSize',6,'MarkerFaceColor','g');
%         ytmp=slope(i)*x+cut(i);
%         y=ytmp(find(ytmp>=1));
%         xtmp=x(find(ytmp>=1));
%         y=y(find(y<=512));
%         xtmp=xtmp(find(y<=512));
%         plot(xtmp+768,y,'r');
% end
% axis image
% hold off;
% set(gcf,'color','w');
% T=clock;
% 
% name=strcat('ES_',num2str(T(4)),'_',num2str(T(5)),'_',num2str(T(6)),'.jpg');

plotnum=5;
for i=(1:plotnum)
    matchesInPixel(i,:,1) = [p(:,inlierIndx(i));1];
    matchesInPixel(i,:,2) = [p_corr(:,inlierIndx(i));1];
end
Ep=transpose(inv(Intri_mat))*E*inv(Intri_mat);
Atmp(:)=Ep(1,1).*matchesInPixel(:,1,1)+Ep(1,2).*matchesInPixel(:,2,1)+Ep(1,3);
Btmp(:)=Ep(2,1).*matchesInPixel(:,1,1)+Ep(2,2).*matchesInPixel(:,2,1)+Ep(2,3);
Ctmp(:)=Ep(3,1).*matchesInPixel(:,1,1)+Ep(3,2).*matchesInPixel(:,2,1)+Ep(3,3);

slope=-Atmp./Btmp;
cut=-Ctmp./Btmp;
[~, cols1] = size(img1);

figure, img3 = [img1, img2];  

colormap('gray');
imagesc(img3);

hold on;
x=1:1:768;
for i = 1 : plotnum
    plot(matchesInPixel(i,1,2)+768,matchesInPixel(i,2,2),'bo','MarkerSize',6,'MarkerFaceColor','b');
    plot(matchesInPixel(i,1,1),matchesInPixel(i,2,1),'go','MarkerSize',6,'MarkerFaceColor','g');
        ytmp=slope(i)*x+cut(i);
        y=ytmp(find(ytmp>=1));
        xtmp=x(find(ytmp>=1));
        y=y(find(y<=512));
        xtmp=xtmp(find(y<=512));
        plot(xtmp+768,y,'r');
end
axis image
hold off;
set(gcf,'color','w');
T=clock;

name=strcat('ES_',num2str(T(4)),'_',num2str(T(5)),'_',num2str(T(6)),'.jpg');
saveas(gcf, name);
%% 
[denseMatchImg1, denseMatchImg2, denseInlierIndx] = Densification(E, Intri_mat, p, p_corr, inlierIndx, img1_raw);
[U,S,V]=svd(E);
W=[0 -1 0;1 0 0 ;0 0 1];
R(:,:,1)=U*W*transpose(V);
R(:,:,2)=U*transpose(W)*transpose(V);
T1=U(:,end);
T2=-U(:,end);
gammatmp=inv(Intri_mat)*denseMatchImg1(:,10);%pixel->meter
gammahattmp=inv(Intri_mat)*denseMatchImg2(:,10);
for i=(1:2)
    for j=(1:2)
        if(j==1)
            Ttmp=T1;
        else
            Ttmp=T2;
        end
        tmp1=[-R(:,:,i)*gammatmp,gammahattmp];
        tmp1_inv=pinv(tmp1);
        rho_matrix=tmp1_inv*Ttmp;
        if(rho_matrix(:)>0)
            R_valid=R(:,:,i);
            T_valid=Ttmp;
            
        end
    end
end

num_dense_matches=size(denseInlierIndx,2);
for i=(1:num_dense_matches)
    matchtmp=inv(Intri_mat)*denseMatchImg1(:,denseInlierIndx(i));
    matchhattmp=inv(Intri_mat)*denseMatchImg2(:,denseInlierIndx(i));
    rho=pinv([-R_valid*matchtmp,matchhattmp])*T_valid;
    Gamma=rho(1)*matchtmp;
    Gammahat=rho(2)*matchhattmp;
    avgGamma(:,i)=(Gamma+Gammahat)./2;
%     transpose(denseMatchImg1(1:2,i))
    matchcolor1(1:3)=double(img1_color(denseMatchImg1(2,denseInlierIndx(i)),denseMatchImg1(1,denseInlierIndx(i)),:));
    matchcolor2(1:3)=double(img2_color(denseMatchImg2(2,denseInlierIndx(i)),denseMatchImg2(1,denseInlierIndx(i)),:));
    Gammacolor(:,i)=(matchcolor1(:)+matchcolor2(:))./2;
end

px=avgGamma(1,:);
py=avgGamma(2,:);
pz=avgGamma(3,:);
% pr=double(Gammacolor(1,:))./255;
% pg=double(Gammacolor(2,:))./255;
% pb=double(Gammacolor(3,:))./255;
% scatter3(px,py,pz,2,[pr,pg,pb]);
% black=zeros(158471,3);
scatter3(px,py,pz,2,transpose(Gammacolor(1:3,:)./255));
% plot3(px,py,pz,'r');










