clear;
se = offsetstrel('ball',2,2);
filepath="data/Question1/";
House=load(strcat(filepath,"scenePointCloud.mat"));
Camera=load(strcat(filepath,"cameraPoses.mat"));
R1=Camera.R1;
R2=Camera.R2;
T1=Camera.T1;
T2=Camera.T2;
intrinsics=load(strcat(filepath,"cameraIntrinsicMatrix.mat"));
tform1=[R1 T1;0 0 0 1];
tform2=[R2 T2;0 0 0 1];
% img(1:1200,1:1600)=0;
img1=zeros(1200,1600,3);
img2=zeros(1200,1600,3);
for i=(1:House.scenePointCloud.Count)
    tmp=[transpose(House.scenePointCloud.Location(i,:));1];
    newtmp=(tform1*tmp);
    newtmp2=(tform2*tmp);
    c1c_pos=newtmp(1:3);
    c2c_pos=newtmp2(1:3);
    newnewtmp=intrinsics.K*c1c_pos;
    newnewtmp2=intrinsics.K*c2c_pos;
    frame1_pos=(newnewtmp./newnewtmp(3));
    frame2_pos=(newnewtmp2./newnewtmp2(3));
    framex=fix(frame1_pos(1));
    framey=fix(frame1_pos(2));
    framex2=fix(frame2_pos(1));
    framey2=fix(frame2_pos(2));
    if(framex>1 && framex<1600 && framey>1 && framey<1200)
        img1(framey,framex,:)=House.scenePointCloud.Color(i,:);
    end
    if(framex2>1 && framex2<1600 && framey2>1 && framey2<1200)
        img2(framey2,framex2,:)=House.scenePointCloud.Color(i,:);
    end
end
%% 

[Height,Width,Depth]=size(img1);
% for i=(2:Height-1)
%     for j=(2:Width-1)
%         if(img1(i,j,1)==0)
%             if( img1(i-1,j-1,1)~=0 && img1(i+1,j-1,1)~=0 && img1(i-1,j+1,1)~=0 && img1(i+1,j+1,1)~=0)
%                 img1(i,j,:)=(img1(i-1,j-1,:)+img1(i+1,j-1,:)+img1(i-1,j+1,:)+img1(i+1,j+1,:))./4;
%             end
%         end
%     end
% end
% img_c1= img1.imdilate(:,:,1,se);
% img_c2= imdilate(:,:,2,se);
% img_c3= imdilate(:,:,3,se);
% img_final = zeros(1200,1600,3);

% img1= imdilate(img1(:,:,:),se);
% [mesh1X,mesh1Y]=meshgrid(1:0.5:1600,1:0.5:1200);
% img1_meshR  = griddata(1:1600, 1:1200 , img1(:,:,1),mesh1X,mesh1Y , 'cubic' );
% img1_meshG  = griddata(1:1600, 1:1200 , img1(:,:,2),mesh1X,mesh1Y , 'cubic' );
% img1_meshB  = griddata(1:1600, 1:1200 , img1(:,:,3),mesh1X,mesh1Y , 'cubic' );
% img1_final(:,:,1)=img1_meshR(:,:);
% img1_final(:,:,2)=img1_meshG(:,:);
% img1_final(:,:,3)=img1_meshB(:,:);

% img_final(:,:,1)=interp2(1:1600,1:1200,img1(:,:,1),1:.2:1600,1:.2:1200,'cubic');
% img_final(:,:,2)=interp2(:,:,img1(:,:,2),:,:,'linear');
% img_final(:,:,3)=interp2(:,:,img1(:,:,3),:,:,'linear');
% imshow(uint8(img1));
imwrite(uint8(img1),'camera1.jpg');
imwrite(uint8(img2),'camera2.jpg');