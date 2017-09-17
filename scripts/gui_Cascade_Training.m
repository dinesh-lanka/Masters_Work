function varargout = gui_Cascade_Training(varargin)
% GUI_CASCADE_TRAINING MATLAB code for gui_Cascade_Training.fig
%      GUI_CASCADE_TRAINING, by itself, creates a new GUI_CASCADE_TRAINING or raises the existing
%      singleton*.
%
%      H = GUI_CASCADE_TRAINING returns the handle to a new GUI_CASCADE_TRAINING or the handle to
%      the existing singleton*.
%
%      GUI_CASCADE_TRAINING('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_CASCADE_TRAINING.M with the given input arguments.
%
%      GUI_CASCADE_TRAINING('Property','Value',...) creates a new GUI_CASCADE_TRAINING or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_Cascade_Training_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_Cascade_Training_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui_Cascade_Training

% Last Modified by GUIDE v2.5 17-Sep-2017 22:04:07

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @gui_Cascade_Training_OpeningFcn, ...
    'gui_OutputFcn',  @gui_Cascade_Training_OutputFcn, ...
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


% --- Executes just before gui_Cascade_Training is made visible.
function gui_Cascade_Training_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui_Cascade_Training (see VARARGIN)

% Choose default command line output for gui_Cascade_Training
handles.output = hObject;
handles.value_edit_image_folder_path = cd;
set(handles.edit_image_folder_path,'string',handles.value_edit_image_folder_path);
handles.value_edit_progress_bar = 'Cascade Trainer started';
set(handles.edit_progress_bar,'string',handles.value_edit_progress_bar);
handles.image_type = 'bmp';
handles.value_edit_destination_folder = cd;
set(handles.edit_destination_folder,'string',handles.value_edit_destination_folder);
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui_Cascade_Training wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui_Cascade_Training_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function edit_image_folder_path_Callback(hObject, eventdata, handles)
% hObject    handle to edit_image_folder_path (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_image_folder_path as text
%        str2double(get(hObject,'String')) returns contents of edit_image_folder_path as a double
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit_image_folder_path_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_image_folder_path (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function folder_name = setFolderPath
folder_name = uigetdir;
if folder_name
    variable = folder_name;
else
    variable = cd;
end

% --- Executes on button press in pushbutton_select_folder_path.
function pushbutton_select_folder_path_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_select_folder_path (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.value_edit_image_folder_path = setFolderPath;
set(handles.edit_image_folder_path,'string',handles.value_edit_image_folder_path);
handles.value_edit_progress_bar = 'Images directory selected';
set(handles.edit_progress_bar,'string',handles.value_edit_progress_bar);
handles.value_edit_imageList_filename = 'Enter a filename for image list';
set(handles.edit_imageList_filename,'string',handles.value_edit_imageList_filename);
guidata(hObject, handles);



function edit_progress_bar_Callback(hObject, eventdata, handles)
% hObject    handle to edit_progress_bar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_progress_bar as text
%        str2double(get(hObject,'String')) returns contents of edit_progress_bar as a double
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit_progress_bar_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_progress_bar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu_select_image_type.
function popupmenu_select_image_type_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_select_image_type (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_select_image_type contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_select_image_type
contents = cellstr(get(hObject,'String'));
handles.image_type = contents{get(hObject,'Value')};
handles.value_edit_progress_bar = 'Image type selected';
set(handles.edit_progress_bar,'string',handles.value_edit_progress_bar);

guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function popupmenu_select_image_type_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_select_image_type (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_destination_folder_Callback(hObject, eventdata, handles)
% hObject    handle to edit_destination_folder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_destination_folder as text
%        str2double(get(hObject,'String')) returns contents of edit_destination_folder as a double


% --- Executes during object creation, after setting all properties.
function edit_destination_folder_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_destination_folder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_select_destination_folder_path.
function pushbutton_select_destination_folder_path_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_select_destination_folder_path (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.value_edit_destination_folder = setFolderPath;
set(handles.edit_destination_folder,'string',handles.value_edit_destination_folder);
handles.value_edit_progress_bar = 'Destination directory selected';
set(handles.edit_progress_bar,'string',handles.value_edit_progress_bar);
guidata(hObject,handles);



function edit_imageList_filename_Callback(hObject, eventdata, handles)
% hObject    handle to edit_imageList_filename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_imageList_filename as text
%        str2double(get(hObject,'String')) returns contents of edit_imageList_filename as a double
handles.value_edit_imageList_filename = get(hObject,'String');
set(handles.edit_imageList_filename,'string',handles.value_edit_imageList_filename);
handles.value_edit_progress_bar = 'Filename entered';
set(handles.edit_progress_bar,'string',handles.value_edit_progress_bar);
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function edit_imageList_filename_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_imageList_filename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_create_image_list.
function pushbutton_create_image_list_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_create_image_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
createImageList(handles.value_edit_image_folder_path,handles.image_type,handles.value_edit_destination_folder,handles.value_edit_imageList_filename);
handles.value_edit_image_list_absolute_path = fullfile([handles.value_edit_destination_folder '\' handles.value_edit_imageList_filename '.mat']);
set(handles.edit_image_list_absolute_path,'string',handles.value_edit_image_list_absolute_path);
handles.value_edit_progress_bar = 'Image List created and saved';
set(handles.edit_progress_bar,'string',handles.value_edit_progress_bar);
guidata(hObject,handles);



function edit_image_list_absolute_path_Callback(hObject, eventdata, handles)
% hObject    handle to edit_image_list_absolute_path (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_image_list_absolute_path as text
%        str2double(get(hObject,'String')) returns contents of edit_image_list_absolute_path as a double


% --- Executes during object creation, after setting all properties.
function edit_image_list_absolute_path_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_image_list_absolute_path (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_background_images_folder_path_Callback(hObject, eventdata, handles)
% hObject    handle to edit_background_images_folder_path (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_background_images_folder_path as text
%        str2double(get(hObject,'String')) returns contents of edit_background_images_folder_path as a double


% --- Executes during object creation, after setting all properties.
function edit_background_images_folder_path_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_background_images_folder_path (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_select_background_images.
function pushbutton_select_background_images_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_select_background_images (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.value_edit_background_images_folder_path = setFolderPath;
set(handles.edit_background_images_folder_path,'string',handles.value_edit_background_images_folder_path);
handles.value_edit_progress_bar = 'Background images directory selected';
set(handles.edit_progress_bar,'string',handles.value_edit_progress_bar);
guidata(hObject,handles);



function edit_classifier_destination_path_Callback(hObject, eventdata, handles)
% hObject    handle to edit_classifier_destination_path (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_classifier_destination_path as text
%        str2double(get(hObject,'String')) returns contents of edit_classifier_destination_path as a double


% --- Executes during object creation, after setting all properties.
function edit_classifier_destination_path_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_classifier_destination_path (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_select_classifier_destination.
function pushbutton_select_classifier_destination_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_select_classifier_destination (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.value_edit_classifier_destination_path = setFolderPath;
set(handles.edit_classifier_destination_path,'string',handles.value_edit_classifier_destination_path);
handles.value_edit_progress_bar = 'Destination directory for writing classifier file selected';
set(handles.edit_progress_bar,'string',handles.value_edit_progress_bar);
guidata(hObject,handles);


% --- Executes on button press in pushbutton_initiate_cascade_training.
function pushbutton_initiate_cascade_training_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_initiate_cascade_training (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.value_edit_progress_bar = 'Classifier training started. This may take upto several hours depending on training parameters.';
set(handles.edit_progress_bar,'string',handles.value_edit_progress_bar);
cascadeTraining(handles.value_edit_image_list_absolute_path,handles.value_edit_classifier_destination_path,handles.value_edit_image_folder_path,handles.value_edit_background_images_folder_path,handles.value_edit_number_of_training_stages,handles.value_edit_classifier_filename,handles.value_edit_negative_samples_factor);
handles.value_edit_progress_bar = 'Classifier training completed. Classifier generated and saved';
set(handles.edit_progress_bar,'string',handles.value_edit_progress_bar);
guidata(hObject,handles);



function edit_number_of_training_stages_Callback(hObject, eventdata, handles)
% hObject    handle to edit_number_of_training_stages (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_number_of_training_stages as text
%        str2double(get(hObject,'String')) returns contents of edit_number_of_training_stages as a double
handles.value_edit_number_of_training_stages = str2double(get(hObject,'String'));
set(handles.edit_number_of_training_stages,'string',handles.value_edit_number_of_training_stages);
handles.value_edit_progress_bar = 'Number of training stages selected';
set(handles.edit_progress_bar,'string',handles.value_edit_progress_bar);
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function edit_number_of_training_stages_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_number_of_training_stages (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_classifier_filename_Callback(hObject, eventdata, handles)
% hObject    handle to edit_classifier_filename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_classifier_filename as text
%        str2double(get(hObject,'String')) returns contents of edit_classifier_filename as a double
handles.value_edit_classifier_filename = get(hObject,'String');
set(handles.edit_classifier_filename,'string',handles.value_edit_classifier_filename);
handles.value_edit_progress_bar = 'Classifier name selected';
set(handles.edit_progress_bar,'string',handles.value_edit_progress_bar);
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function edit_classifier_filename_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_classifier_filename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_negative_samples_factor_Callback(hObject, eventdata, handles)
% hObject    handle to edit_negative_samples_factor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_negative_samples_factor as text
%        str2double(get(hObject,'String')) returns contents of edit_negative_samples_factor as a double
handles.value_edit_negative_samples_factor = str2double(get(hObject,'String'));
set(handles.edit_negative_samples_factor,'string',handles.value_edit_negative_samples_factor);
handles.value_edit_progress_bar = 'Number of positive to background images to consider during training selected';
set(handles.edit_progress_bar,'string',handles.value_edit_progress_bar);
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function edit_negative_samples_factor_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_negative_samples_factor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end