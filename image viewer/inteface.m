function varargout = inteface(varargin)
% INTEFACE MATLAB code for inteface.fig
%      INTEFACE, by itself, creates a new INTEFACE or raises the existing
%      singleton*.
%
%      H = INTEFACE returns the handle to a new INTEFACE or the handle to
%      the existing singleton*.
%
%      INTEFACE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in INTEFACE.M with the given input arguments.
%
%      INTEFACE('Property','Value',...) creates a new INTEFACE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before inteface_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to inteface_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help inteface

% Last Modified by GUIDE v2.5 18-Feb-2013 12:43:36

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @inteface_OpeningFcn, ...
                   'gui_OutputFcn',  @inteface_OutputFcn, ...
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


% --- Executes just before inteface is made visible.
function inteface_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to inteface (see VARARGIN)

% Choose default command line output for inteface
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes inteface wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = inteface_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes when figure1 is resized.
function figure1_ResizeFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called



% Hint: place code in OpeningFcn to populate axes1
 
% --- Executes during object creation, after setting all properties.
function figure1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function toolbar_gradient_CreateFcn(hObject, eventdata, handles)
% hObject    handle to toolbar_gradient (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --------------------------------------------------------------------
function uipushtool1_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uipushtool1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[filename, pathname]=uigetfile({ '*.jpg;*.png;*.gif', 'Image files';
                            '*', 'all files'}, 'Select an image ...' );

fullpath = strcat(pathname,filename);
handles.original_image = rgb2gray(imread(fullpath));
ih = imshow(handles.original_image, 'Parent', handles.plot_image);
%Now add an event handler to the image on click
set(ih,'buttonDownFcn', { @plot_image_ButtonDownFcn, handles.original_image }  );
set(handles.apply_btn,'CallBack', { @apply_btn_Callback, ih,handles.original_image });

% --- Executes on mouse press over axes background.
function plot_image_ButtonDownFcn(hObject, eventdata, original_img)
% hObject    handle to plot_image (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

displacement = 50;
threshold = 10;

[x, y] = ginput(1);
y = ceil(y);
x = ceil(x);
%if it's too close to the boundary, just make it = displacement + 1
x(x<50) = displacement + 1
y(y<50) = displacement + 1


min_threshold = original_img(y, x);
%max_threshold = 255;

%calculate the range for filter and image 
rangeY = y - displacement : y + displacement;
rangeX = x - displacement : x + displacement;
filterRangeX = rangeX - x + displacement + 1
filterRangeY = rangeY - y + displacement + 1

filter( filterRangeY, filterRangeX) = ...
                 original_img( rangeY, rangeX ) >= min_threshold 
original_img( rangeY, rangeX ) = double(original_img( rangeY, rangeX )) .* double(filter);
handles.plot = hObject
set(hObject, 'CData', original_img);
    
        


% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1


% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in apply_btn.
function apply_btn_Callback(hObject, eventdata, ih, original_image)
% hObject    handle to apply_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
img = niblack(original_image);
set(ih, 'CData',  img);
