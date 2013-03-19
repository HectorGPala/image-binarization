

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

    % Last Modified by GUIDE v2.5 19-Mar-2013 07:03:28

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
end

% --- Executes just before inteface is made visible.
function inteface_OpeningFcn(hObject, ~, handles, varargin)
    % This function has no output args, see OutputFcn.
    % hObject    handle to figure
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    % varargin   command line arguments to inteface (see VARARGIN)

    % Choose default command line output for inteface
    handles.output = hObject;
    
    %set the handles original image
    handles.original_image = 0;
    
    % Update handles structure
    guidata(hObject, handles);

    % UIWAIT makes inteface wait for user response (see UIRESUME)
    % uiwait(handles.figure1);

end
% --- Outputs from this function are returned to the command line.
function varargout = inteface_OutputFcn(~, ~, handles) 
    % varargout  cell array for returning output args (see VARARGOUT);
    % hObject    handle to figure
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Get default command line output from handles structure
    varargout{1} = handles.output;

end
% --------------------------------------------------------------------
function open_toolbar_ClickedCallback(hObject, ~, handles)
    % hObject    handle to open_toolbar (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    %allow the user to select a file
    [filename, pathname]=uigetfile({ '*.jpg;*.png;*.gif', 'Image files';
                                '*', 'all files'}, 'Select an image ...' );
    fullpath = strcat(pathname,filename);

    %load the image and show it in the axis
    handles.original_image = rgb2gray(imread(fullpath));
    %save_toolbar the value in the array
    guidata(hObject,handles)
    
    
    ih = imshow(handles.original_image, 'Parent', handles.plot_image);

    %Now add an event handler to the image on click
    set(ih,'buttonDownFcn', { @plot_image_ButtonDownFcn, handles, handles.original_image}  );
    set(handles.apply_btn,'CallBack', { @apply_btn_Callback, handles, handles.original_image });
end

%saving a processed image %%


% --------------------------------------------------------------------
function save_toolbar_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to save_toolbar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    %allow the user to select a file
    [filename, pathname]=uiputfile({  '*.png', 'PNG';'*.jpg', 'Jpeg'; 'gif', 'GIF';
                                    '*', 'all files'}, 'Save the processed image ...' );
    fullpath = strcat(pathname,filename);

    %load the image from the axis
    X = getimage(handles.plot_processed);

    imwrite(X, fullpath);


end


% --- Executes on mouse press over axes background.
function plot_image_ButtonDownFcn(hObject, ~, handles, original_img)

    %%this method applies the 'flood fill' algorithm on the image
    %%using a non-recursive approach, and a queue to keep track
    %%of the "neighbour pixels"
    
    %first we need to get some options from the radio buttons
    
    %change darker pixels to white, or lighter pixels to dark?
    darkerToWhite = get(handles.radiobtn_darktowhite,'value');
    lighterToblack = get(handles.radiobtn_lighttoblack,'value');
    
    %consider neighbouring 4 pixels or 8 pixels?
    pixelmode_8n = get(handles.radiobtn_8n,'value');
    
    seed = ginput(1);
    midY = ceil(seed(2));
    midX = ceil(seed(1));

    img = cell_propagate(original_img, seed , pixelmode_8n, darkerToWhite);

   imshow(img, 'Parent', handles.plot_processed);
end

% --------------------------------------------------------------------
function groundtruth_toolbar_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to groundtruth_toolbar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    %allow the user to select a file
    [filename, pathname]=uigetfile({ '*.tiff', 'Image files';
                                '*', 'all files'}, 'Select an image ...' );
    fullpath = strcat(pathname,filename);
    
    %load the image and show it in the axis
    original_image = imread(fullpath);
    ih = imshow(original_image, 'Parent', handles.plot_groundTruth);

end
% --------------------------------------------------------------------
function pointThresholdTool_ClickedCallback(~, ~, handles)
% hObject    handle to pointThresholdTool (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    % hObject    handle to plot_image (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)


    [x, y] = ginput(1);
    y = ceil(y);
    x = ceil(x);
    

    min_threshold = handles.original_image(y, x);
    %max_threshold = 255;

    %calculate the range for filter and image 
    [sizeY, sizeX] = size(handles.original_image);
    rangeY = 1 : sizeY;
    rangeX = 1 : sizeX;
    
    %apply the filter
    filter( rangeY, rangeX) = ...
                     handles.original_image( rangeY, rangeX ) >= min_threshold ;
    handles.original_image( rangeY, rangeX ) = double(handles.original_image( rangeY, rangeX )) .* double(filter);

     %now show the image
    
     %%get the limits before doing an imshow
    limits(2,:) = get(handles.plot_processed,'YLim');
    limits(1,:) = get(handles.plot_processed,'XLim');
 
    %do an imshow
    imshow(handles.original_image, 'Parent', handles.plot_processed);
    
    %restore the limits
	set(handles.plot_processed, 'YLim', limits(2,:));
	set(handles.plot_processed, 'XLim', limits(1,:));
    
end



% --- Executes on button press in filter_apply_btn.
function filter_apply_btn_Callback(hObject, eventdata, handles)
% hObject    handle to filter_apply_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    selected_item = get(handles.filter_lstbox,'value');

    orig_img = handles.original_image;


    if (selected_item == 1) %niblack
        i = edge(orig_img,'canny');
        %orig_img(i) = 255;
    elseif (selected_item == 2)
        i = edge(orig_img);
        %orig_img(i) = 255;
    elseif (selected_item ==3)
        i = corner(orig_img);
        %orig_img(i(:,2), i(:,1)) = 255;
    end
    imshow(i==0, 'Parent', handles.plot_processed);  
    
    handles.seed_points = i;
    %save_toolbar the value in the array
    guidata(hObject,handles)
end


% --- Executes on button press in use_as_seed_points_btn.
function use_as_seed_points_btn_Callback(hObject, eventdata, handles)
    % hObject    handle to use_as_seed_points_btn (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    [sp1, sp2] = find(handles.seed_points)
    
    len = size(sp1);

    pixelmode_8n = 1;
    darkerToWhite = 1;
  
    img = handles.original_image;
sp1(1:10)
sp2(1:10)
    for (i = 1:len)
        img = cell_propagate(img, [ sp1(i), sp2(i)] , pixelmode_8n, darkerToWhite);
        imshow( img, 'Parent', handles.plot_processed);
    end
    

end

