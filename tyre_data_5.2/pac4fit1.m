[filename pathname]= uigetfile()

t=importdata([pathname filename]);
names  = t.textdata{2}
nchans = size(t.data,2)    % how much we got?

%t.data(1:1500,:)=[];    % toss out the 1st 1500 pts (warmup)

for n=1:nchans          % demultiplex
    [name,names]=strtok(names);
    eval([upper(name) '= t.data(:,' num2str(n) ');']);
end
%load('D:\4ze Data\Tire_Stuff\Round 6\RawData_13inch_Cornering_ASCII_SI\')
%%Section 1, look at the data first
figure
subplot(5,1,1)
plot(ET,SA)
xlabel('Time'); ylabel('slip angle')
subplot(5,1,2)
plot(ET,P)
xlabel('Time'); ylabel('pressure')
subplot(5,1,3)
plot(ET,FZ)
xlabel('Time'); ylabel('vertical load')
subplot(5,1,4)
plot(ET,IA)
xlabel('Time'); ylabel('inclination angle')
subplot(5,1,5)
plot(ET,V)
xlabel('Time'); ylabel('Velocity')


%eye ball the test data region of interest, usually pressure and camber
%change is clearly separated
pinterest =12 * 6.89476;
iainterest = 4;
vinterest=40;
%% isolate test region of interest
int = (abs(P-pinterest) <= 5)  .* (round(IA)==iainterest) .* (abs(V-vinterest) <=3);
[x,y] = find(int==1);

ET1 = ET(x);
SA1 = SA(x);
P1 = P(x);
FZ1 = FZ(x);
IA1 = IA(x);

FY1 = FY(x);
MZ1 = MZ(x);
MX1 = MX(x);
FX1= FX(x);

m=1:length(SA1); % point counter

sp        = csaps(ET1,SA1 + .25,.1); % fit a generic spline to locate zeros.  
z = fnzeros(sp);      % location of zero crossings
z = round(z(1,:));    % no dups and integer indices
z = [ceil(ET1(1)), z];
nz        = length(z);
z(4:4:end) = [];


figure
subplot(4,1,1)
plot(ET1,SA1)
hold on
plot(z,zeros(length(z)),'bo')
xlabel('Time'); ylabel('slip angle')
subplot(4,1,2)
plot(ET1,P1)
xlabel('Time'); ylabel('pressure')
subplot(4,1,3)
plot(ET1,FZ1)
xlabel('Time'); ylabel('vertical load')
subplot(4,1,4)
plot(ET1,IA1)
xlabel('Time'); ylabel('inclination angle')


%if this shows up okay, move on to the next stage
%%


nsweeps = length(z)/3;
for n=1:nsweeps
    sweeps(n,1)=z(3*n-2);
    sweeps(n,2)=z(3*n);
end

et=[];
sa=[];
ia=[];
fz=[];
fy=[];
mz=[];
mx=[];
fx=[];
loads = [];


for n= 1: nsweeps
    ET_diff1 = abs(ET-sweeps(n,1));
    ET_diff2 = abs(ET-sweeps(n,2));
    [~,x1] = min(ET_diff1);
    [~,x2] = min(ET_diff2);
    et=cat(1,et,ET(x1:x2));
    sa=cat(1,sa,SA(x1:x2));
    ia=cat(1,ia,IA(x1:x2));
    fz=cat(1,fz,FZ(x1:x2));
    fy=cat(1,fy,FY(x1:x2));
    mz=cat(1,mz,MZ(x1:x2));
    mx=cat(1,mx,MX(x1:x2));
    fx=cat(1,fx,FX(x1:x2));

    loads(n)=mean(FZ(x1:x2));
end
loads

inx=find(abs(sa) > 12); % Removes the 'bad' flyback' in the TIRF data.
et(inx) =[];
sa(inx) =[];
ia(inx) =[];
fz(inx) =[];
fy(inx) =[];
mz(inx) =[];
mx(inx) =[];
fx(inx) =[];


% figure
% subplot(4,1,1)
% plot(et,sa) 
% xlabel('Time'); ylabel('slip angle')
% subplot(4,1,2)
% plot(et,ia)
% xlabel('Time'); ylabel('ia')
% subplot(4,1,3)
% plot(et,fz)
% xlabel('Time'); ylabel('vertical load')
% subplot(4,1,4)
% plot(et,fy)
% xlabel('Time'); ylabel('lat force')

inx = find(round(ia) == iainterest); %basically selects all because of prior ia filter
%%
% %-------------------
xdata=[sa(inx) fz(inx)]; 
ydata= fy(inx);
figure('Name','Lateral Force Data Fitting');hold on
plot3(xdata(:,1),xdata(:,2),ydata,'k-')
f0=[1.33 .05 .1335 1.00 0 0];
options = optimset('MaxFunEvals',1000000000,'TolFun',.00000001,'Display','off');
[f,f_resnorm,f_residual]=lsqcurvefit('Pacejka6_Model',f0,xdata,ydata,[],[],options);
f
f_resnorm
plot3(xdata(:,1),xdata(:,2),Pacejka6_Model(f,xdata),'r.')
grid on
view(-45,45)
legend('Test Data',' Fitted Results','Location','Best'),legend boxoff
xlabel('Slip Angle (deg)')
ylabel('Vertical Load (N)')
zlabel('Lateral Force (N)')
view([0,-1,0])

%-------------------
ydata= mz(inx);
figure('Name','Aligning Moment Data Fitting');hold on
plot3(xdata(:,1),xdata(:,2),ydata,'k-')
m0=[-0.024507892	0.026415425	0.181479542	2.702042277	0.811024948	0.019182303
];
options = optimset('MaxFunEvals',1000000000,'TolFun',.00000001,'Display','off');
[m,m_resnorm,m_residual]=lsqcurvefit('Pacejka6_Model',m0,xdata,ydata,[],[],options); 
m
m_resnorm
plot3(xdata(:,1),xdata(:,2),Pacejka6_Model(m,xdata),'r.')
grid on
view(-45,45)
legend('Test Data',' Fitted Results','Location','Best'),legend boxoff
xlabel('Slip Angle (deg)')
ylabel('Vertical Load (N)')
zlabel('Aligning Moment (Nm')
view([0,-1,0])

ydata= mx(inx);
figure('Name','Overturning Moment Data Fitting');hold on
plot3(xdata(:,1),xdata(:,2),ydata,'k-')
x0=[-0.02 .4 .14 3 0 0];
options = optimset('MaxFunEvals',1000000000,'TolFun',.00000001,'Display','off');
[x,x_resnorm,x_residual]=lsqcurvefit('Pacejka6_Model',x0,xdata,ydata,[],[],options); 
x
x_resnorm
plot3(xdata(:,1),xdata(:,2),Pacejka6_Model(x,xdata),'r.')
grid on
view(-45,45)
legend('Test Data',' Fitted Results','Location','Best'),legend boxoff
xlabel('Slip Angle (deg)')
ylabel('Vertical Load (N)')
zlabel('Overturning Moment (Nm')
view([0,-1,0])

%%% for excel
out = [f m x loads];