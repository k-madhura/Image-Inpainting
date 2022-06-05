function [ssdout] = ssd(Ip,patch,toFill)
    %Return the SSD(sum of squared difference)
    
    Ip=double(Ip);
    patch=double(patch);
    ssdout = 0;

    
    if(size(Ip,3)==3)
        C = zeros(1,3);
        
        for k=1:3 % For rgb image computing the mean
                X = (patch(:,:,k)-Ip(:,:,k)).^2;
                X(logical(toFill))=0;
                ssd = sum(X(:));
                C(1,k) = ssd;
            
        end

        ssdout = mean(C);

    end
    
end

