function [output] = my_conv(image,filter)
    [Height,Width]=size(image);
    [rows,cols]=size(filter);
    rows2add=(rows-1)/2;
    cols2add=(cols-1)/2;
%     Con=0;
    image_extend=padarray(image, [rows2add cols2add]);
    for(i=1:Height)
        for(j=1:Width)
            Con=0;
            for(m=1:rows)
                for(n=1:cols)
%                         image_extend(i+m-1,j+n-1)
%                         filter(m,n)
                        Con=Con+double(image_extend(i+m-1,j+n-1))*double(filter(m,n));
%                         Con=Con+image_extend(i+m-1,j+n-1)*filter(m,n);
                end
            end
%             image_filtered(i,j)=Con;
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