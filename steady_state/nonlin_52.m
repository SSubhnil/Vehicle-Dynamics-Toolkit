function varargout = nonlin_52(varargin)
% NONLIN M-file for nonlin.fig
%      NONLIN, by itself, creates a new NONLIN or raises the existing
%      singleton*.
%
%      H = NONLIN returns the handle to a new NONLIN or the handle to
%      the existing singleton*.
%
%      NONLIN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in NONLIN.M with the given input arguments.
%
%      NONLIN('Property','Value',...) creates a new NONLIN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before nonlin_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to nonlin_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help nonlin

% Last Modified by GUIDE v2.5 03-Feb-2019 18:51:08

%Handy FSAE Car tire properties:
% FY=[-2.5309      0.28826      0.20599       1.5077 ]
% MZ= [0.0038654     0.015978      0.18495       3.0585 ]

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @nonlin_OpeningFcn, ...
                   'gui_OutputFcn',  @nonlin_OutputFcn, ...
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


% --- Executes just before nonlin is made visible.
function nonlin_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to nonlin (see VARARGIN)
% Choose default command line output for nonlin:
movegui(hObject,'center')
clc
handles.output = hObject;

% Fetch the panel parameters:

global W WDIST WF WR L SPEED TARGET A B IZZ
global R BETA AYG MAX_SPEED SPF SPR TOEIN CAMG CAM0 TLLTD%SPF=Spring rate front, SPR= spring rate rear

W         = str2double(get(handles.W,'String'))*9.806;
WDIST     = str2double(get(handles.WDIST,'String'))/100;
WR=WDIST*W;
WF=W-WR;
IZZ       = str2double(get(handles.IZZ,'String'));
L         = str2double(get(handles.L,'String'));
SPF       = str2double(get(handles.SPF,'String'));
SPR       = str2double(get(handles.SPR,'String'));
%TLLTD     = str2double(get(handles.TLLTD,'String'))/100;
%DELTAWT   = str2double(get(handles.DELTAWT,'String'))/100;
MAX_SPEED = str2double(get(handles.MAX_SPEED,'String'));
TARGET    = str2double(get(handles.TARGET,'String'));
TOEIN     = str2double(get(handles.TOEIN,'String'));
CAMG      = str2double(get(handles.CAMG,'String'));
CAM0      = str2double(get(handles.CAM0,'String'));
% now patch in the results for the default panel values:  CAPS are GLOBAL
WB=L/1000;
A=WB*WR/(WF+WR);
B=WB*WF/(WF+WR);
% IZZ=(WF+WR)*A*B 
% set(handles.IZZ,'String',num2str(IZZ))

% Update handles structure
guidata(hObject, handles);
fy_plot(hObject)
mz_plot(hObject)
iso4138(hObject)
% UIWAIT makes nonlin wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = nonlin_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

function WDIST_Callback(hObject, eventdata, handles)
global WDIST
WDIST=str2double(get(handles.WDIST,'String'));
if WDIST > 60 | WDIST < 40
    warndlg({'Outta Range:'})
end

