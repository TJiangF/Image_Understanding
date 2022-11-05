function [Guassoutput] = GaussianFilter(image,window_size,sigma)
    k_size=(window_size-1)/2;
    ParaSum=0;
    for(i=1:window_size)
        for(j=1:window_size)
            H(i,j)=double(exp((-((i-k_size-1)^2)-(j-k_size-1)^2)/(2*sigma*sigma)));
            ParaSum=ParaSum+H(i,j);
        end
    end
    for(i=1:window_size)
        for(j=1:window_size)
            H(i,j)=H(i,j)/ParaSum;
        end
    end
    Guassoutput=my_conv(image,H);
end