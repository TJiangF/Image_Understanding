function [indx_1st_best,indx_2nd_best,simi_1st_best,simi_2nd_best]=find_matches(D1,D2,similarity_type)
    
    
    if(similarity_type=="SSD")
        window=size(D1,1);
        for i=(1:size(D1,3))
            D1tmp=D1(:,:,i);
            for j=(1:size(D2,3))  
                D2tmp=D2(:,:,j);
                h=1:size(D1tmp,1);
                w=1:size(D1tmp,2);
                sumtmp=sum(sum((double(D1tmp(h,w))-double(D2tmp(h,w))).^(2)));
%                 if(sumtmp==0)
%                     D1tmp(h,w)
%                     D2tmp(h,w)
%                     
%                 end
                if(j==1)
                    min1st=sumtmp;
                    indx1=1;
%                     simi_1st_best(i)=min;
                    min2nd=0;
                end
                if(j==2)
                    if(sumtmp<min1st)         
                        min2nd=min1st;
                        min1st=sumtmp;
                        indx1=2;
                        indx2=1;
                    else
                        min2nd=sumtmp;
                        indx2=2;
                    end
                end
                if(sumtmp<min2nd && j>2)
                    if(sumtmp<min1st)
                        min2nd=min1st;
                        min1st=sumtmp;
                        indx2=indx1;
                        indx1=j;
                    else
                        min2nd=sumtmp;
                        indx2=j;
                    end
                end
            end
            indx_1st_best(i)=indx1;
            indx_2nd_best(i)=indx2;
            simi_1st_best(i)=min1st;
            simi_2nd_best(i)=min2nd;
        end

    end
    if(similarity_type=="NCC")
        window=size(D1,1);
        D2combine=D2(:,:,1);
        for j=(2:size(D2,3))  
                D2tmp=D2(:,:,j);
                D2combine=[D2combine,D2tmp];
        end
        for i=(1:size(D1,3))
            D1tmp=D1(:,:,i);
            c=normxcorr2(D1tmp,D2combine);
            [ypeak, xpeak] = find(c==max(c(:)),1,'first');
            indx1=ceil((xpeak)/window);
            if(indx1>size(D2,3))
                indx1=size(D2,3);
            end
            min1st=max(c(:));
%             window*(indx1-1)+1
%             window*indx1
            c(:,window*(indx1-1)+1:window*indx1)=0;
            [ypeak2, xpeak2] = find(c==max(c(:)),1,'first');
            
            min2nd=max(c(:));
            indx2=ceil((xpeak2)/window);
            if(indx2>size(D2,3))
                indx2=size(D2,3);
            end
            indx_1st_best(i)=indx1;
            indx_2nd_best(i)=indx2;
            simi_1st_best(i)=min1st;
            simi_2nd_best(i)=min2nd;
        end
    end
    if(similarity_type=="Chi-Square")
        bins=size(D1,2);
%         window=size(D1,2);
        for i=(1:size(D1,3))
            D1tmp=D1(:,:,i);
            for j=(1:size(D2,3))
                D2tmp=D2(:,:,j);                
                gsum=sum(D1tmp,1);
                hsum=sum(D2tmp,1);
%                 gsum=D1tmp;
%                 hsum=D2tmp;
                Chidis(j)=0;
                for i2=(1:bins)    
                    if ((gsum(i2) + hsum(i2)~=0))
                        Chidis(j)=Chidis(j)+sqrt(((gsum(i2) - hsum(i2))^2)/(gsum(i2) + hsum(i2)))/2;
                    end
                end
            end
            [B,IX] = sort(Chidis(:),'ascend');
            indx_1st_best(i)=IX(1);
            indx_2nd_best(i)=IX(2);
            simi_1st_best(i)=B(1);
            simi_2nd_best(i)=B(2);
        end
    end
end