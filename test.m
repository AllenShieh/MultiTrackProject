%% GUI for the software 
% Last updated date: 2015. 12. 30
% Copyright (C) 2015 Yao Xie
% All rights reserved.

% Course project for Software Engineering and Computer Graphics.
% Done by Jiajun Jin, Zhaoxiong Yang, Yupeng Zhang and Yao Xie.
% Thank the author for providing the algorithm.
%%

function varargout = test(varargin)
% TEST MATLAB code for test.fig
%      TEST, by itself, creates a new TEST or raises the existing
%      singleton*.
%
%      H = TEST returns the handle to a new TEST or the handle to
%      the existing singleton*.
%
%      TEST('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TEST.M with the given input arguments.
%
%      TEST('Property','Value',...) creates a new TEST or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before test_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to test_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help test

% Last Modified by GUIDE v2.5 28-Dec-2015 16:08:02

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @test_OpeningFcn, ...
                   'gui_OutputFcn',  @test_OutputFcn, ...
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


% --- Executes just before test is made visible.
function test_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to test (see VARARGIN)

% Choose default command line output for test
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes test wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = test_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% hObject handle to pushbutton1 (see GCBO)
% eventdata reserved - to be defined in a future version of MATLAB
% handles structure with handles and user data (see GUIDATA)
global num_of_frames;
for q=1:num_of_frames
    filename = strcat('.\Results\output\Tracking_Results_',num2str(q,'%04d'));
    filename = strcat(filename,'.jpg');
    axes1=imread(filename); 
    imshow(axes1);
    pause(0.01);
end

function update(hObject, eventdata, handles)
global dynamic;
global process_cur;
global drawing_cur;
global cutting_cur;
global detect_cur;
global status;
if(status==1)
    set(handles.text3,'string',[sprintf('Ŀǰ���ڴ�����%d֡',process_cur)]);
end
if(status==2)
    set(handles.text3,'string',[sprintf('Ŀǰ���ڻ��Ƶ�%d֡',drawing_cur)]);
    set(handles.text2,'string',[sprintf('��⵽��%d����',dynamic)]);
end
if(status==3)
    set(handles.text3,'string',[sprintf('��ɴ���')]);
end
if(status==4)
    set(handles.text3,'string',[sprintf('���ڲ��Ƶ�%d֡',cutting_cur)]);
end
if(status==5)
    set(handles.text3,'string',[sprintf('���ڼ���%d֡',detect_cur)]);
end
if(status==6)
    set(handles.text3,'string',[sprintf('ѡ����Ƶ')]);
end
if(status==7)
    set(handles.text3,'string',[sprintf('���Ԥ����')]);
end
pause(0);

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global status;
status = 0;
set(handles.text3,'string','��ȡ�����ļ�');
global dynamic;
dynamic = 0;
set(handles.text2,'string','��̬��������');
set(handles.text1,'string','������������');

result = tracking_demo();
set(handles.text1,'string',[sprintf('�ܹ���⵽%d����',result)]);
set(handles.text3,'string','done');


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
t=timer('TimerFcn',{@update,handles},'ExecutionMode', 'fixedRate', 'Period', 0.1);
start(t);
global status;
status = 6;
mkdir('Sequences\source');
mkdir('Det');
mkdir('Results\output');
videofilename=uigetfile('*.*','open');
global num_of_frames;
num_of_frames = camera(videofilename);
detecting();
global img_path;
img_path = '.\Sequences\source\';
global img_List;
img_List = dir(strcat(img_path,'*.png'));
disp(sprintf('select done'));
status = 7;


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
disp(sprintf('play the original video'));
global img_path;
global num_of_frames;
for q=1:num_of_frames
    filename = strcat(img_path,num2str(q,'%04d'));
    filename = strcat(filename,'.png');
    disp(filename);
    axes1=imread(filename); 
    imshow(axes1);
    pause(0.01);
end