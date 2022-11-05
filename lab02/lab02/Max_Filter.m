function [output] = Max_Filter(image,filtersize)
    [Height,Width]=size(image);
    rows=filtersize;
    cols=filtersize;
    rows2add=(rows-1)/2;
    cols2add=(cols-1)/2;
%     Con=0;
    image_extend=padarray(image, [rows2add cols2add]);
    for(i=1:Height)
        for(j=1:Width)
            Max=0;
            for(m=1:rows)
                for(n=1:cols)
%                         image_extend(i+m-1,j+n-1)
%                         filter(m,n)
                        if(image_extend(i+m-1,j+n-1)>Max)
                            Max=image_extend(i+m-1,j+n-1);
                        end   
                end
            end
            image_filtered(i,j)=Max;
        end
    end

output= image_filtered;
end