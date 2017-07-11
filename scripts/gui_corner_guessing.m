function varargout = gui_corner_guessing(varargin)
% GUI_CORNER_GUESSING MATLAB code for gui_corner_guessing.fig
%      GUI_CORNER_GUESSING, by itself, creates a new GUI_CORNER_GUESSING or raises the existing
%      singleton*.
%
%      H = GUI_CORNER_GUESSING returns the handle to a new GUI_CORNER_GUESSING or the handle to
%      the existing singleton*.
%
%      GUI_CORNER_GUESSING('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_CORNER_GUESSING.M with the given input arguments.
%
%      GUI_CORNER_GUESSING('Property','Value',...) creates a new GUI_CORNER_GUESSING or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_corner_guessing_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_corner_guessing_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui_corner_guessing

% Last Modified by GUIDE v2.5 11-Jul-2017 15:23:24

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_corner_guessing_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_corner_guessing_OutputFcn, ...
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


% --- Executes just before gui_corner_guessing is made visible.
function gui_corner_guessing_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui_corner_guessing (see VARARGIN)

% Choose default command line output for gui_corner_guessing
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui_corner_guessing wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui_corner_guessing_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes when figure1 is resized.
function figure1_SizeChangedFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in cascadeFilePath.
function cascadeFilePath_Callback(hObject, eventdata, handles)
% hObject    handle to cascadeFilePath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns cascadeFilePath contents as cell array
%        contents{get(hObject,'Value')} returns selected item from cascadeFilePath


% --- Executes during object creation, after setting all properties.
function cascadeFilePath_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cascadeFilePath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function text3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
