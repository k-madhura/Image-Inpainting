function Check_Error(mask,p_size)
    %Check if matrix is valid and if patch size is odd
    
    if ~ismatrix(mask); error('Invalid mask'); end
    if sum(sum(mask~=0 & mask~=1))>0; error('Invalid mask'); end
    if mod(p_size,2)==0; error('Patch size p_size should be odd'); end

end