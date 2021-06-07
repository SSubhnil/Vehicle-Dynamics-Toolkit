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
subplot(6,1,1)
plot(ET,FX)
xlabel('Time'); ylabel('FX')
subplot(6,1,2)
plot(ET,SR)
xlabel('Time'); ylabel('SR')
subplot(6,1,3)
plot(ET,SA)
xlabel('Time'); ylabel('SA')
subplot(6,1,4)
plot(ET,P)
xlabel('Time'); ylabel('P')
subplot(6,1,5)
plot(ET,FZ)
xlabel('Time'); ylabel('Fz')
subplot(6,1,6)
plot(ET,IA)
xlabel('Time'); ylabel('IA')

%eye ball the test data region of interest, usually pressure and camber
%change is clearly separated
pinterest =12 * 6.89476;
iainterest = 0;
vinterest=40;
sainterest=0;
%% isolate test region of interest
int = (abs(P-pinterest) <= 5).*(round(IA)==iainterest).*(abs(V-vinterest) <=3).*(round(SA)==sainterest);
[x,y] = find(int==1);

ET1 = ET(x);
SA1 = SA(x);
P1 = P(x);
FZ1 = FZ(x);
IA1 = IA(x);
FX1 = FX(x);
SR1 = SR(x);

m=1:length(SR1); % point counter

sp= csaps(ET1,SR1,.1); % fit a generic spline to locate zeros.  
z = fnzeros(sp);      % location of zero crossings
z = round(z(1,:));    % no dups and integer indices
z = [ceil(ET1(1)), z];
nz        = length(z);
z(4:4:end) = [];


figure
subplot(6,1,1)
plot(ET1,FX1)
xlabel('Time'); ylabel('FX')
hold on
subplot(6,1,2)
plot(ET1,SR1)
plot(z,zeros(length(z)),'bo')
xlabel('Time'); ylabel('SR')
subplot(6,1,3)
plot(ET1,SA1)
xlabel('Time'); ylabel('SA')
subplot(6,1,4)
plot(ET1,P1)
xlabel('Time'); ylabel('P')
subplot(6,1,5)
plot(ET1,FZ1)
xlabel('Time'); ylabel('Fz')
subplot(6,1,6)
plot(ET1,IA1)
xlabel('Time'); ylabel('IA')

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
fx=[];
sr=[]
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
    fx=cat(1,fx,FX(x1:x2));
    sr=cat(1,sr,SR(x1:x2));
    loads(n)=mean(FZ(x1:x2));
end
loads

inx=find(abs(sa) > 12); % Removes the 'bad' flyback' in the TIRF data.
et(inx) =[];
sa(inx) =[];
ia(inx) =[];
fz(inx) =[];
fx(inx) =[];
sr(inx) =[];

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
xdata=[sr(inx) fz(inx)];
ydata=fx(inx);
figure('Name','Longitudinal Force Data Fitting');hold on
plot3(xdata(:,1),xdata(:,2),ydata,'k-')
f0=[1.33 .05 -0.1335 1.00];
options = optimset('MaxFunEvals',1000000000,'TolFun',.00000001,'Display','off');
[f,f_resnorm,f_residual]=lsqcurvefit('Pacejka4_Model',f0,xdata,ydata,[],[],options); 
f 
f_resnorm
plot3(xdata(:,1),xdata(:,2),Pacejka4_Model(f,xdata),'r.')
grid on
view(-45,45)
legend('Test Data',' Fitted Results','Location','Best'),legend boxoff
xlabel('Slip Ratio')
ylabel('Vertical Load (N)')
zlabel('Longitudinal Force (N)')
view([0,-1,0])