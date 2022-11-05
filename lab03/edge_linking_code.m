name = ('bds');
filenum = 6;
path = strcat(name,num2str(filenum));
path=strcat(path,'.jpg');
img=imread(path);
th=30;
tl=10;
Ih=intensity_edge_detector(img,th);
Il=intensity_edge_detector(img,tl);

[dy,dx]=gradient(Ih);%gradient direction
M=sqrt(dx.^2+dy.^2);

[Lenx,Leny]=size(Ih);
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
M_extend=padarray(M, [1,1]);

for i=(1:Lenx)
    for j=(1:Leny)
        val_pixel=M_extend(i+1,j+1);
        while(val_pixel>tl && val_pixel<th && Ih(i,j)<256)
           Ih(i,j)=Ih(i,j)+val_pixel;
           val_pixel=M_extend(i+1+ref_x(degree(i,j,3)),j+1+ref_y(degree(i,j,3)));
        end
    end
%     if(mod(i,25)==0)
%         i
%     end
end
Ih=im2bw(Ih,0.15);
imshow(Ih);
Ih_B_name=strcat('Edge_Linking_bds',num2str(filenum),'_th_tl_',num2str(th),'_',num2str(tl),'_.jpg');
imwrite(Ih,Ih_B_name);