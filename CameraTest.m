function varargout = CameraTest(varargin)
% CAMERATEST MATLAB code for CameraTest.fig
%      CAMERATEST, by itself, creates a new CAMERATEST or raises the existing
%      singleton*.
%
%      H = CAMERATEST returns the handle to a new CAMERATEST or the handle to
%      the existing singleton*.
%
%      CAMERATEST('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CAMERATEST.M with the given input arguments.
%
%      CAMERATEST('Property','Value',...) creates a new CAMERATEST or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before CameraTest_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to CameraTest_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help CameraTest

% Last Modified by GUIDE v2.5 19-Aug-2019 21:39:44

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @CameraTest_OpeningFcn, ...
                   'gui_OutputFcn',  @CameraTest_OutputFcn, ...
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


% --- Executes just before CameraTest is made visible.
function CameraTest_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to CameraTest (see VARARGIN)

% Choose default command line output for CameraTest
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes CameraTest wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = CameraTest_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in Start.
function Start_Callback(hObject, eventdata, handles)
% hObject    handle to Start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.output =hObject;
axes(handles.cameraAxes);
vid =videoinput('macvideo','FaceTime HD Camera');
hImage=image(zeros(1280,720,3),'Parent',handles.cameraAxes);
preview(vid,hImage);

set(vid, 'ReturnedColorSpace', 'RGB');
global img 
img=getsnapshot(vid);

save('testframe.jpg', 'img');
disp('Frame saved to file ''testframe.jpg''');
axes(handles.imageAxes);
imshow(img);

% --- Executes on button press in Show.
function Show_Callback(hObject, eventdata, handles)
% hObject    handle to Show (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


