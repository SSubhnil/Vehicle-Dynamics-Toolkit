clear
clc

[filename pathname]= uigetfile('*.dat','Enter TIRF Test File','E:\Round3\RawData_ASCII_Metric\')

t=importdata([pathname filename]);
names  = t.textdata{2}
nchans = size(t.data,2)    % how much we got?

t.data(1:1500,:)=[];    % toss out the 1st 1500 pts (warmup)

for n=1:nchans          % demultiplex
    [name,names]=strtok(names);
    eval([upper(name) '= t.data(:,' num2str(n) ');']);
end

m=1:length(SA);     % point counter
sp=spline(m,SA+3.5); % fit a generic spline to locate zeros.

z=fnzeros(sp);      % location of zero crossings - the first and 4th column consecutive row values change sign(check sp)
z=round(z(1,:));   % no dups and integer indices


%% Checking your results with a plot
% Plotting the slip angle channel with the zero points indicated is a good
% check to see if there has been a problem. The full plot is a bit to
% muddy, so we zoom into the first few seconds of the run.

figure('Name','Locations of Test Slip Sweep william.a.cobb@gm.com','NumberTitle','Off') % Just checkin'
plot(m,SA,'r')

%% Eliminating unnecessary zero conditions
% Because there are some 'zero' points that we don't need, send them to the
% trash:

z([4:4:length(z)])=[]; % drop kick the shutdown points;

%% Show Abreviated Slip sequence with indicated Zeros
% This tells us we're on the right track:
hold on
xlim([0 3200]) % Don't need to see All the data...
plot(z,zeros(length(z)),'bo')
line([0 m(end)], [0 0],'color','k')
xlabel('Point Count')
ylabel('Slip Angle')
legend('Test Data','Computed Slip Points of Interest'),legend Boxoff

% Don't want to remember any data from apprevious processing session:

clear fmdata % not a speck of cereal..

%% Outputting scans of data for each slip, load, and camber condition 
% Now we need to spew out the data as a sequential data vector for each
% separate slip, load and camber scan:
% q is the scan pointer
q = 0; 
% Subset the data:
for n=7:3:length(z) % for some reason there are some repeat runs here. Skip them
sa=SA(z(n):z(n+2));
fz=FZ(z(n):z(n+2));
fy=FY(z(n):z(n+2));
mz=MZ(z(n):z(n+2));
mx=MX(z(n):z(n+2));
rl=RL(z(n):z(n+2));
ia=IA(z(n):z(n+2));

% Now we have collected the tire channels for each full slip sweep.
%
% Next step is to capture the rational data between the max and minimum
% values, peek at the endpoints, fix up some problems at the MZ endpoints,
% and proceed with data fitting.

[tmp,imn]=min(sa);
[tmp,imx]=max(sa);
p=1:length(sa);
rng=imx-50:imx+50; % This is a range of our data at maximum MZ
%
% Being careful not to use a Matlab reserved word for a variable name.
%
warning off % Keep down the chatter over multiple observations

% fit this data to a polynomial. Crude but fair. We are only using it
% to look for outliers.
pp=polyfit(p(rng),mz(rng)',3); 
warning on
mzf=polyval(pp,p(rng));

% This step spots data values for MZ that are greater than an arbitray
% level. I believe these spikes are related to the MZ transient response.
% A smarter approach would be to use normalized residuals, but who did
% I just hear volunteer for that task?
%

ind=find(abs(mzf-mz(rng)') > 7);
mz(rng(ind))=mzf(ind);

rng=imn-50:imn+50;% This is a range of our data at minimum MZ
warning off
pp=polyfit(p(rng),mz(rng)',3);
warning on
mzf=polyval(pp,p(rng));

ind=find(abs(mzf-mz(rng)') > 7);
mz(rng(ind))=mzf(ind);

%% Spline fitting the continuous data to subset it with 1 Degrre increments 
% with some tighter tension:
%
sp_fy=csaps(sa,fy,.1);
sp_mz=csaps(sa,mz,.1);
sp_mx=csaps(sa,mx,.1);
sp_rl=csaps(sa,rl,.1);

%% Check out Segment 10 
% Just out of curiosity, what kind of data are we dealing ?

if isequal(n,10)
figure('Name',[upper(filename) ': Aligning Moment vs. Slip Angle & Vertical Load ' ' william.a.cobb@gm.com'],'numbertitle','off')
subplot(3,1,1)
hold on
plot(sa,fy,'.','color',[.5 .5 .5])
fnplt(sp_fy,'b')
title({['Fz= ' num2str(round(mean(fz))) ' N'];['IA= ' num2str(round(mean(ia))) '?']})
xlabel('Slip Angle')
ylabel('Lateral Force')
line([min(sa) max(sa)],[0 0],'color','k')
line([0 0],[min(fy) max(fy)],'color','k')
legend('Test Data','Fitted Data')
subplot(3,1,2)
hold on
plot(sa,mz,'.','color',[.5 .5 .5])
fnplt(sp_mz,'b')
xlabel('Slip Angle')
ylabel('Aligning Moment')
line([min(sa) max(sa)],[0 0],'color','k')
line([0 0],[min(mz) max(mz)],'color','k')
subplot(3,1,3)
hold on
plot(sa,mx,'.','color',[.5 .5 .5])
fnplt(sp_mx,'b')
xlabel('Slip Angle')
ylabel('Overturning Moment')
line([min(sa) max(sa)],[0 0],'color','k')
line([0 0],[min(mz) max(mz)],'color','k')
end

for sl=floor(min(sa)):1:ceil(max(sa)); % This is the only pushup step required:
q=q+1;
fmdata(q,1)=sl;
fmdata(q,2)=round(mean(ia));
fmdata(q,3)=mean(fz);
fmdata(q,4)=fnval(sp_fy,sl);
fmdata(q,5)=fnval(sp_mz,sl);
fmdata(q,6)=fnval(sp_mx,sl);
fmdata(q,7)=fnval(sp_rl,sl);
end
end
% All done with the hard work,

%% Sort Data Array by Camber, Slip and Load Groups
% Use |sortrows| to preserve the array correspondence.

fmdata = sortrows(fmdata,[2,1,3]);

%% Determining Data Sets (Slip, Load, Camber):
% Get the distinct values and counts of each data set:

incls = unique(round(fmdata(:,2)))'
nincls = length(incls)

slips = unique(round(fmdata(:,1)))'
nslips = length(slips)

%% Check Visuals for Zero Camber Subset:
% Stuck living in a 3-D world, we can only look at a graph of w=f(u,v). 
% First sniff out indices of the zero camber rows:

inx0 = find(fmdata(:,2) == 0); % zero camber points

% then grab the rest of the zero camber condition data:

fmdata0 = fmdata(inx0,:);

% Next, we transpose the arrays to make our spline functions happy:

loads = mean(reshape(fmdata0(:,3),[],nslips),2)'
nloads = length(loads)
% Take a look at FZ:
fz0 = reshape(fmdata0(:,3),nloads,nslips)'
fy0 = reshape(fmdata0(:,4),nloads,nslips)'; 
mz0 = reshape(fmdata0(:,5),nloads,nslips)';
mx0 = reshape(fmdata0(:,6),nloads,nslips)';
%
% Normalized FY for you folks headed to the tire industry:
nfy0 = fy0./fz0

% now we are ready to rock 'n roll.
%% Beer break...
% All the test data has been reduced to a reasonable grid of fixed slips, cambers and loads.
% All that remains is to do something with it in the tire model world.

%% FY Surface Fit (Zero Camber):
% This process uses the spline toolbox functions to generate fitted surfaces.
% CSAPS is a cubic - smoothed spline allowing multiple obervations at grid
% points with default or user prescribed tension

LATE_SLIP_VERT = csaps({slips,loads},fy0,.9)
figure('Name',[upper(filename) ': Lateral Force vs. Slip Angle & Vertical Load ' ' william.a.cobb@gm.com'],'numbertitle','off')
fnplt(LATE_SLIP_VERT)
xlabel('Slip Angle (deg)')
ylabel('Vertical Load (N)')
zlabel('Lateral Force (N)')
view(45,45)

%% Cornering Stiffness Surface Fit (Zero Camber):

CS=fnder(LATE_SLIP_VERT,[1,0])
figure('Name',[upper(filename) ': Cornering Stiffness vs. Slip Angle & Vertical Load ' ' william.a.cobb@gm.com'],'numbertitle','off')
fnplt(CS)
xlabel('Slip Angle (deg)')
ylabel('Vertical Load (N)')
zlabel('Cornering Stiffness (N/deg)')

%% Normalized Lateral Force Surface fit
NLATE_SLIP_VERT = csaps({slips,loads},nfy0)
figure('Name',[upper(filename) ': Load Normalized Lateral Force vs. Slip Angle & Vertical Load ' ' william.a.cobb@gm.com'],'numbertitle','off')
fnplt(NLATE_SLIP_VERT)
xlabel('Slip Angle (deg)')
ylabel('Vertical Load (N)')
zlabel('Lateral Force (N)')
view(45,45)

% Wow, look at the mu on that baby, good as a Sprint Cup Left Side Tire !!

%Here's the traditional normalized cornering stiffness use in industry:
NCS=fnder(NLATE_SLIP_VERT,[1,0])
figure('Name',[upper(filename) ': Normalized Cornering Stiffness vs. Slip Angle & Vertical Load ' ' william.a.cobb@gm.com'],'numbertitle','off')
fnplt(NCS)
xlabel('Slip Angle (deg)')
ylabel('Vertical Load (N)')
zlabel('Normalized Cornering Stiffness (N/deg/N)')

%% MZ Surface Fit (Zero Camber):
ALNT_SLIP_VERT = csaps({slips,loads},mz0,.9)
figure('Name',[upper(filename) ': Aligning Moment vs. Slip Angle & Vertical Load ' ' william.a.cobb@gm.com'],'numbertitle','off')
fnplt(ALNT_SLIP_VERT)
xlabel('Slip Angle (deg)')
ylabel('Vertical Load (N)')
zlabel('Aligning Moment(Nm/deg)')
%
%% MX Surface Fit (Zero Camber):
OVTM_SLIP_VERT = csaps({slips,loads},mx0,.9)
figure('Name',[upper(filename) ': Overturning Moment vs. Slip Angle & Vertical Load ' ' william.a.cobb@gm.com'],'numbertitle','off')
fnplt(OVTM_SLIP_VERT)
view(30,45)
xlabel('Slip Angle (deg)')
ylabel('Vertical Load (N)')
zlabel('Overturning Moment (Nm)')
% 
%% Pneumatic Scrub Surface Fit (Zero Camber):
PSCRUB_SLIP_VERT = csaps({slips,loads},1000*mx0./fz0,.9)
figure('Name',[upper(filename) ': Pneumatic Scrub vs. Slip Angle & Vertical Load ' ' william.a.cobb@gm.com'],'numbertitle','off')
fnplt(PSCRUB_SLIP_VERT)
view(30,45)
xlabel('Slip Angle (deg)')
ylabel('Vertical Load (N)')
zlabel('Pneumatic Scrub (mm)')
%
%% Pneumatic Trail Surface Fit (Zero Camber):
PTRAIL_SLIP_VERT = csaps({slips,loads},1000*mz0./fy0,.707)
figure('Name',[upper(filename) ': Pneumatic Trail vs. Slip Angle & Vertical Load ' ' william.a.cobb@gm.com'],'numbertitle','off')
fnplt(PTRAIL_SLIP_VERT)
view(30,45)
title('Although I would not produce Pneumatic Trail this way, good guess, though ...')
xlabel('Slip Angle (deg)')
ylabel('Vertical Load (N)')
zlabel('Pneumatic Trail (mm)')
% 
%% Subset Scans of Zero Slip Angle
inx0 = find(fmdata(:,1) == 0); % zero slip points
fmdata0 = fmdata(inx0,:);
loads = mean(reshape(fmdata0(:,3),[],nincls),2)'
nloads = length(loads)
fy0 = reshape(fmdata0(:,4),nloads,nincls)';
mz0 = reshape(fmdata0(:,5),nloads,nincls)';
mx0 = reshape(fmdata0(:,6),nloads,nincls)';
%
%% FY Surface Fit (Zero Slip):
LATE_INCL_VERT = csaps({incls,loads},fy0,.9)
figure('Name',[upper(filename) ': Lateral Force vs. Camber Angle & Vertical Load ' ' william.a.cobb@gm.com'],'numbertitle','off')
fnplt(LATE_INCL_VERT)
xlabel('Camber Angle (deg)')
ylabel('Vertical Load (N)')
zlabel('Lateral Force (N)')
%
%% MZ Surface Fit (Zero Slip):
ALNT_INCL_VERT = csaps({incls,loads},mz0,.9)
figure('Name',[upper(filename) ': Aligning Moment vs. Camber Angle & Vertical Load ' ' william.a.cobb@gm.com'],'numbertitle','off')
fnplt(ALNT_INCL_VERT)
xlabel('Camber Angle (deg)')
ylabel('Vertical Load (N)')
zlabel('Aligning Moment (Nm)')

%% MX Surface Fit (Zero Slip):
OVTM_INCL_VERT = csaps({incls,loads},mx0,.9)
figure('Name',[upper(filename) ': Overturning Moment vs. Camber Angle & Vertical Load ' ' william.a.cobb@gm.com'],'numbertitle','off')
fnplt(OVTM_INCL_VERT)
xlabel('Camber Angle (deg)')
ylabel('Vertical Load (N)')
zlabel('Overturning Moment (Nm)')