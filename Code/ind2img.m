function img2 = ind2img(ind,img)
    %Converts indexed image into an RGB image    
    for i=3:-1:1, temp=img(:,:,i); img2(:,:,i)=temp(ind); end

return