% --- Executes during object creation, after setting all properties.
function WDIST_CreateFcn(hObject, eventdata, handles)
% hObject    handle to WDIST (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function W_Callback(hObject, eventdata, handles)
global WF WR IZZ L A B
W=str2double(get(handles.W,'String'));
if W > 600 | W < 10
    warndlg({'Parameter out of range:','Front Weight (kg)'},'Nonlin Input Error !');
else
    set(handles.IZZ,'String',num2str(IZZ))
    A=WB*WR/(WF+WR);
    B=WB*WF/(WF+WR);
    % Update handles structure
    guidata(hObject, handles);
end 

% --- Executes during object creation, after setting all properties.
function W_CreateFcn(hObject, eventdata, handles)
% hObject    handle to W (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in PU.
function PU_Callback(hObject, eventdata, handles)
% hObject    handle to PU (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global W WDIST WF WR L SPEED TARGET A B IZZ
global R BETA AYG MAX_SPEED SPF SPR TOEIN CAMG CAM0 TLLTD
W         = str2double(get(handles.W,'String'))*9.806;
WDIST     = str2double(get(handles.WDIST,'String'))/100;
WR=WDIST*W;
WF=W-WR;
IZZ       = str2double(get(handles.IZZ,'String'));
L         = str2double(get(handles.L,'String'));
SPF       = str2double(get(handles.SPF,'String'));
SPR       = str2double(get(handles.SPR,'String'));
%TLLTD     = str2double(get(handles.TLLTD,'String'))/100;
%DELTAWT   = str2double(get(handles.DELTAWT,'String'))/100;
MAX_SPEED = str2double(get(handles.MAX_SPEED,'String'));
TARGET    = str2double(get(handles.TARGET,'String'));
TOEIN     = str2double(get(handles.TOEIN,'String'));
CAMG      = str2double(get(handles.CAMG,'String'));
CAM0      = str2double(get(handles.CAM0,'String'));
% now patch in the results for the default panel values:  CAPS are GLOBAL
WB=L/1000;
A=WB*WR/(WF+WR);
B=WB*WF/(WF+WR);
guidata(hObject,handles);
iso4138(hObject)

function WF_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%{
function WR_Callback(hObject, eventdata, handles)
global WF WR IZZ L A B
WR=str2double(get(handles.WR,'String'));
if WR > 600 | WR < 10
    warndlg({'Parameter out of range:','Rear Weight (kg)'},'Nonlin Input Error !');
else
    IZZ=(WF+WR)*1;
    set(handles.IZZ,'String',num2str(IZZ))
    set(handles.WT','String',num2str(WF + WR))
    set(handles.TLLTD,'String',num2str(100*(WF/(WF+WR)),'%4.1f'))
    WB=L/1000;
    A=WB*WR/(WF+WR);
    B=WB*WF/(WF+WR);
    % Update handles structure
    guidata(hObject, handles);
    fy_plot(hObject)
    mz_plot(hObject)
    iso4138(hObject)
end

function WR_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%}

function L_Callback(hObject, eventdata, handles)
global L A B WF WR
L=str2double(get(handles.L,'String'));
if L > 3000 | L < 1000
   warndlg({'Parameter out of range:','Wheelbase (mm)'},'Nonlin Input Error !');
else
    WB=L/1000;
    A=WB*WR/(WF+WR);
    B=WB*WF/(WF+WR);
end

function L_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function IZZ_Callback(hObject, eventdata, handles)
global IZZ
IZZ=str2double(get(handles.IZZ,'String'));


function IZZ_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function CAMG_Callback(hObject, eventdata, handles)
global CAMG
CAMG=str2double(get(handles.L,'String'));
if CAMG<0 | CAMG>3
    warndlg({'Camber gain Outta range'});
end
% Hints: get(hObject,'String') returns contents of CAMG as text
%        str2double(get(hObject,'String')) returns contents of CAMG as a double


% --- Executes during object creation, after setting all properties.
function CAMG_CreateFcn(hObject, eventdata, handles)
% hObject    handle to CAMG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function CAM0_Callback(hObject, eventdata, handles)
global CAM0
CAM0=str2double(get(handles.CAM0,'String'));
if CAM0<-2 | CAM0>2
    warndlg({'Initial Camber outta range'})
end

% --- Executes during object creation, after setting all properties.
function CAM0_CreateFcn(hObject, eventdata, handles)
% hObject    handle to CAM0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function SPF_Callback(hObject, eventdata, handles)
global SPF
SPF=str2double(get(handles.SPF,'String'));
if SPF<20 | SPF>100
    warndlg({'Stiffness outta range'});
end
    % hObject    handle to SPF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of SPF as text
%        str2double(get(hObject,'String')) returns contents of SPF as a double


% --- Executes during object creation, after setting all properties.
function SPF_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SPF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function SPR_Callback(hObject, eventdata, handles)
global SPR
SPR=str2double(get(handles.SPR,'String'));
if SPR<20 | SPR>100
    warndlg({'Stiffness outta range'});
end% hObject    handle to SPR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of SPR as text
%        str2double(get(hObject,'String')) returns contents of SPR as a double


% --- Executes during object creation, after setting all properties.
function SPR_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SPR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%{
function FY_D1_Callback(hObject, eventdata, handles)
global FY
FY(1)=str2double(get(handles.FY_D1,'String'));
fy_plot(hObject)
iso4138(hObject)

function FY_D1_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function MZ_D1_Callback(hObject, eventdata, handles)
global MZ
MZ(1)=str2double(get(handles.MZ_D1,'String'));
mz_plot(hObject)
iso4138(hObject)

function MZ_D1_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function FY_D2_Callback(hObject, eventdata, handles)
global FY
FY(2)=str2double(get(handles.FY_D2,'String'));
fy_plot(hObject)
iso4138(hObject)


function FY_D2_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function MZ_D2_Callback(hObject, eventdata, handles)
global MZ
MZ(2)=str2double(get(handles.MZ_D2,'String'));
mz_plot(hObject)
iso4138(hObject)


function MZ_D2_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function FY_B_Callback(hObject, eventdata, handles)
global FY
FY(3)=str2double(get(handles.FY_B,'String'));
fy_plot(hObject)
iso4138(hObject)


function FY_B_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function MZ_B_Callback(hObject, eventdata, handles)
global MZ
MZ(3)=str2double(get(handles.MZ_B,'String'));
mz_plot(hObject)
iso4138(hObject)


function MZ_B_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function FY_C_Callback(hObject, eventdata, handles)
global FY
FY(4)=str2double(get(handles.FY_C,'String'));
fy_plot(hObject)
iso4138(hObject)


function FY_C_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function MZ_C_Callback(hObject, eventdata, handles)
global MZ
MZ(4)=str2double(get(handles.MZ_C,'String'));
mz_plot(hObject)
iso4138(hObject)


function MZ_C_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function DELTAWT_Callback(hObject, eventdata, handles)
global DELTAWT 
DELTAWT =str2double(get(handles.DELTAWT,'String'))/100;
if DELTAWT > .99 | DELTAWT < 0
    warndlg({'Parameter out of range:','Total Load Transfer (F + R) (kg)'},'Nonlin Input Error !')
else
    iso4138(hObject)
end




function DELTAWT_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%}

function TARGET_Callback(hObject, eventdata, handles)
global TARGET 
TARGET =str2double(get(handles.TARGET,'String'))
if TARGET < 2
   warndlg({'Parameter out of range:','Circle Radius (m)'},'Nonlin Input Error !');
end


function TARGET_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function MAX_SPEED_Callback(hObject, eventdata, handles)
global MAX_SPEED 
MAX_SPEED =str2double(get(handles.MAX_SPEED,'String'));
if MAX_SPEED > 140 | MAX_SPEED < 10
    warndlg({'Parameter out of range:','Max. Test Speed (kph)'},'Nonlin Input Error !');
end


function MAX_SPEED_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function q=fy_plot(hObject)
handles=guidata(hObject);
coeff();
global WF WR
%Just so you-all know this goes against my grain:
% don't need to make all new plots, just replot the FY values.
% If there is time, I'll re-do this to make it faster.
slips=(0:-.2:-15)'; % Negative slip angles for +FY
fzf = (WF/2);
for i=1:length(slips)
    fyf(i)=LATFORCE(slips(i),0,fzf);
end
% df = (FY(1) + FY(2)/1000.*9.806*(-WF/2))*9.806*(-WF/2);    
set(handles.CSF1,'String',num2str(LATFORCE(-2,0,fzf)/fzf,'%5.3f'));

axes(handles.FY_Axes)
% dr = (FY(1) + FY(2)/1000.*9.806*(-WR/2))*9.806*(-WR/2);    
% fyr= dr.*sin(FY(4).*atan(FY(3).*slip));
fzr = (WR/2);
for i=1:length(slips)
    fyr(i)=LATFORCE(slips(i),0,fzr);
end
set(handles.CSR1,'String',num2str(LATFORCE(-2,0,fzr)/fzr,'%5.3f'));

plot(slips,fyf,'r-',slips,fyr,'b-')
legend('Front','Rear')
set(gca, 'XDir', 'reverse')
xlabel('Slip Angle (deg.)')
title('Lateral Force (N)')
%legend('Front','Rear','Location','Southeast+');
legend boxoff
grid on
%%href(0)
drawnow

function q=mz_plot(hObject)
handles=guidata(hObject);
global WF WR MZ
%Just so you-all know this goes against my grain:
% don't need to make all new plots, just replot the FY values.
% If there is time, I'll re-do this to make it faster.
coeff();
slips=(0: .2:15)'; % Negative slip angles for +FY
fzf = (WF/2);
fzr = (WR/2);
for i=1:length(slips)
    mzf(i)=ALIGNMOMENT(slips(i),0,fzf);
    mzr(i)=ALIGNMOMENT(slips(i),0,fzr);
end

axes(handles.MZ_Axes)
plot(slips,mzf,'r-',slips,mzr,'b-')
xlabel('Slip Angle (deg.)')
title('Aligning Moment (Nm)')
legend('Front','Rear');legend boxoff;
grid on
%href(0)
drawnow

function q=iso4138(hObject)
handles=guidata(hObject);
global W WF WR L SPEED TARGET A B IZZ 
global R BETA AYG MAX_SPEED TLLTD WT ALPHAF ALPHALF ALPHARF ALPHAR
global ENFB ENFC RADIUS DELTA WHL_LIFT TOEIN
set(handles.WHL_LIFT,'String',' ');
ENFB=str2double(get(handles.ENFB,'String')); 
ENFC=str2double(get(handles.ENFC,'String'));
coeff()
global TR1 TR2 TR3 TF1 TF2 TF3 SPF SPR RGRAD
FTrack=1.2;
RTrack=1.2;
Wt=WF+WR;
WDist=WR/Wt;
WuR=WR*0.3;%unsprung is 20% of total rear weight
WuF=WF*0.2;
Ws=Wt-Wt*0.255;%unsprung mass is 25% of total mass
TrackSpr=0.850;%Spring track on beam. Try to get higher closer to 0.950
CGH=0.230;
CGuR=0.198;%unsprung CG Rear(in m) 
CGuF=0.222;%Unsprung CG Front
Zf=67.7*0.001;%roll center height
Zr=141.82*0.001;
Kt=70000;%tyre verticle stiffness in N/m
%Wheel loads
%Roll moment arm calculation
theta=atan((Zr-Zf)/L); %%roll angle inclination
x=(WDist)*(Zr-Zf);
Hs=(CGH-(Zf+x))*cos(theta);
MRf=0.51; MRr=0.68;% motion ratio
KwF=(MRf^2)*SPF*1000;
KwR=(MRr^2)*SPR*1000;
KrF=(Kt*KwF)/(KwF+Kt);
KrR=(Kt*KwR)/(KwR+Kt);
%Roll Rates obtained through Ride Rates
KphiF=(KrF*(FTrack^2)/2);%for front SLA (LETS PLAY!!! WITH ROLL RATES) actually the last term is being used to manipulate the kphi
KphiR=((Kt*(RTrack^2)/2)*(KwR*(TrackSpr^2)/2))/((Kt*(RTrack^2)/2)+(KwR*(TrackSpr^2)/2));%rear beam
RGRAD=Ws*Hs/(KphiR+KphiF)*(57.3);
Kphi=KphiF+KphiR;%rear biased
TR1=Ws/RTrack; TR2=(KphiR*Hs/Kphi)+(WDist*Zr); TR3=WuR*CGuR/RTrack;
TF1=Ws/FTrack; TF2=(KphiF*Hs/Kphi)+((1-WDist)*Zf); TF3=WuF*CGuF/FTrack;

Options=optimset('MaxFunEvals',1000000000,'TolFun',.00000001,'Display','off');
% Compute a turn delta for a starting off point of 1 degrees RWA.
h        = waitbar(0,'Working','Name','ISO4138 Procedure in Progress...');
%{
total_lt = WT*(WF+WR); 
LTF      = TLLTD*total_lt;
LTR      = (1-TLLTD)*total_lt;
%}
delta0   = 180/pi*L/1000/TARGET; % initial guess for 20 kph (deg RWA). Comes from the initial TARGET and Wheelbase (ofcourse)
i        = 0;
for SPEED     = 10:2.5:75   % kph increments in a constant radius test
    delta     = fsolve(@engine_52,delta0,Options) ;  % 30 degrees initial steer angle
    i         = i+1;
    deltaf(i) = delta;
    ayg(i)    = AYG;
    beta(i)   = BETA;
    speed(i)  = SPEED;
    delta0    = delta;
    al(i,1)   = ALPHAF;
    alphaf(i) = (ALPHALF+ALPHARF)/2; 
    waitbar(SPEED/MAX_SPEED,h,['Speed = ' num2str(SPEED,'%4.1f') ' kph'])
end

% Spline fittings have more freedom, ...
dsp     = spline(ayg,deltaf);
dspd    = fnder(dsp);
K       = fnval(dspd,ayg);
bsp     = spline(ayg,beta);
bspd    = fnder(bsp);
DR      = -fnval(bspd,ayg) ; % in a constant radius test, the sideslip gain is the rear cornering compliance.
DF      = DR+K;
bu      = spline(speed,beta);
tan_spd = fnzeros(bu);

%{
But polynomials work OK in simulations where the cars and data are smooth
%and boring.
dsp     = polyfit(ayg,deltaf,5);
dspd    = polyder(dsp);
K       = polyval(dspd,ayg);
bsp     = polyfit(ayg,beta,5);
bspd    = polyder(bsp);
DR      = -polyval(bspd,ayg) ; % in a constant radius test, the sideslip gain is the rear cornering compliance.
DF      = DR+K;
bu      = polyfit(beta,speed,5);  % reverse order here because of the zero finding need.
tan_spd = polyval(bu,0.); 
%}

set(handles.TITLE_BLOCK,'String',['Tangent Speed = ' num2str(tan_spd(1),'%4.1f') ' kph,  Highest Ay = ' num2str(ayg(end),'%4.2f') ' g'])
close(h)

axes(handles.axes1)
if get(handles.FREEZE_SCALE,'Value')
    axis manual 
else
    axis auto
end
plot(ayg,DF,ayg,DR,ayg,K,'LineWidth',2)
hold on
ackpg=9.806*180/pi*str2double(get(handles.L,'String'))/1000/(speed(end)*.2778)^2; 
plot(ayg(end),-ackpg,'Bo','MarkerSize',5,'MarkerFaceColor',[0 0 .1])
hold off
grid on
xlabel('Lateral Acceleration (g)')
ylabel('Cornering Compliances and Understeer (de/g)')
legend('Front Cornering Compliance','Rear Cornering Compliance','Understeer','-(Ackerman Gradient @ Max. Speed)','Location','West');legend boxoff
set(handles.WT,'String',num2str(WT));
set(handles.TLLTD,'String',num2str(TLLTD));
%sidetext('Bill Cobb   01/05/2016   zzvyb6@yahoo.com')
if WHL_LIFT(1) 
    set(handles.WHL_LIFT,'String','Front Wheel Lift','ForegroundColor',[1 0 0]);
elseif WHL_LIFT(2)
    set(handles.WHL_LIFT,'String','Rear Wheel Lift','ForegroundColor',[1 0 0]);
end

function coeff()
%general coefficients
global FZ0 LCX LCY LEX LEY LFZ0 LGAX LGAY LGAZ LHX LHY LKX LKY LMUX LMUY LMX LMY LONGVL
global LRES LS LTR LVMX LVX LVY LVYKA LXAL LYKA 
FZ0=500;LCX=1;LCY=0.9800;LEX=1;LEY=0.55;LFZ0=1;LGAX=1;LGAY=0.8000;LGAZ=1;LHX=1;LHY=1;
LKX=1;LKY=1;LMUX=0.7200;LMUY=0.7700;LMX=1;LMY=1;LONGVL=19.4444;LRES=0;LS=1.5;LTR=1;LVMX=1;LVX=1;
LVY=1;LVYKA=1;LXAL=1.3600;LYKA=1.3000;
%Lateral force coefficients
global PCY1 PDY1 PDY2 PDY3 PEY1 PEY2 PEY3 PEY4 PKY1 PKY2 PKY3 PHY1 PHY2 PHY3 PVY1 PVY2 PVY3 PVY4 
global RBY1 RBY2 RBY3 RCY1 REY1 REY2 RHY1 RHY2 RVY1 RVY2 RVY3 RVY4 RVY5 RVY6 PTY1 PTY2
PCY1				= +1.64285;
PDY1				= 3.737484;
PDY2				= -0.47486;
PDY3				= -48145.8;
PEY1				= +0.02413;
PEY2				= -0.88886;
PEY3				= +0.70283;
PEY4				= 72.09905;
PKY1                = -71.4264;
PKY2				= +2.133302;
PKY3				= +8.934694;
PHY1				= -0.00132;
PHY2				= -0.00261;
PHY3				= -0.31708;
PVY1				= -0.08724;
PVY2				= -0.05835;
PVY3				= -2.71626;
PVY4				= -0.43449;			
RBY1				= +2.033e+001;			
RBY2				= +8.152e+000;			
RBY3				= -1.243e-002;			
RCY1				= +9.317e-001;			
REY1				= -3.982e-004;		
REY2				= +3.077e-001;			
RHY1				= +0.000e+000;			
RHY2				= +0.000e+000;		
RVY1				= +0.000e+000;			
RVY2				= +0.000e+000;			
RVY3				= +0.000e+000;		
RVY4				= +0.000e+000;			
RVY5				= +0.000e+000;			
RVY6				= +0.000e+000;			
PTY1				= +1.941e+000;			
PTY2				= +2.093e+000;
% Aligning moment coeffs
global QBZ1 QBZ2 QBZ3 QBZ4 QBZ5 QBZ9 QBZ10 QCZ1 QDZ1 QDZ2 QDZ3 QDZ4 QDZ6 QDZ7 QDZ8 QDZ9 QEZ1 QEZ2 QEZ3
global QEZ4 QEZ5 QHZ1 QHZ2 QHZ3 QHZ4 SSZ1 SSZ2 SSZ3 SSZ4 QTZ1 MBELT
QBZ1				= 8.276747;			
QBZ2				= 0.668583;		
QBZ3				= -0.544055;			
QBZ4				= 5.258566;			
QBZ5				= -18.147;			
QBZ9				= 149.4836;		
QBZ10				= 17.03062;	
QCZ1				= 1.327574;		
QDZ1				= 0.109153;		
QDZ2				= -0.00515;			
QDZ3				= 21.44389;			
QDZ4				= 11.26851;			
QDZ6				= -0.001554;			
QDZ7				= -0.01318;			
QDZ8				= 8.557347;			
QDZ9				= 15.31407;			
QEZ1				= -0.363182;			
QEZ2				= 0.45503;			
QEZ3				= -0.268689;			
QEZ4				= -0.513282;			
QEZ5				= -292.0297;		
QHZ1				= +0.000e+000;			
QHZ2				= +0.000e+000;			
QHZ3				= +2.084E-001;			
QHZ4				= -1.837E-001;			
SSZ1				= +1.840E-003;			
SSZ2				= -1.158E-002;			
SSZ3				= +8.294E-003;			
SSZ4				= +1.474E-002;			
QTZ1				= +1.000E+000;			
MBELT				= +2.700E+000;


function DEBUG_Callback(hObject, eventdata, handles)
global WF WR L SPEED TARGET A B IZZ FY MZ LTF LTR
global R BETA AYG MAX_SPEED TLLTD WT ALPHALF ALPHARF ALPHAR
global ENFB ENFC RADIUS DELTA
{'  RADIUS ' ' SPEED ' 'DELTA ' 'ALPHALF' 'ALPHARF' ' ALPHAR' 'R    '  ' BETA  ' '  AYG  '}
[RADIUS SPEED DELTA ALPHALF ALPHARF ALPHAR R BETA AYG ] 
set(handles.DEBUG,'Value',0)


function ENFB_Callback(hObject, eventdata, handles)
global ENFB
ENFB =str2double(get(handles.ENFB,'String'));
if ENFB > 5 | ENFB < .1
    warndlg({'Parameter out of range:','Mz Compliance Slope (deg/100Nm)'},'Nonlin Input Error !');
end

function ENFB_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function ENFC_Callback(hObject, eventdata, handles)
global ENFC
ENFC =str2double(get(handles.ENFC,'String'));
if ENFC > 1000 | ENFC < 10
   warndlg({'Parameter out of range:','Mz Compliance 37% Level (Nm)'},'Nonlin Input Error !');
end


function ENFC_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




function TOEIN_Callback(hObject, eventdata, handles)
global TOEIN
TOEIN =str2double(get(handles.TOEIN,'String'))
if TOEIN > 10 | TOEIN < -10
    warndlg({'Parameter out of range:','Total Front Toe (deg)'},'Nonlin Input Error !');
end


function TOEIN_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




function FREEZE_SCALE_Callback(hObject, eventdata, handles)




function ABOUT_Callback(hObject, eventdata, handles)
msgbox({'Programmed in Matlab by Bill Cobb','zzvyb6^@Yahoo.com  1/4/2016'},'About Nonlin')



function PRINT_Callback(hObject, eventdata, handles)

function PREVIEW_Callback(hObject, eventdata, handles)
printpreview(gcf);


function PRINT_PDF_Callback(hObject, eventdata, handles)
print(gcf,'Nonlin','-dpdf')

function BULKDATA_Callback(hObject, eventdata, handles)
global WF WR L SPEED TARGET A B IZZ FY MZ LTF LTR
global R BETA AYG MAX_SPEED TLLTD WT ALPHALF ALPHARF ALPHAR
global ENFB ENFC RADIUS DELTA TOEIN WHL_LIFT

options.Resize='on';
options.WindowStyle='normal';

defaultanswer={'BMW 530D Dun 245/40R18 250 psi','1060','1000','2884',...
    '37','57','0.605','25.4','1.3305','0.023654','0.29622','1.0069', ...
    '-0.002458','0.0019429','0.28312','2.3747'};
prompt={'Vehicle Description','Front Wgt.(kg)','Rear Wgt.(kg)',...
    'Wheelbase (mm)','%Total Wgt. Transfer','TLLTD %',...
    'Mz Compliance Slope(deg/100Nm)','Mz Compliance 37% Level', ...
    'Tire Fy_D1','Tire Fy_D2','Tire FY_B','Tire Fy_C','Tire Mz_D1',...
    'Tire Mz_D2','Tire Mz_B','Tire Mz_C' };
answer=inputdlg(prompt,'Nonlin Bulk Data Input',1,defaultanswer,options);
set(handles.VEHICLE,'String',answer(1));
set(handles.WF,'String',answer(2))
set(handles.WR,'String',answer(3))
set(handles.L, 'String',answer(4))
set(handles.TLLTD,'String',answer(6))
set(handles.ENFB,'String',answer(7))
set(handles.ENFC, 'String',answer(8))
set(handles.FY_D1,'String',answer(9))
set(handles.FY_D2,'String',answer(10))
set(handles.FY_B ,'String',answer(11))
set(handles.FY_C ,'String',answer(12))
set(handles.MZ_D1,'String',answer(13))
set(handles.MZ_D2,'String',answer(14))
set(handles.MZ_B, 'String',answer(15))
set(handles.MZ_C, 'String',answer(16))

WF = str2double(get(handles.WF,'String'));
WR = str2double(get(handles.WR,'String'));
W = WF + WR; 
set(handles.WT ,'String',num2str(WT));
set(handles.IZZ,'String',num2str(WT*(1+.1)));
set(handles.TLLTD,'String',num2str(WF/(WF+WR),'%4.2f'));
IZZ   = str2double(get(handles.IZZ,'String'));
L     = str2double(get(handles.L,'String'));
L         = str2double(get(handles.L,'String'));
WB=L/1000;
A=WB*WR/(WF+WR) ;
B=WB*WF/(WF+WR) ;

TLLTD = str2double(get(handles.TLLTD,'String'))/100;
DELTAWT = str2double(get(handles.DELTAWT,'String'))/100;
fy_d1 = str2double(get(handles.FY_D1,'String'));
fy_d2 = str2double(get(handles.FY_D2,'String'));
fy_b  = str2double(get(handles.FY_B,'String'));
fy_c  = str2double(get(handles.FY_C,'String'));
FY    =[fy_d1 fy_d2 fy_b fy_c];

mz_d1 = str2double(get(handles.MZ_D1,'String'));
mz_d2 = str2double(get(handles.MZ_D2,'String'));
mz_b  = str2double(get(handles.MZ_B,'String'));
mz_c  = str2double(get(handles.MZ_C,'String'));
MZ    = [mz_d1 mz_d2 mz_b mz_c];
TOEIN = 0;
set(handles.TOEIN,'String','0.')
set(handles.MAX_SPEED,'String','60')
MAX_SPEED=60;


% Update handles structure cause the plotters will need them.
guidata(hObject, handles);
fy_plot(hObject)
mz_plot(hObject)
iso4138(hObject) 


function certify_Callback(hObject, eventdata, handles)
global WF WR L SPEED TARGET A B IZZ FY MZ LTF LTR SPF SPR CAMG CAM0
global R BETA AYG MAX_SPEED TLLTD WT ALPHALF ALPHARF ALPHAR
global ENFB ENFC RADIUS DELTA TOEIN WHL_LIFT

options.Resize='on';
options.WindowStyle='normal';

defaultanswer={'DF=3.33,  DR=3.33,  K=0.00','1000','600.','2745',...
    '0','60','1.000','50','14.','.005','.01','2.15', ...
    '-0.002458','0.0019429','0.28312','0'};
prompt={'Vehicle Description','Front Wgt.(kg)','Rear Wgt.(kg)',...
    'Wheelbase (mm)','%Total Wgt. Transfer','TLLTD %',...
    'Mz Compliance Slope(deg/100Nm)','Mz Compliance 37% Level', ...
    'Tire Fy_D1','Tire Fy_D2','Tire FY_B','Tire Fy_C','Tire Mz_D1',...
    'Tire Mz_D2','Tire Mz_B','Tire Mz_C' };
answer=inputdlg(prompt,'Nonlin Bulk Data Input',1,defaultanswer,options);
set(handles.VEHICLE,'String',answer(1));
set(handles.WF,'String',answer(2))
set(handles.WR,'String',answer(3))
set(handles.L, 'String',answer(4))
set(handles.DELTAWT,'String',answer(5))
set(handles.TLLTD,'String',answer(6))
set(handles.ENFB,'String',answer(7))
set(handles.ENFC, 'String',answer(8))
set(handles.FY_D1,'String',answer(9))
set(handles.FY_D2,'String',answer(10))
set(handles.FY_B ,'String',answer(11))
set(handles.FY_C ,'String',answer(12))
set(handles.MZ_D1,'String',answer(13))
set(handles.MZ_D2,'String',answer(14))
set(handles.MZ_B, 'String',answer(15))
set(handles.MZ_C, 'String',answer(16))

WF = str2double(get(handles.WF,'String')); 
WR = str2double(get(handles.WR,'String'));
WT = WF + WR ; 
set(handles.WT ,'String',num2str(WT));

L   = str2double(get(handles.L,'String'));
WB  = L/1000;
A   = WB*WR/(WF+WR); 
B   = WB*WF/(WF+WR); 


set(handles.IZZ,'String',num2str(WT*(1+.1)));
set(handles.TLLTD,'String',num2str(WF/(WF+WR),'%4.2f'));
IZZ   = str2double(get(handles.IZZ,'String'));
L     = str2double(get(handles.L,'String'));
TLLTD = str2double(get(handles.TLLTD,'String'))/100;
DELTAWT = str2double(get(handles.DELTAWT,'String'))/100;
fy_d1 = str2double(get(handles.FY_D1,'String'));
fy_d2 = str2double(get(handles.FY_D2,'String'));
fy_b  = str2double(get(handles.FY_B,'String'));
fy_c  = str2double(get(handles.FY_C,'String'));
FY    =[fy_d1 fy_d2 fy_b fy_c];

mz_d1 = str2double(get(handles.MZ_D1,'String'));
mz_d2 = str2double(get(handles.MZ_D2,'String'));
mz_b  = str2double(get(handles.MZ_B,'String'));
mz_c  = str2double(get(handles.MZ_C,'String'));
MZ    = [mz_d1 mz_d2 mz_b mz_c];
TOEIN = 0;
set(handles.TOEIN,'String','0.')
set(handles.TARGET,'String','33')
TARGET=33;
set(handles.MAX_SPEED,'String','100')
MAX_SPEED=100;

% Update handles structure cause the plotters will need them.
guidata(hObject,handles);
fy_plot(hObject)
mz_plot(hObject)

iso4138(hObject) 

function ref= href(pt)
for n=1:length(pt)
    line(xlim,[pt(n) pt(n)],'color',[.01 .01 .01])
end
return

function ref= vref(pt)
for n=1:length(pt)
    line([pt(n) pt(n)],ylim,'color',[.01 .01 .01])
end
return



