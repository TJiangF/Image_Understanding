function [edge_map,orient_map]=hist_edge_detector(img,rad,num_orient,num_bins)
thresh=1.5;
imggray=img;
imggray=im2double(imggray);
step=linspace(0,pi,num_orient);
[Height,Width]=size(imggray);

r=floor(rad);

imggray_extend=padarray(imggray, [r,r]);
for i=(1:Height)
    for j=(1:Width)
        h=-r:r-1;
        w=-r:r-1;
        tmp_circle=imggray_extend(i:i+2*r-1,j:j+2*r-1);
%         figure;
%         imshow(tmp_circle);
        [x,y]=meshgrid(h,w);
        circle=x.^2+y.^2;
        tmp_circle(find(circle>r^2))=0;
%         count=(tmp_circle~=0) ;
%         pixel_count=sum(count(:));
%         figure;
%         imshow(tmp_circle);
        kcount=1;
        half_count=1;
        for k=step
            x_step=1:1:2*r;
            y_step=tan(k)*(x_step-r)+r;
            left_half=tmp_circle;
            right_half=tmp_circle;
            for m=(1:2*r)
                for n=(1:2*r)
                    test_n=2*r+1-n;
                    if(tan(k)>=0 && k~=pi)
                        if(test_n>y_step(m))
                        right_half(m,n)=0;
                        else
                        left_half(m,n)=0;
                        end
                    else
                        if(test_n>y_step(m))
                        left_half(m,n)=0;
                        else
                        right_half(m,n)=0;
                        end
                    end
                    
                end
            end

%             figure;
%             imshow(left_half);
%             name=strcat("right_half_",num2str(half_count),'_.jpg');
%             imwrite(right_half,name);
%             half_count=half_count+1;
            right_hist=hist(right_half,num_bins);
            left_hist=hist(left_half,num_bins);
            [histh,histw]=size(right_hist);
%             A=zeros(1,histw);
%             B=zeros(1,histw);
%             for i3=1:histw
%                 A(1,i3)=norm(right_hist(:,i3));
%                 B(1,i3)=norm(left_hist(:,i3));
%             end
%             A=repmat(A,histh,1);
%             B=repmat(B,histh,1);
            A=sum(right_hist(:));
            B=sum(left_hist(:));
            right_hist=right_hist/A;
            left_hist=left_hist/B;
            
            hist_step=1:1:num_bins;
            g=(right_hist~=0);
            h=(left_hist~=0);
            gsum=sum(g,2);
            hsum=sum(h,2);
            Chidis=0;
            for i2=(1:num_bins)    
        %         tmp1=(gsum(i) - hsum(i))^2
        %         tmp2=gsum(i) + hsum(i)
                if ((gsum(i2) + hsum(i2)~=0))
                    Chidis=Chidis+sqrt(((gsum(i2) - hsum(i2))^2)/(gsum(i2) + hsum(i2)));
                end
            end
            Chi(i,j,kcount)=Chidis/2;
        %     Chi_Dis = sum((left_hist(:,hist_step) - right_hist(:,hist_step)).^2 ./ (left_hist(:,hist_step)+right_hist(:,hist_step)));
        %     Chi_Dis=(1/2)*sqrt(sum())
            kcount=kcount+1;
        end
        [max_num,max_index]=max(Chi(i,j,:));
%         theta_v(i,j)=step(max_index);
          theta_v(i,j)=max_num;
%         store the orientation recorded as rad

    end
end

orient_map=theta_v;
[dy,dx]=gradient(theta_v);
M=sqrt(dx.^2+dy.^2);

[Lenx,Leny]=size(theta_v);
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
        val_q=M_extend(i+1+ref_x(degree(i,j,3)),j+1+ref_y(degree(i,j,3)));
        val_opp_q=M_extend(i+1-ref_x(degree(i,j,3)),j+1-ref_y(degree(i,j,3)));
        if(M_extend(i+1,j+1)<val_opp_q && M_extend(i+1,j+1)<val_q)
            M(i,j)=0;
        end
    end
end

edge_map=M;





