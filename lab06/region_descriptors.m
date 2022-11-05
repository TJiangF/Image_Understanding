function D=region_descriptors(img,c_cood,window,type)
    if(size(img,3)~=1)
        img=double(im2gray(img));
    end
    e=fix((window-1)/2);
    img_extend=padarray(img, [e,e]);
%     bins=double(16);
    bins=10;

    if(type=="pixels")
        for i=(1:size(c_cood,2))
            D(1:window,1:window,i)=img_extend(c_cood(1,i):c_cood(1,i)+2*e,c_cood(2,i):c_cood(2,i)+2*e);
        end
    else if(type=="histogram")
        for i=(1:size(c_cood,2))
            H(1:window,1:window,i)=double(img_extend(c_cood(1,i):c_cood(1,i)+2*e,c_cood(2,i):c_cood(2,i)+2*e));
            sumH=sum(sum(H(:,:,i)));
            meanH=sumH/(window*window);
            
            H(:,:,i)=H(:,:,i)-meanH;
            Hnorm=normalize(H(:,:,i));
            [M,N] = size(H(:,:,i));
            
%             Hnorm = zeros(M,N);
%             for j=1:N
%                 allAtr = H(:,j,i);
%                 STD = std(allAtr);    
%                 MEAN = mean(allAtr);  
%                 if(STD~=0)    
%                     x = (allAtr-MEAN)/STD;
%                 else
%                     x=0;
%                 end
%                 Hnorm(:,j)=x;
%             end

            Dtmp=reshape(Hnorm,1,window*window);

%             x=linspace(-0.05,0.1,10);
            D(:,:,i)=hist(Dtmp,bins);
        end
    else
        D=None;
    end
end