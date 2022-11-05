function [output] = separate_conv(image,hcols,hrows)
    [Height,Width]=size(image);
    rows=length(hcols);
    cols=length(hrows);
    rows2add=(rows-1)/2;
    cols2add=(cols-1)/2;
%     Con=0;
    image_extend=padarray(image, [rows2add cols2add]);
    processing=zeros(rows,1);
    for(i=1:Height)
        for(j=1:Width)
            Con=0;
            tmpmat=image_extend(i:i+2*rows2add,j:j+2*cols2add);
            process= conv2(tmpmat,hcols,'valid');
            Done=conv2(process,hrows,'valid');
            Con=sum(Done(:));
            if(Con>=0)
                if(Con<=255)
                image_filtered(i,j)=Con;
                else 
                    image_filtered(i,j)=255;
                end
            else if(Con<0)
                image_filtered(i,j)=0;
            end
        end
    end
     
    output= image_filtered;
end