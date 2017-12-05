function varargout = mapViewer(varargin)
% MAPVIEWER MATLAB code for mapViewer.fig
%      MAPVIEWER, by itself, creates a new MAPVIEWER or raises the existing
%      singleton*.
%
%      H = MAPVIEWER returns the handle to a new MAPVIEWER or the handle to
%      the existing singleton*.
%
%      MAPVIEWER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAPVIEWER.M with the given input arguments.
%
%      MAPVIEWER('Property','Value',...) creates a new MAPVIEWER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before mapViewer_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to mapViewer_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help mapViewer

% Last Modified by GUIDE v2.5 21-Aug-2017 16:09:56

%% Note: ------------------------------------------------------------------
%     Parsec maps are not aligned with those created by FFD. To use
%     previous data the following commands should be run.
%     
%     predMapP.fitness = predMapP.fitness'; % Or like it for other 2D maps
%     predMapP.genes = permute(predMapP.genes,[2 1 3]) % For correct genes
% 
% 
%% ------------------------------------------------------------------------


% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @mapViewer_OpeningFcn, ...
                   'gui_OutputFcn',  @mapViewer_OutputFcn, ...
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


% --- Executes just before mapViewer is made visible.
function mapViewer_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to mapViewer (see VARARGIN)
global xPos yPos nMaps
xPos = 1;
yPos = 1;
nMaps= ceil(length(varargin)/2);

% Choose default command line output for mapViewer
handles.output = hObject;

handles.map = varargin{1};
handles.d   = varargin{2};
handles.d.express = @(x) handles.d.express(squeeze(x)');

if nMaps > 1
    handles.map2 = varargin{3};
    handles.d2   = varargin{4};
    handles.d2.express = @(x) handles.d2.express(squeeze(x)');
end

% Show Map
axes(handles.axMap)
viewMap(-handles.map.fitness,handles.d,handles.map.edges);
title([handles.d.name ' Fitness']);
hold on;
handles.current = plot(1+handles.d.featureRes(2)-yPos, xPos,'ro','MarkerSize',16);

% Show Shape
axes(handles.axShape)
fPlot(handles.d.base.foil,'k--','LineWidth',3); hold on;
handles.foil = fPlot(handles.d.express(handles.map.genes(1,1,:)),'LineWidth',3);
grid on; axis equal; axis([0 1 -0.2 0.2]);
set(gca,'xticklabel',[],'yticklabel',[]);

if nMaps==2
    handles.foil2 = fPlot(handles.d2.express(handles.map2.genes(1,1,:)),'LineWidth',3);
    legend('North',{'Base', handles.d.name, handles.d2.name},'Location','SouthOutside','Orientation','Horizontal')
end




% Mouse Click
set(gcf, 'WindowButtonDownFcn', @getMousePositionOnImage);
set(gcf, 'Pointer', 'crosshair'); % Optional

% Key Press
set(gcf, 'KeyPressFcn', @keyPress);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes mapViewer wait for user response (see UIRESUME)
% uiwait(handles.figure1);



%---------------------------------------------------------%

function getMousePositionOnImage(src, ~)
    handles = guidata(src);
    global xPos yPos

    %cursorPoint = get(handles.axesImage, 'CurrentPoint');
    cursorPoint = get(handles.axMap, 'CurrentPoint');
    curX = cursorPoint(1,1);
    curY = cursorPoint(1,2);

    xLimits = get(handles.axMap, 'xlim');
    yLimits = get(handles.axMap, 'ylim');    

    if (curX > min(xLimits) && curX < max(xLimits) && curY > min(yLimits) && curY < max(yLimits))
        %disp(['Cursor coordinates are (' num2str(curX) ', ' num2str(curY) ').']);
        xPos = round(curX); yPos = round(curY);
        guiUpdate;

    else
        disp('Cursor is outside bounds of image.');
    end

        
function keyPress(src, e)
    handles = guidata(src);
    global xPos yPos
    
    switch e.Key
        case 'uparrow'
            yPos = yPos-1;
        case 'downarrow'
            yPos = yPos+1;
        case 'leftarrow'
            xPos = xPos-1;
        case 'rightarrow'
            xPos = xPos+1;       
            
        case 'w'
            yPos = yPos-1;
        case 's'
            yPos = yPos+1;
        case 'a'
            xPos = xPos-1;
        case 'd'
            xPos = xPos+1;
    end
    xPos(xPos<1) = 1; yPos(yPos<0) = 1; 
    xPos(xPos>handles.d.featureRes(1)) = handles.d.featureRes(1); 
    yPos(yPos>handles.d.featureRes(2)) = handles.d.featureRes(2); 
    
    guiUpdate;
    
% --- Outputs from this function are returned to the command line.
function varargout = mapViewer_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% % --- Executes on slider movement.
% function slider1_Callback(hObject, ~, handles)
%     % Get Position
%     global xPos yPos
%     axes(handles.axShape);
%     yPos = handles.d.featureRes(2)-get(hObject,'Value'); 
%     if yPos<1;yPos = 1;end;
%     
%     % Update GUI
%     guiUpdate
%     
% % --- Executes on slider movement.
% function slider2_Callback(hObject, ~, handles)
%     % Get Position
%     global xPos yPos
%     axes(handles.axShape);
%     xPos = get(hObject,'Value'); if xPos<1;xPos = 1;end;
%     
%     % GUI Update
%     guiUpdate
%     
%     

% % --- Executes during object creation, after setting all properties.
% function slider1_CreateFcn(hObject, ~, ~)
% % handles    empty - handles not created until after all CreateFcns called
% 
% % Hint: slider controls usually have a light gray background.
% if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
%     set(hObject,'BackgroundColor',[.9 .9 .9]);
% end
%     set(hObject,'Max',25);
%     set(hObject,'Min',0);
%     hObject.SliderStep = [1/25 1];
% 
% 
% % --- Executes during object creation, after setting all properties.
% function slider2_CreateFcn(hObject, ~, ~)
% % handles    empty - handles not created until after all CreateFcns called
% 
% % Hint: slider controls usually have a light gray background.
% if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
%     set(hObject,'BackgroundColor',[.9 .9 .9]);
% end
%     set(hObject,'Max',25);
%     set(hObject,'Min',0);
%     hObject.SliderStep = [1/25 1];

    
