function varargout = final_test1(varargin)
% FINAL_TEST1 MATLAB code for final_test1.fig
%      FINAL_TEST1, by itself, creates a new FINAL_TEST1 or raises the existing
%      singleton*.
%
%      H = FINAL_TEST1 returns the handle to a new FINAL_TEST1 or the handle to
%      the existing singleton*.
%
%      FINAL_TEST1('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FINAL_TEST1.M with the given input arguments.
%
%      FINAL_TEST1('Property','Value',...) creates a new FINAL_TEST1 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before final_test1_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to final_test1_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help final_test1

% Last Modified by GUIDE v2.5 22-Aug-2019 09:55:48

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @final_test1_OpeningFcn, ...
                   'gui_OutputFcn',  @final_test1_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before final_test1 is made visible.
function final_test1_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to final_test1 (see VARARGIN)

% Choose default command line output for final_test1

% --- Executes on button press in selectImageBtn.
function selectImageBtn_Callback(hObject, eventdata, handles)
% hObject    handle to selectImageBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[filename pathname] = uigetfile({'*.jpg';'*.bmp'},'File Selector'); 
global myImage
myImage = strcat(pathname, filename);
axes(handles.inputImageAxes);
imshow(myImage)
%image=rgb2gray(myImage);
%set(handles.pOutput,'string',filename);
%set(handles.qOutput,'string',handles.myImage);
guidata(hObject,handles);

% --- Executes on button press in processBtn.
function processBtn_Callback(hObject, eventdata, handles)
% hObject    handle to processBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global myImage

A= imread(myImage);
J=rgb2gray(A);
  % %To detect Face 
FDetect = vision.CascadeObjectDetector; 
  %Returns Bounding Box values based on number of objects
BB = step(FDetect,J);
  % 
figure,
imshow(A); hold on 
rectangle('Position',BB,'LineWidth',4,'LineStyle','-','EdgeColor','y');
title('Face Detection');
hold off;
Face=imcrop(J,BB);
[rows columns numberOfColorBands] = size(J); 
axes(handles.faceSegmentAxes) 
imshow(J); 
title('Original gray Image'); 
%set(gcf, 'Position', get(0,'Screensize')); % Maximize figure.
%STEP 2
%---------------------------------------------------Convert rgb image to grayscale-----------------------------------------
grayImage = Face; 
% subplot(3, 2, 2); 
% imshow(grayImage, []); 
% title('Converted to gray scale');
%STEP 3
%------------------------------------------------------Detection of edge by canny-------------------------------------------------------
cannyImage = edge(grayImage,'canny'); 
axes(handles.faceSegmentAxes1)
imshow(cannyImage); 
title('Canny Edge Image');
%STEP 4
%-------------------------------------------------------------dilation--------------------------------------------------------

[B,L] = bwboundaries(grayImage, 'noholes');
STATS = regionprops(L, 'all');
cannyImage1=cannyImage;
axes(handles.faceSegmentAxes3) 
imshow(grayImage);

hold on 
for i = 1 : length(STATS) 
W(i) = uint8(abs(STATS(i).BoundingBox(3)-STATS(i).BoundingBox(4)) < 0.1); 
W(i) = W(i) + 2 * uint8((STATS(i).Extent - 1) == 0 ); 
centroid = STATS(i).Centroid; 
switch W(i) 
case 1 
plot(centroid(1),centroid(2),'wO'); 
title('circle'); 
case 2 
plot(centroid(1),centroid(2),'wX'); 
title('triangle'); 
case 3 
plot(centroid(1),centroid(2),'wS'); 
title('square'); 
end 
end
return
% h=handles.faceSegmentAxes3;
% a=findobj(h,'type','axe')
% x=get(get(a,'xlabel'),'string')
% 




% --- Executes on button press in processBtn1.
function processBtn1_Callback(hObject, eventdata, handles)
% hObject    handle to processBtn1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global myImage

A= imread(myImage);
J=rgb2gray(A);
EyeDetect = vision.CascadeObjectDetector('EyePairBig');
BB=step(EyeDetect,J);
figure,
imshow(A); hold on 

rectangle('Position',BB,'LineWidth',4,'LineStyle','-','EdgeColor','b');
title('Eyes Detection');

Eyes=imcrop(J,BB);
axes(handles.EyesSegmentAxes)
imshow(Eyes);
title('Eyes Segmentation');

bw=edge(Eyes,'canny'); % find edges in the grey scale image
bw = bwareaopen(bw,30); %remove small objects from image - extra edges
se = strel('disk',2); %creates a morphological structuring disk element with radius of 2 pixels
bw = imclose(bw,se); % Morpholigically closes the image. The morphological close operation is a dilation followed by an erosion, using the same structuring element for both operations.
bw = imfill(bw,'holes'); %Fill image regions and holes 
L = bwlabel(bw); %L = bwlabel(BW, n) returns a matrix L, of the same size as BW, containing labels for the connected objects in BW. The variable n can have a value of either 4 or 8, where 4 specifies 4-connected objects and 8 specifies 8-connected objects. If the argument is omitted, it defaults to 8.
s  = regionprops(L, 'centroid'); %STATS = regionprops(BW, properties) measures a set of properties for each connected component (object) in the binary image, BW. The image BW is a logical array; it can have any dimension.
dt  = regionprops(L, 'area'); %
cv = regionprops(L, 'perimeter'); %
dim = size(s) %
boundaries = bwboundaries(bw);
axes(handles.EyesSegmentAxes1)
imshow(bw);
title('Canny Edge detection');

axes(handles.EyesSegmentAxes2)
imshow(Eyes); 
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
             text(s(k).Centroid(1)-20,s(k).Centroid(2),'circle');
             title('circle');%
    elseif (P < 1.05 ) & (P > .95)
             text(s(k).Centroid(1)-20,s(k).Centroid(2),'square');
             title('square');
     elseif (T < 1.05 ) & (T > .95 )
             text(s(k).Centroid(1)-20,s(k).Centroid(2),'ellipse');
             title('ellipse');
     elseif (U < 1.05 ) & (U > .95 )
             text(s(k).Centroid(1)-20,s(k).Centroid(2),'diamond'); 
             title('diamond');
     elseif ((Q <1.05) & (Q >.95)) 
             text(s(k).Centroid(1)-20,s(k).Centroid(2),'rectangle') ;
             title('rectangle');
     elseif  (R < 1.05 ) & (R > .95 )
             text(s(k).Centroid(1)-20,s(k).Centroid(2),'triangle');
             title('triangle');
     end
 end


% --- Executes on button press in openCameraBtn1.
function openCameraBtn1_Callback(hObject, eventdata, handles)
% hObject    handle to openCameraBtn1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global vid;
axes(handles.cameraAxes);
vid=videoinput('macvideo',1);
hImage=image(zeros(350,350,1),'Parent',handles.cameraAxes);
set(vid,'ReturnedColorSpace','RGB');
preview(vid,hImage);

guidata(hObject,handles);



% --- Executes on button press in captureBtn1.
function captureBtn1_Callback(hObject, eventdata, handles)
% hObject    handle to captureBtn1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.output =hObject;
global vid;

img=getsnapshot(vid);
image(img);
counter=1;
baseDir='/Users/toweyadanarhlaing/Desktop/Matlab Testing/';
baseName='snapshot_';
newName=fullfile(baseDir,sprintf('%s%f.jpg',baseName,counter));
while exist(newName,'file')
    counter=counter+1;
    newName=[baseDir baseName num2str(counter) '.jpg'];
end

imwrite(img,newName);
imagefiles=dir('*.jpg');
nfiles=length(imagefiles);
currentfilename=imagefiles(nfiles).name;
img=imread(currentfilename);


% --- Executes on button press in resultBtn.
function resultBtn_Callback(hObject, eventdata, handles)
% hObject    handle to resultBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
squarestring=" High stamina,  a strong wit and analytical mind,   always remain calm and collected";
trianglestring="Tend to be creative, artistic, and sensitive ,  they’re also fiery!";
otherstring="Deep thinkers and value logic, but they often overthink things,  strategic and efficient ";
h=get(handles.faceSegmentAxes3,'Title');
x=get(h,'String')
if x=="square"
    set(handles.faceResultText,'String',squarestring);
    axes(handles.resultAxes1);
    imshow('Jolie.jpg');
    title('Famous Celebrity Eg: Angelina Jolie');
    axes(handles.resultAxes3);
    imshow('Robert.jpg');
    title('Famous Celebrity Eg: Robert Pattinson');

elseif x=="triangle"
    set(handles.faceResultText,'String',trianglestring);
    axes(handles.resultAxes1);
    imshow('Scarlett.jpg');
    title('Famous Celebrity Eg: Scarlett Johansson');
    axes(handles.resultAxes3);
    imshow('Leonado.jpg');
    title('Famous Celebrity Eg:Leonado Dicaprio');

else 
    set(handles.faceResultText,'String',otherstring);
    axes(handles.resultAxes1);
    imshow('Selena.jpg');
    title('Famous Celebrity Eg: Selena Gomez ');
    axes(handles.resultAxes3);
    imshow('edsheeran.jpg');
    title('Famous Celebrity Eg:Ed Sheeran');


    
end

Cstring="Warmth, great creativity and imagination";
Sstring="Good at analyzing situations , making the right choices";
Estring="Attentive and cautious ";
Dstring="Easy going and peaceful, open to the idea of two things being one";
Rstring="Strategic and efficient";
Tstring="Tend to be very keen, receptive, and empathetic people";

h=get(handles.EyesSegmentAxes2,'Title');
y=get(h,'String')
if y=="circle"
    set(handles.eyesResultText,'String',Cstring);
elseif y=="square"
    set(handles.eyesResultText,'String',Sstring);
elseif y=="ellipse"
    set(handles.eyesResultText,'String',Estring);
elseif y=="diamond"
    set(handles.eyesResultText,'String',Dstring);
elseif y=="recrangle"
    set(handles.eyesResultText,'String',Rstring);

else 
    set(handles.eyesResultText,'String',Tstring);
    
    
end
%set(handles.faceResultText,'String','FaceResult');
%set(handles.eyesResultText,'String','EyeResult');


% --- Executes on button press in ClearBtn.
function ClearBtn_Callback(hObject, eventdata, handles)
% hObject    handle to ClearBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cla(handles.resultAxes3,'reset');
cla(handles.resultAxes1,'reset');
cla(handles.cameraAxes,'reset');
cla(handles.inputImageAxes,'reset');
cla(handles.faceSegmentAxes,'reset');
cla(handles.faceSegmentAxes1,'reset');
cla(handles.faceSegmentAxes3,'reset');
cla(handles.EyesSegmentAxes,'reset');
cla(handles.EyesSegmentAxes1,'reset');
cla(handles.EyesSegmentAxes2,'reset');
handles.faceResultText.String='';
handles.eyesResultText.String='';
