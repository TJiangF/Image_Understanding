name = ('bds');
filenum = 3;
path = strcat(name,num2str(filenum));
path=strcat(path,'.jpg');
img=imread(path);
imggray=rgb2gray(img);
imggray=im2double(imggray);

window_size=20;
sigma_odd1=sqrt(2).^(1:3);
sigma_odd2=3*sqrt(2).^(1:3);
theta=linspace(0,pi,6);


ParaSum(:)=0;
% Odd_filters=zeros()
for(n=1:6)
    for(Mag=1:3)
        for(i=1:window_size)
            for(j=1:window_size)
                    x_addon=exp((-i*i)/(2*(sigma_odd2(Mag)^2)));
                    y_addon=exp((-j*j)/(2*(sigma_odd1(Mag)^2)));

                    G3_tmp=(1/((sqrt(2*pi)*sigma_odd1(Mag)^5)))*j^2*exp((-j*j)/(2*(sigma_odd1(Mag)^2)));
                    G2_tmp=(-1/(sqrt(2*pi)*sigma_odd1(Mag)^3))*j*exp((-j*j)/(2*(sigma_odd1(Mag)^2)));
                    G1_tmp=(1/(sqrt(2*pi)*sigma_odd2(Mag)))*exp((-i*i)/(2*(sigma_odd2(Mag)^2)));
%                     H(Mag,i,j)=(-1/(6*sigma_odd1(Mag)^4*pi))*j*exp(-((i^2+j^2)/(2*sigma_odd1(Mag)^2)));
                    H(i,j,Mag)=G2_tmp*G1_tmp;
                    E(i,j,Mag)=G3_tmp*G1_tmp;
            end
        end
        Odd_filters(:,:,Mag+3*(n-1))=imrotate(H(:,:,Mag),-rad2deg(theta(n)),'bilinear','crop');
        

%         figure;
        
        Even_filters(:,:,Mag+3*(n-1))=imrotate(E(:,:,Mag),-rad2deg(theta(n)),'bilinear','crop');
    end
end
% 
% figure;
% imagesc(Odd_filters(:,:,2));


%     for(i=1:window_size)
%         for(j=1:window_size)
%             H(i,j)=H(i,j)/ParaSum;
%         end
%     end



sigma_log1=sqrt(2).^(1:4);
sigma_log2=3*sqrt(2).^(1:4);
for(i=1:4)
    Log_filters(:,:,i)=fspecial('log',window_size,sigma_log1(i));
    Log_filters(:,:,i+4)=fspecial('log',window_size,sigma_log2(i));
end
sigma_gauss=sqrt(2).^(1:4);
for(i=1:4)
    Gauss_filters(:,:,i)=fspecial('gaussian',window_size,sigma_gauss(i));
end

for(i=1:18)
    img_odd(:,:,i)=imfilter(imggray,Odd_filters(:,:,i));
    img_even(:,:,i)=imfilter(imggray,Even_filters(:,:,i));
end
for(i=1:8)
    img_log(:,:,i)=imfilter(imggray,Log_filters(:,:,i));
end
for(i=1:4)
    img_gauss(:,:,i)=imfilter(imggray,Gauss_filters(:,:,i));
end
for(i=1:48)
    if(i<=18)
        img3d(:,:,i)=img_odd(:,:,i);
    end
    if(i>18&&i<=36)
        img3d(:,:,i)=img_even(:,:,i-18);
    end
    if(i>36&&i<=44)
        img3d(:,:,i)=img_log(:,:,i-36);
    end
    if(i>44&&i<=48)
        img3d(:,:,i)=img_gauss(:,:,i-44);
    end
end

for(i=1:48)
    r=3;
    [edge_map(:,:,i),orient_map(:,:,i)]=hist_edge_detector(img3d(:,:,i),r,8,16);
    processing=i
    theta_v(:,:,i)=orient_map(:,:,i);
    [dy,dx]=gradient(theta_v(:,:,i));
    Mag(1:321,1:481,i)=sqrt(dx.^2+dy.^2);
end
[Lenx,Leny]=size(theta_v(:,:,1));
for(i=1:Lenx)
    for(j=1:Leny)
        [max_num,max_index]=max(Mag(i,j,:));
        max_strength_map(i,j)=max_num;
        angle_map(i,j)=orient_map(i,j,max_index);
    end
end

[dy,dx]=gradient(orient_map);
Mag=sqrt(dx.^2+dy.^2);

partition_ref=[-8,-7,-6,-5,-4,-3,-2,-1,0,1,2,3,4,5,6,7,8];%indicate the direction
ref_x=[-1,-1,-1,-1,0,0,1,1,1,1,1,0,0,-1,-1,-1,-1];
ref_y=[0,0,-1,-1,-1,-1,-1,-1,0,1,1,1,1,1,1,0,0];
for (i=1:Lenx)
    for(j=1:Leny)
        degree(i,j,1)= rad2deg(atan2(dy(i,j),dx(i,j)));
        tmp_result=fix(degree(i,j,1)/22.5);
        degree(i,j,2)=partition_ref(find(tmp_result==partition_ref));
        degree(i,j,3)=find(tmp_result==partition_ref);
    end
end
Mag_extend=padarray(Mag, [1,1]);
for i=(1:Lenx)
    for j=(1:Leny)
        val_q=Mag_extend(i+1+ref_x(degree(i,j,3)),j+1+ref_y(degree(i,j,3)));
        val_opp_q=Mag_extend(i+1-ref_x(degree(i,j,3)),j+1-ref_y(degree(i,j,3)));
        if(Mag_extend(i+1,j+1)<val_opp_q && Mag_extend(i+1,j+1)<val_q)
            Mag(i,j)=0;
        end
    end
end
thresh=0.5;
for i=(1:Lenx)
    for j=(1:Leny)
        if(Mag(i,j)<thresh)
            MagB(i,j)=0;
        else 
            MagB(i,j)=1;
        end
    end
end  
% 
threshed=strcat('Texture_based_edges',num2str(filenum),'thresh_',num2str(thresh),'.jpg');
imwrite(MagB,threshed);
% % BW = im2bw(M, 0.999999);
figure;
imshow(MagB);


