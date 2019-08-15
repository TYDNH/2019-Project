I=imread('image.jpg');
a=rgb2gray(I); %convert image to grey scale
bw=edge(a,'canny'); % find edges in the grey scale image
bw = bwareaopen(bw,30); %remove small objects from image - extra edges
se = strel('disk',2); %creates a morphological structuring disk element with radius of 2 pixels
bw = imclose(bw,se); % Morpholigically closes the image. The morphological close operation is a dilation followed by an erosion, using the same structuring element for both operations.
bw = imfill(bw,'holes'); %Fill image regions and holes 
L = bwlabel(bw); %L = bwlabel(BW, n) returns a matrix L, of the same size as BW, containing labels for the connected objects in BW. The variable n can have a value of either 4 or 8, where 4 specifies 4-connected objects and 8 specifies 8-connected objects. If the argument is omitted, it defaults to 8.
s  = regionprops(L, 'centroid'); %STATS = regionprops(BW, properties) measures a set of properties for each connected component (object) in the binary image, BW. The image BW is a logical array; it can have any dimension.
dt  = regionprops(L, 'area'); %
cv = regionprops(L, 'perimeter'); %
dim = size(s) %
boundaries = bwboundaries(bw); %
imshow(bw); 
figure;imshow(I); 
hold on; %
 for k=1:dim(1) %
     b= boundaries{k}; %
     dim = size(b) %
     for i=1:dim(1) %
         F{k}(1,i) = sqrt ( ( b(i,2) - s(k).Centroid(1) )^2 + ( b(i,1) - s(k).Centroid(2) )^2 ) %
     end  %
     a=max(F{k}); %
     b=min(F{k}); %
     c=dt(k).Area; %
     O=a-b; %
     P = c/(4*b^2) %
     Q=c/(4*b*(a^2-b^2)^0.5); %
     R=(c*3^0.5)/((a+b)^2); %
     T =c/(a*b*pi); %
     U= (c*( a^2 - b^2 )^0.5) / (2*a^2*b) %
     if O < 10 %
             text(s(k).Centroid(1)-20,s(k).Centroid(2),'circle') %
    elseif (P < 1.05 ) & (P > .95)
             text(s(k).Centroid(1)-20,s(k).Centroid(2),'square') %
     elseif (T < 1.05 ) & (T > .95 )
             text(s(k).Centroid(1)-20,s(k).Centroid(2),'ellipse') %
     elseif (U < 1.05 ) & (U > .95 )
             text(s(k).Centroid(1)-20,s(k).Centroid(2),'diamond') %
     elseif ((Q <1.05) & (Q >.95)) 
             text(s(k).Centroid(1)-20,s(k).Centroid(2),'rectangle') %
     elseif  (R < 1.05 ) & (R > .95 )
             text(s(k).Centroid(1)-20,s(k).Centroid(2),'triangle') %
     end
 end