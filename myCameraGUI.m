function varargout = MyCameraGUI(varargin)
% MYCAMERAGUI MATLAB code for myCameraGUI.fig
%      MYCAMERAGUI, by itself, creates a new MYCAMERAGUI or raises the existing
%      singleton*.
%
%      H = MYCAMERAGUI returns the handle to a new MYCAMERAGUI or the handle to
%      the existing singleton*.
%
%      MYCAMERAGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MYCAMERAGUI.M with the given input arguments.
%
%      MYCAMERAGUI('Property','Value',...) creates a new MYCAMERAGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before myCameraGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to myCameraGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help myCameraGUI

% Last Modified by GUIDE v2.5 16-Aug-2019 15:07:42

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @MyCameraGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @MyCameraGUI_OutputFcn, ...
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


% --- Executes just before myCameraGUI is made visible.
function MyCameraGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to myCameraGUI (see VARARGIN)

% Choose default command line output for myCameraGUI

% Create video object
%   Putting the object into manual trigger mode and then
%   starting the object will make GETSNAPSHOT return faster
%   since the connection to the camera will already have
%   been established.
handles.video = videoinput('macvideo', 1);
set(handles.video,'TimerPeriod', 0.05, ...
      'TimerFcn',['if(~isempty(gco)),'...
                      'handles=guidata(gcf);'...                                 % Update handles
                      'image(getsnapshot(handles.video));'...                    % Get picture using GETSNAPSHOT and put it into axes using IMAGE
                      'set(handles.cameraAxes,''ytick'',[],''xtick'',[]),'...    % Remove tickmarks and labels that are inserted when using IMAGE
                  'else '...
                      'delete(imaqfind);'...                                     % Clean up - delete any image acquisition objects
                  'end']);
triggerconfig(handles.video,'manual');
handles.video.FramesPerTrigger = Inf; % Capture frames until we manually stop it

% Update handles structure
% UIWAIT makes myCameraGUI wait for user response (see UIRESUME)
%uiwait(handles.MyCameraGUI);



% UIWAIT makes myCameraGUI wait for user response (see UIRESUME)
% uiwait(handles.MyCameraGUI);

% --- Outputs from this function are returned to the command line.
% --- Outputs from this function are returned to the command line.
function varargout = MyCameraGUI_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Get default command line output from handles structure
handles.output = hObject;
varargout{1} = handles.output;

% --- Executes on button press in pushbutton2.
function StartStopCamera_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if strcmp(get(handles.pushbutton2,'String'),'Start Acquisition')
      % Camera is not acquiring. Change button string and start acquisition.
      set(handles.pushbutton2,'String','Stop Acquisition');
      trigger(handles.video);
else
      % Camera is acquiring. Stop acquisition, save video data,
      % and change button string.
      stop(handles.video);
      disp('Saving captured video...');
      videodata = getdata(handles.video);
      save('testvideo.mat', 'videodata');
      disp('Video saved to file ''testvideo.mat''');
      start(handles.video); % Restart the camera
      set(handles.pushbutton2,'String','Start Acquisition');
end


% --- Executes on button press in CaptureImage.
function CaptureImage_Callback(hObject, eventdata, handles)
% hObject    handle to CaptureImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

frame = get(get(handles.cameraAxes,'children'),'cdata'); % The current displayed frame
save('testframe.mat', 'frame');
disp('Frame saved to file ''testframe.mat''');


function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to startAcquisition (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Start/Stop acquisition
if strcmp(get(handles.pushbutton2,'String'),'Start Acquisition')
      % Camera is not acquiring. Change button string and start acquisition.
      set(handles.pushbutton2,'String','Stop Acquisition');
      trigger(handles.video);
else
      % Camera is acquiring. Stop acquisition, save video data,
      % and change button string.
      stop(handles.video);
      disp('Saving captured video...');
      videodata = getdata(handles.video);
      save('testvideo.mat', 'videodata');
      disp('Video saved to file ''testvideo.mat''');
      start(handles.video); % Restart the camera
      set(handles.pushbutton2,'String','Start Acquisition');
end

function MyCameraGUI_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to myCameraGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: delete(hObject) closes the figure
delete(hObject);
delete(imaqfind);
