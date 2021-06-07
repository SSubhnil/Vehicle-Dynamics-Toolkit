function varargout = VHSIM(varargin)
% VHSIM M-file for VHSIM.fig
%      VHSIM, by itself, creates a new VHSIM or raises the existing
%      singleton*.
%
%      H = VHSIM returns the handle to a new VHSIM or the handle to
%      the existing singleton*.
%
%      VHSIM('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in VHSIM.M with the given input arguments.
%
%      VHSIM('Property','Value',...) creates a new VHSIM or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before VHSIM_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to VHSIM_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help VHSIM

% Last Modified by GUIDE v2.5 08-Dec-2017 16:32:48

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @VHSIM_OpeningFcn, ...
                   'gui_OutputFcn',  @VHSIM_OutputFcn, ...
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

% --- Executes just before VHSIM is made visible.
function VHSIM_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to VHSIM (see VARARGIN)

% Choose default command line output for VHSIM
handles.output = hObject;
% Update handles structure
movegui(hObject,'center')
guidata(hObject, handles);
wf = str2num(get(handles.WF,'string'));
wr = str2num(get(handles.WR,'string'));
wt = wf+wr;
set(handles.WTOTAL,'String',num2str(round(wt)))
set(handles.WPCF,'String',num2str(round(100*wf/(wt))))
make_xfers(hObject);

% UIWAIT makes VHSIM wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = VHSIM_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


function DF_Callback(hObject, eventdata, handles)
make_xfers(hObject);


function DF_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function DR_Callback(hObject, eventdata, handles)
make_xfers(hObject);


function DR_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function L_Callback(hObject, eventdata, handles)
make_xfers(hObject);


function L_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function WF_Callback(hObject, eventdata, handles)
wf = str2num(get(handles.WF,'string'));
wr = str2num(get(handles.WR,'string'));
wt = wf+wr;
set(handles.WTOTAL,'String',num2str(round(wt)))
set(handles.WPCF,'String',num2str(round(100*wf/(wt))))
make_xfers(hObject);


function WF_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function WR_Callback(hObject, eventdata, handles)
wf = str2num(get(handles.WF,'string'));
wr = str2num(get(handles.WR,'string'));
wt = wf+wr;
set(handles.WTOTAL,'String',num2str(round(wt)))
set(handles.WPCF,'String',num2str(round(100*wf/(wt))))
make_xfers(hObject);

function WR_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit6_Callback(hObject, eventdata, handles)


function edit6_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function SPEED_Callback(hObject, eventdata, handles)
make_xfers(hObject);


function SPEED_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function KP_Callback(hObject, eventdata, handles)
make_xfers(hObject);


function KP_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function PWR_Callback(hObject, eventdata, handles)
make_xfers(hObject);


function PWR_CreateFcn(hObject, eventdata, handles)

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function x=make_xfers(hObject)
handles=guidata(hObject);
handles.output = hObject;
df=str2double(get(handles.DF,'String'));
dr=str2double(get(handles.DR,'String'));
l =str2double(get(handles.L,'String'));
wf=str2double(get(handles.WF,'String'));
wr=str2double(get(handles.WR,'String'));
sr=str2double(get(handles.SR,'String'));
speed=str2double(get(handles.SPEED,'String'));
kp=str2double(get(handles.KP,'String'));
t =[0:.01:1.5];
tmid=1.5;
hw=1;
pwr=get(handles.PWR,'Value');
wb=l/1000 ;
a=wb*wr /(wf+wr); 
b=wb-a; 
u=speed*.2778; 
conv=9.806*180/pi;

% YAW VELOCITY TRANSFER FUNCTION Numerator factors:
	r2=0.;	
    r1=a*b*conv*u  / (df*wb);
    r0=a*b*conv^2 / (df*dr*wb);
    set (handles.R1,'String', num2str(r1));
    set (handles.R0,'String', num2str(r0));

% lateral acceleration numerator factors:
    a2=a*b^2*conv*u / (df*wb*(kp+1));
    a1=a*b^2*conv^2 / (df*dr*wb);
    a0=a*b*conv^2*u / (df*dr*wb);
    set (handles.A2,'String', num2str(a2));
    set (handles.A1,'String', num2str(a1));
    set (handles.A0,'String', num2str(a0));
% sideslip numerator factors:
    b2=0.;
    b1=a*b^2*conv / (df*wb*(kp+1));
    b0=a*b*conv*wb*(b*conv-dr*u^2)/(df*dr*wb^2*u);
    set (handles.B1,'String', num2str(b1));
    set (handles.B0,'String', num2str(b0));

% common denominator factors:
    d2=a*b*u / (kp+1);
    d1=a*b*conv*(a*(df+dr*(kp+1))+b*(df*(kp+1)+dr))/(df*dr*wb*(kp+1));
    d0=a*b*conv*(conv*wb+u^2*(df-dr)) / (df*dr*u*wb);
    set (handles.D2,'String', num2str(d2));
    set (handles.D1,'String', num2str(d1));
    set (handles.D0,'String', num2str(d0));      
   % inputs to transfer functions are radians of steer.
   % output of Ay is m/sec^2
   
rsys  = tf([   r1 r0],[d2 d1 d0]); 
rdsys = tf([r1 r0 0] ,[d2 d1 d0]);
bsys  = tf([   b1 b0],[d2 d1 d0]); 
bdsys = tf([b1 b0 0] ,[d2 d1 d0]);
aysys  =tf([a2 a1 a0],[d2 d1 d0]);  

assignin('base','rsys',rsys);
assignin('base','bsys',bsys);
assignin('base','aysys',aysys);

r_bw=bandwidth(rsys); 
b_bw=bandwidth(bsys); 
ay_bw=bandwidth(aysys);

[r_Wn r_Z]= damp(rsys);

set(handles.R_BW,'String',num2str(round(100*r_bw/(2*pi))/100))
set(handles.TAU_R,'String',num2str(2/r_bw))

set(handles.B_BW ,'String',num2str(round(100*b_bw/(2*pi))/100))
set(handles.TAU_B,'String',num2str(round(100*2/b_bw)/100))

set(handles.AY_BW,'String',num2str(round(100*ay_bw/(2*pi))/100))
set(handles.TAU_AY,'String',num2str(2/ay_bw))

[wn,z]=damp(rsys);
set(handles.WN,'String',num2str(wn(1)/2/pi))
set(handles.ZETA,'String',num2str(z(1)))

swamp=str2double(get(handles.SW_AMP,'String')); 

steer=(-2./pi*atan(abs((t-tmid)./hw).^pwr)+1.).*swamp; 
swavel=max(gradient(steer,.01));
set(handles.SWAVEL,'String',num2str(round(swavel)))
set(handles.ACKPG,'String',num2str(conv*wb/u^2))

axes(handles.steer_angle_axes)
plot(t,steer,'linewidth',2)
xlabel('Simulated Time (sec)')
ylabel('Steer Input Profile (deg)')
href(0)
vref(.5)
grid on

rd=lsim(rdsys,steer./sr,t);
axes(handles.yaw_accel_axes)
plot(t,rd,'linewidth',2)
% xlabel('Simulated Time (sec)')
ylabel('Yaw Accel. (deg/sec^2)')
href(0)
vref(.5)
a=gca;
set(a,'XTicklabel',[])
grid on
set(handles.RD_MAX,'String',num2str(round(max(rd))))
set(handles.RD_MIN,'String',num2str(round(min(rd))))

r=lsim(rsys,steer./sr,t);
axes(handles.yaw_vel_axes)
plot(t,r,'linewidth',2)
rpo= ((max(r)/r(end))-1)*100;
set(handles.R_PO,'String',num2str(rpo,3))
% xlabel('Simulated Time (sec)')
ylabel('Yaw Vel. (deg/sec)')
href(0)
vref(.5)
grid on
a=gca;
set(a,'XTicklabel',[])

bd=lsim(bdsys,steer./sr,t);

axes(handles.sideslip_vel_axes);
plot(t,bd,'linewidth',2)
% xlabel('Simulated Time (sec)')
ylabel('Sideslip Vel. (deg/sec)')
href(0)
vref(.5)
a=gca;
grid on
set(a,'XTicklabel',[])
set(handles.BD_MAX,'String',num2str(round(100*max(bd))/100))
set(handles.BD_MIN,'String',num2str(round(100*min(bd))/100))

beta=lsim(bsys,steer./sr,t);
axes(handles.sideslip_axes);
plot(t,beta,'linewidth',2)
% xlabel('Simulated Time (sec)')
ylabel('Sideslip Angle (deg)')
href(0)
vref(.5)
grid on
a=gca;
set(a,'XTicklabel',[])


ay=lsim(aysys,(steer/sr/57.295),t);
axes(handles.ay_axes);
plot(t,ay,'linewidth',2)
xlabel('Simulated Time (sec)')
ylabel('Lateral Accel. (m/sec^2)')
href(0)
vref(.5)
grid on

function ref= href(pt)
for n=1:length(pt)
    line(xlim,[pt(n) pt(n)],'color',[.01 .01 .01])
end

function ref= vref(pt)
for n=1:length(pt)
    line([pt(n) pt(n)],ylim,'color',[.01 .01 .01])
end


function SW_AMP_Callback(hObject, eventdata, handles)
make_xfers(hObject);


function SW_AMP_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




function SWA_D_Callback(hObject, eventdata, handles)
make_xfers(hObject);


function SWA_D_CreateFcn(hObject, eventdata, handles)

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end




function SWAVEL_Callback(hObject, eventdata, handles)

function SWAVEL_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




function WPCF_Callback(hObject, eventdata, handles)
pcf = str2num(get(handles.WPCF,'string'));
wt  = str2num(get(handles.WTOTAL,'String'));
set(handles.WF,'String',num2str(round(wt*pcf/100)))
set(handles.WR,'String',num2str(round(wt*(1-pcf/100))))
make_xfers(hObject);

function WPCF_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function WTOTAL_Callback(hObject, eventdata, handles)
wt = str2num(get(handles.WTOTAL,'string'));
pcf=str2num(get(handles.WPCF,'String'));
set(handles.WF,'String',num2str(round(wt*pcf/100)))
set(handles.WR,'String',num2str(round(wt*(1-pcf/100))))
make_xfers(hObject);

function WTOTAL_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


