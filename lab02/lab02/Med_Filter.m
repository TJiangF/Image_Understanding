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
            for(m=1:rows)
                for(n=1:cols)
                    Value((m-1)*cols+n)=image_extend(i+m-1,j+n-1);
                end
            end
%             tmp(:)=sort(Value(:));
            result=sort(Value);
            image_filtered(i,j)=result((filtersize*filtersize+1)/2);
        end
    end

output= image_filtered;
end