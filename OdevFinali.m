function varargout = OdevFinali(varargin)
% ODEVFINALI MATLAB code for OdevFinali.fig
%      ODEVFINALI, by itself, creates a new ODEVFINALI or raises the existing
%      singleton*.
%
%      H = ODEVFINALI returns the handle to a new ODEVFINALI or the handle to
%      the existing singleton*.
%
%      ODEVFINALI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ODEVFINALI.M with the given input arguments.
%
%      ODEVFINALI('Property','Value',...) creates a new ODEVFINALI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before OdevFinali_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to OdevFinali_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help OdevFinali

% Last Modified by GUIDE v2.5 27-Dec-2021 23:09:42

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @OdevFinali_OpeningFcn, ...
                   'gui_OutputFcn',  @OdevFinali_OutputFcn, ...
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


% --- Executes just before OdevFinali is made visible.
function OdevFinali_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to OdevFinali (see VARARGIN)

% Choose default command line output for OdevFinali
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes OdevFinali wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = OdevFinali_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
global image;
global adres;
axes(handles.axes1);
[adres, uzanisi] = uigetfile('.PNG');
image = imread(adres);
imshow(image);

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
global image
axes(handles.axes2)
image= imnoise(image,'salt & pepper',0.2);
imshow(image);

% --- Executes on button press in pushbutton3.
function pushbutton4_Callback(hObject, eventdata, handles)
global TRes
global image
axes(handles.axes3);
r=medfilt2(image(:, :, 1),[3 3]);
g=medfilt2(image(:, :, 2),[3 3]);
b=medfilt2(image(:, :, 3),[3 3]);
TRes=cat (3,r,g,b);
imshow(TRes);


% --- Executes on button press in pushbutton4.
function pushbutton5_Callback(hObject, eventdata, handles)
global TRes


Gres=rgb2gray(TRes);%resmi griye çevirdik
axes(handles.axes4);imshow(Gres)
esik= imbinarize(Gres,0.37);%resmin eşik değerilerini belirleyerek siyah beyaz yapık
axes(handles.axes5);imshow(esik)

esik1 = bwareaopen(esik,1000); % gereksiz ayrıntıları kaldırdık
axes(handles.axes6);imshow(esik1)



[B,L] = bwboundaries(esik1,'noholes'),disp(B)
axes(handles.axes7);imshow(label2rgb(L,@jet,[.5 .5 .5 ]));%random renk atadık  



hold on
for k=1 :length(B)
    boundary=B{k}
    plot(boundary(:,2), boundary(:,1),'W','LineWidth',2)
end
fprintf('nesneler sayıldı ve işaretlendi=%d\n',k)

starts=regionprops(L,'Area','Centroid')

for k=1:length(B)
    boundary=B{k}
    delsta_sq   = diff(boundary).^2
    perimeter= sum(sqrt(sum(delsta_sq,2)));
    
    area=starts(k).Area


    metric=4*pi*area/perimeter^2


    metric_sitring=sprintf('%2.2f',metric)
    centroid=starts(k).Centroid


   
    if metric> 0.88
        text(centroid(1),centroid(2),"Daire ");

         elseif (metric<=.70) && (metric>=.68)
        text(centroid(1),centroid(2),'Dikdörtgen');
            
     elseif (metric<=.80) && (metric>=.78)
        text(centroid(1),centroid(2),'Altıgen');
            
     elseif (metric<=.779) && (metric>=.70)
        text(centroid(1),centroid(2),'Beşgen');
   

    elseif (metric<=0.60) && (metric>=0.40)
        text(centroid(1),centroid(2),'Üçgen');    
    else
        text(centroid(1),centroid(2),'Belirlenemeyeb şekil')
    end

end
fprintf('nesneler sayıldı ve işaretlendi=%d\n',k)


% --- Executes on button press in pushbutton5.
function pushbutton3_Callback(hObject, eventdata, handles)
axes(handles.axes7);
cla('reset');



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double


% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double


% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit7_Callback(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit7 as text
%        str2double(get(hObject,'String')) returns contents of edit7 as a double


% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
