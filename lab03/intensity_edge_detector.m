function [edge_img] = intensity_edge_detector(image,threshold)
thresh=threshold;
imgorg=image;
img=rgb2gray(imgorg);
H=fspecial('gaussian',3,1);
imgGauss=conv2(img,H,"same");
[dy,dx]=gradient(imgGauss);
M=sqrt(dx.^2+dy.^2);
[Lenx,Leny]=size(imgGauss);

partition_ref=[-7,-6,-5,-4,-3,-2,-1,0,1,2,3,4,5,6,7,8];%indicate the direction
ref_x=[-1,-1,-1,0,0,1,1,1,1,1,0,0,-1,-1,-1,-1];
ref_y=[0,-1,-1,-1,-1,-1,-1,0,1,1,1,1,1,1,0,0];

for (i=1:Lenx)
    for(j=1:Leny)
        degree(i,j,1)= rad2deg(atan2(dy(i,j),dx(i,j)));
        tmp_result=fix(degree(i,j)/22.5);
        degree(i,j,2)=partition_ref(find(tmp_result==partition_ref));
        degree(i,j,3)=find(tmp_result==partition_ref);
    end
end
M_extend=padarray(M, [1,1]);
for i=(1:Lenx)
    for j=(1:Leny)
        val_q=M_extend(i+1+ref_x(degree(i,j,3)),j+1+ref_y(degree(i,j,3)));
        val_opp_q=M_extend(i+1-ref_x(degree(i,j,3)),j+1-ref_y(degree(i,j,3)));
        if(M_extend(i+1,j+1)<val_opp_q && M_extend(i+1,j+1)<val_q)
            M(i,j)=0;
        end
    end
end
% outputfileedge=strcat('Intensity_Edge_bds',num2str(filenum),'.jpg');
% imwrite(uint8(M),outputfileedge);
% figure;
% imshow(uint8(M));

% max=max(M(:,:));
for i=(1:Lenx)
    for j=(1:Leny)
        if(M(i,j)<thresh)
            M(i,j)=0;
        end
    end
end
edge_img=M;
% threshed=strcat('Intensity_Edge_threshed_bds',num2str(filenum),'thresh_',num2str(thresh),'.jpg');
% imwrite(M,threshed);
% % BW = im2bw(M, 0.999999);
% figure;
% imshow(M);



