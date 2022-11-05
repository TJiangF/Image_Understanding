foldername='problem_2/';
% subfoldername='rubix/rubik0';
subfoldername='car/carseq9';
% subfoldername='walking/track1';
% filenum = 0:19;
filenum = 0:49;
% filenum = 0:57;
for i=1:length(filenum)
    if(i<=10)
        if(length(subfoldername)~=13)
            path = strcat(foldername,subfoldername,'0',num2str(filenum(i)),'.jpg');
        else
            path = strcat(foldername,subfoldername,'0',num2str(filenum(i)),'.ppm');
        end
    else
        if(length(subfoldername)~=13)
            path = strcat(foldername,subfoldername,num2str(filenum(i)),'.jpg');
        else
            path = strcat(foldername,subfoldername,num2str(filenum(i)),'.ppm');
        end
    end
    imgorg(:,:,i)=im2gray(imread(path));
    
end

%% KLT 

M=25;
m=50;
win=2*m+1;
acc=1;
for i=(1:length(filenum)-1)
% 
    
    if(i==1)
        corners_tmp=corner_detector(imgorg(:,:,i));
%         img=imgorg(:,:,i);
%         [H,W]=size(img);
%         imshow(img),hold on,
%         for i=1:H
%             for j=1:W
%                 if (corners_tmp(i,j)~=0)
%                     plot(j,i,'r+')
%                 end
%             end
%         end
%         hold off;  
        [B,IX] = sort(corners_tmp(:),'descend');
        [I,J] = ind2sub(size(corners_tmp), IX);
        strong_corners(1,1:M)=I(1:M);
        strong_corners(2,1:M)=J(1:M);
        strong_corners(3,1:M)=B(1:M);%% 1->Height 2->Width
    else
        
        strong_corners(:,:)=tracked_corners(:,:,i-1);
    end

    


    [dx,dy]=gradient(double(imgorg(:,:,i)));
    [Height,Width]=size(imgorg(:,:,1));
    for j=(1:M)
        p_tmp=[strong_corners(1,j),strong_corners(2,j)];
        if(p_tmp(1)-m>=1 && p_tmp(1)+m<=Height && p_tmp(2)-m>=1 && p_tmp(2)+m<=Width)

%             w0=imgorg(p_tmp(1)-m:p_tmp(1)+m,p_tmp(2)-m:p_tmp(2)+m,i);
    
            x1=p_tmp(1)-m:p_tmp(1)+m;
            y1=p_tmp(2)-m:p_tmp(2)+m;
            [Y1,X1]=meshgrid(x1,y1);
            W=interp2(double(imgorg(:,:,i)),Y1,X1,'linear',0);
            Ix=interp2(double(dx),Y1,X1,'linear',0);
            Iy=interp2(double(dy),Y1,X1,'linear',0);
    
    %         figure
    %         surf(W,Y1,X1);
    %         title('Linear Interpolation Using Finer Grid');
    
    
    
            Mxy=[sum(Ix(:,:).^2,'all'),sum(Ix(:,:).*Iy(:,:),'all');sum(Ix(:,:).*Iy(:,:),'all'),sum(Iy(:,:).^2,'all')];
    %         Img_int=interp2(img(:,:,i),10000);
            K=1;
          
            v=[0;0];
            converge_flag = 1;
            c_dis = 0;
            c_dis_old = 10^7;
            while(K<=15 && det(Mxy)~=0)%Eta>=acc &&
    %             wk=imgorg(x1+v(1),y1+v(2),i);
                x_tmp=p_tmp(1)-m+v(1):p_tmp(1)+m+v(1);
                y_tmp=p_tmp(2)-m+v(2):p_tmp(2)+m+v(2);
                [Y_tmp,X_tmp]=meshgrid(x_tmp,y_tmp);
                Wk=interp2(double(imgorg(:,:,i+1)),Y_tmp,X_tmp,'linear',0);
                DeltaIt=W-Wk;
                bxy=[sum(DeltaIt.*Ix,'all');sum(DeltaIt.*Iy,'all')];
                
                Eta=inv(Mxy).*bxy;
                c_dis = sum(Eta.*Eta,'all');
                if (c_dis > c_dis_old)
                    converge_flag = 0;
                end
                v=v+Eta;
                K=K+1;
                
            end
            
            if(((p_tmp(1)+v(1))>1) && ((p_tmp(1)+v(1))<Height) && ((p_tmp(2)+v(2))>1) && ((p_tmp(2)+v(2))<Width) ...
                    && (converge_flag~=0 && det(Mxy)~=0))
                strong_corners(1:2,j)=[p_tmp(1)+v(1);p_tmp(2)+v(2)];
            else
                strong_corners(3,j)=0;
            end
        end

    end
    tracked_corners(1,:,i)=strong_corners(1,:);
    tracked_corners(2,:,i)=strong_corners(2,:);
    tracked_corners(3,:,i)=strong_corners(3,:);
end


%% plot and show
figure;
for i=(1:length(filenum)-1)
    imshow(uint8(imgorg(:,:,i)));
    hold on
    for j=(1:M)
%         [tB,tIX] = sort(tracked_corners(:),'descend');
%         [tI,tJ] = ind2sub(size(tracked_corners), IX);

        if(tracked_corners(3,j,i)~=0)
            
            plot(tracked_corners(2,j,i),tracked_corners(1,j,i),'rx','LineWidth',2,'MarkerSize',5)
%             outputname=strcat('track_corner',num2str(filenum(i)),'_m=_',num2str(m),'.jpg');
%             saveas(gca,[outputname]);
        end
    end
    pause(0.4);
end
hold off

