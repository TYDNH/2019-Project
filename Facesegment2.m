   %
  I = imread('image2.jpg');
  J = imresize(I,0.5);
  % %To detect Face 
   FDetect = vision.CascadeObjectDetector; 
  %Returns Bounding Box values based on number of objects
   BB = step(FDetect,J);
  % 
   figure,
   imshow(J); hold on 
   rectangle('Position',BB,'LineWidth',3,'LineStyle','-','EdgeColor','y');
  title('Face Detection');
  hold off;
  Face=imcrop(J,BB);
  figure,imshow(Face)
%To detect Eyes
EyeDetect = vision.CascadeObjectDetector('EyePairBig');
BB=step(EyeDetect,J);
figure,imshow(J);
rectangle('Position',BB,'LineWidth',4,'LineStyle','-','EdgeColor','b');
title('Eyes Detection');
Eyes=imcrop(J,BB);
figure,imshow(Eyes);
%To detect Nose
NoseDetect = vision.CascadeObjectDetector('Nose','MergeThreshold',64);
BB=step(NoseDetect,J);
figure,
imshow(J); hold on
for i = 1:size(BB,1)
rectangle('Position',BB(i,:),'LineWidth',2,'LineStyle','-','EdgeColor','b');
end
title('Nose Detection');
hold off;
nose=imcrop(J,BB);
figure,imshow(nose);
%To detect Mouth
MouthDetect = vision.CascadeObjectDetector('Mouth','MergeThreshold',128);
BB=step(MouthDetect,J);
figure,
imshow(J); hold on
for i = 1:size(BB,1)
rectangle('Position',BB(i,:),'LineWidth',4,'LineStyle','-','EdgeColor','r');
end
title('Mouth Detection');
hold off;
mouth=imcrop(J,BB);
figure,imshow(mouth);