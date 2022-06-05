clc; clear all; close all;

%% Importing image
% When mask is superimposed on original image
% image_name='images/input.png';
% image1_name='images/input2.png';
% %mask_name='images/walk2.png';
% img=imread(image_name);
% img1=imread(image1_name);
% mask=maskgenerator(img,img1);
% %img1=logical(rgb2gray(img1));
% 
% Image=double(imread(image_name));
% mask=double(mask/255);

%% Importing image
image_name='images/beach.png'; % Image name
image1_name='images/beach_mask.png'; % mask name
img1=imread(image1_name);
img1=logical(rgb2gray(img1));
Image1=imread(image_name); 
%Image1=imnoise(Image1, 'gaussian'); % For synthetic image
Image=double(Image1);
mask=double(img1);
p_size=13; % Patch size- odd scalar
n_out=4;

%% Checking if mask and patch size is valid
Check_Error(mask,p_size);

%% Initializing 
fill_region=mask;
auxImage=Image;
s=size(auxImage);
ind=reshape(1:s(1)*s(2),s(1),s(2));
sz = [size(auxImage,1) size(auxImage,2)];
source_region = ~fill_region;

% Initializing isophote values
[Ix(:,:,3), Iy(:,:,3)] = gradient(auxImage(:,:,3));
[Ix(:,:,2), Iy(:,:,2)] = gradient(auxImage(:,:,2));
[Ix(:,:,1), Iy(:,:,1)] = gradient(auxImage(:,:,1));
Ix = sum(Ix,3)/(3*255); Iy = sum(Iy,3)/(3*255);
temp = Ix; Ix = -Iy; Iy = temp;  % Rotating gradient by 90 degrees

% Initializing confidence values and data terms
C = double(source_region);
D = repmat(-.1,sz);
iter = 1;

%% Loop until entire fill region has been covered
rand('state',0);
var=1;
while any(fill_region(:)) % while each element is non-zero
    iteration=var
    var=var+1;

    % Convolving laplacian mask to find edges
    fill_regionD=double(fill_region);
    contour = find(conv2(fill_regionD,[1,1,1;1,-8,1;1,1,1],'same')>0);  %fill front
    [Nx,Ny] = gradient(double(~fill_region)); 
    N = [Nx(contour(:)) Ny(contour(:))];
    N = normr(N);  
    N(~isfinite(N))=0; % handle NaN and Inf

    % Compute confidences along the fill front
    for k = contour'
    Hp = get_Patch(sz,k,p_size);
    q = Hp(~(fill_region(Hp))); 
    C(k) = sum(C(q))/numel(Hp);
    end

    % finding data term
    D(contour) = abs(Ix(contour).*N(:,1)+Iy(contour).*N(:,2)) + 0.001;%
      
    % Compute patch priorities = Confidence term * Data term
    priorities = C(contour).* D(contour);

    % Find patch with maximum priority, Hp
    [~,ndx] = max(priorities(:));
    p = contour(ndx(1));
    [Hp,rows,cols] = get_Patch(sz,p,p_size);
    toFill = fill_region(Hp);

    imshow(uint8(auxImage));figure
    inpaintedMovie(iter) = im2frame(uint8(auxImage));

    % Find exemplar that minimizes error, Hq
    Hq = best_exemplar(auxImage,auxImage(rows,cols,:),toFill',source_region,rows,cols);

    % Update fill region
    toFill = logical(toFill);                 
    fill_region(Hp(toFill)) = false;

    % Propagate confidence & isophote values
    C(Hp(toFill))  = C(p);
    Ix(Hp(toFill)) = Ix(Hq(toFill));
    Iy(Hp(toFill)) = Iy(Hq(toFill));

    % Copy image data from Hq to Hp
    ind(Hp(toFill)) = ind(Hq(toFill));
    auxImage(rows,cols,:) = ind2img(ind(rows,cols),Image); 

    iter = iter+1;
    inpaintedMovie(iter) = im2frame(uint8(auxImage));
    
    axis off; 
    % Matlab movie
    movie(inpaintedMovie,1);
    inpaintedImg = auxImage;

end
%% Final display
figure
subplot(131);imshow(uint8(Image));title("Original Image");
subplot(132);imshow(mask);title("Mask");
subplot(133);imshow(uint8(inpaintedImg));title("Inpainted Image");

