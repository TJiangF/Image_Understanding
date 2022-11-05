for i=(r+1:Height-r)
    for j=(r+1:Width-r)
        h=-r:r-1;
        w=-r:r-1;
        tmp_circle=imggray(i-r:i+r-1,j-r:j+r-1);
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
%             imshow(right_half);
%             name=strcat("right_half_",num2str(half_count),'_.jpg');
%             imwrite(right_half,name);
%             half_count=half_count+1;
            right_hist=hist(right_half,num_bins);
            left_hist=hist(left_half,num_bins);
            [histh,histw]=size(right_hist);
            A=zeros(1,histw);
            B=zeros(1,histw);
            for i3=1:histw
                A(1,i3)=norm(right_hist(:,i3));
                B(1,i3)=norm(left_hist(:,i3));
            end
            A=repmat(A,histh,1);
            B=repmat(B,histh,1);
            right_hist=right_hist./A;
            left_hist=left_hist./B;
            
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
            Chi(i-r,j-r,kcount)=Chidis/2;
        %     Chi_Dis = sum((left_hist(:,hist_step) - right_hist(:,hist_step)).^2 ./ (left_hist(:,hist_step)+right_hist(:,hist_step)));
        %     Chi_Dis=(1/2)*sqrt(sum())
            kcount=kcount+1;
        end
        [max_num,max_index]=max(Chi(i-r,j-r,:));
        theta_v(i-r,j-r)=step(max_index);
%         store the orientation recorded as rad

    end
end