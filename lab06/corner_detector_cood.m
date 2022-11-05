function [corners,corners_coordinates] = corner_detector_cood(image)
img=image;
if(size(image,3)~=1)
    img=rgb2gray(img);
end
img=im2double(img);
[Height,Width]=size(img);
sigma1=0.7;
win1=fix(6*sigma1);
Gauss=fspecial('gaussian',[win1,win1],sigma1);
[Gx,Gy]=gradient(Gauss);

% [dx,dy]=meshgrid(-1:1,-1:1);
fx=conv2(double(img),Gx,'same');
fy=conv2(double(img),Gy,"same");
fxy=fx.*fy;
% imshow(uint8(fx));


% % [dx,dy]=gradient(img);
% 
% Gx=fspecial('gaussian',[win1,win1],sigma1);
% Gy=fspecial('gaussian',[win1,win1],sigma1);
% 
% fx=conv2(dx,Gx,"same");
% fy=conv2(dy,Gy,"same");

% fx_sq=fx.*fx;
% fy_sq=fy.*fy;
% fxfy=fx.*fy;
sigma2=2;
win2=6*sigma2+1;
G_integration=fspecial('gaussian',[win2,win2],sigma2);
Sx=conv2(double(fx.*fx),G_integration,"same");
Sy=conv2(double(fy.*fy),G_integration,"same");
Sxy=conv2(double(fx.*fy),G_integration,"same");

alpha=0.04;

for(i=1:Height)
    for(j=1:Width)
        M=[Sx(i,j) Sxy(i,j);Sxy(i,j) Sy(i,j)];
        R(i,j)=det(M)-alpha*(trace(M)^2);
    end
end

R_extend=padarray(R, [1,1]);

thresh=0.01;
tmp=zeros(3,3);
for i=1:Height
    for j=1:Width
        tmp=R_extend(i:i+2,j:j+2);
        maxtmp=max(max(tmp(:,:)));
        if(R_extend(i+1,j+1)<maxtmp)
            R(i,j)=0;
        end
    end
end
R0=max(max(R(:,:)));
R(find(R(:,:)<thresh*R0))=0;
% R(find(R(:,:)~=0))=1;
[X,Y] = ind2sub(size(R), find(R(:,:)~=0));
% Intensity=
corners_coordinates(1,:)=X(:);
corners_coordinates(2,:)=Y(:);

for i=(1:length(X))
    corners_coordinates(3,i)=R(X(i),Y(i));
end
corners=R;



