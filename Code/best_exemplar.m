function Hq = best_exemplar(img,Ip,toFill,sourceRegion,rows,cols)
    % Scans over the entire image to minimize distance
    
    m=size(Ip,1);
    mm=size(img,1);
    n=size(Ip,2);
    nn=size(img,2);

    %Defining rows and cols indexes of patch with maximum priority

	patchErr=0.0;
	bestErr=1000000000.0;
	best = zeros(1,4);%Initialize vector containing the coordinates of the most similar patch Iq

	N=nn-n+1;
	M=mm-m+1;
  
	Ip = rgb2lab(Ip);
	img = rgb2lab(img);

	%sliding window over the image
	for j = 1:M 
        J=j+m-1;
        for i = 1:N 
            I = i+n-1;
        
            %check that sliding window is inside source region and outside Ip
            if(in_source_region(j,J,i,I,sourceRegion) && outside_Ip(rows,cols,j,J,i,I))

                patchErr = ssd(Ip,img(j:J,i:I,:),toFill);

                if (patchErr <= bestErr) %Updating 
                    bestErr = patchErr;
                    best(1,1) = j; best(1,2) = J;
                    best(1,3) = i; best(1,4) = I;
            
                end

            end
        end
    
	end

    Hq = sub2ndx(best(1):best(2),(best(3):best(4))',mm);
    
    function [isinsourceregion] = in_source_region(j,J,i,I,sourceRegion)
    %Return 1 true if patch is in sourceRegion and 0 if outside
   
    
        isinsourceregion = 1;
        for k = j:J
            for z = i:I
                if(sourceRegion(k,z)==0)
                        isinsourceregion = 0;
                end
            end
        end            
    end

    function [isoutsideIp] = outside_Ip(rows,cols,j,J,i,I)
        %Return 1 true if the sliding window is outside Ip
        % and return 0 false if the sliding window is inside Ip 
        
        isoutsideIp = 1;
        if((ismember(j,rows) || ismember(J,rows)) && ((ismember(i,cols) || ismember(I,cols))))
            isoutsideIp = 0;
        end    
    end
end
