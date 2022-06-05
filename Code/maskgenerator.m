function image_mask=maskgenerator(img, img1)
% Generates mask if target region is selected in black in paint
    c=imabsdiff(img,img1);
    c=rgb2gray(c);
    c1=logical(c);
    image_mask=im2uint8(c1);
end
