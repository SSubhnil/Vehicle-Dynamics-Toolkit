  clear%%remove the trash
clc%%tidy my screen
load normal_operating_condition_parameters%%load parameters

LONGVL=(70/3.6);
				

choice=menu('Tire Data','Pure Longitudnal Slip','Pure Lateral Slip','Aligning Moment','Combined Lateral Slip','Combined Long Slip','Combined Aligning Moment','Rolling Resistance','Overturning Moment');
switch choice
    case {1}
       z=ones(51,24);%%create some ones to start
l=1;%%number of rows for 'Fx'
[i,k] = meshgrid(-0.25:.01:0.25,5:28);
j=0;
for i=-0.25:0.01:0.25%%slip ratio
    for k=5:1:28%%loads
            z(l,k-4)=LONFORCE(i,j,k*50,LFZ0,LCX,LMUX,LEX,LKX,LHX,LVX,LGAX,LCY,LMUY,LEY,LKY,LHY,LVY,LGAY,LTR,LRES,LGAZ,LMX,LVMX,LMY,LXAL,LYKA,LVYKA,LS,FZ0);
    end
    l=l+1;%%increase one before loop to fill next row
end
i=-0.25:0.01:0.25;
k=250:50:1400;
surf(k,i,z)
xlabel('Loads(N)')
ylabel('Slip Ratio')
zlabel('Longitudnal Force(N)')
title(' FX vs SR , (4ze Racing)')
str={'Pressure=80kPa','Camber=0 degrees'};
dim = [.3 .5 .5 .3];
annotation('textbox',dim,'String',str,'FitBoxToText','on');
grid on
        designation='Pure Longitudnal Slip';
        
        
    case {2}
       z=ones(29,24);%%create some ones to start
l=1;%%number of row for 'Fx' data
[i,k] = meshgrid(-14:1:14,5:28);
j=0;
for i=-14:1:14%%slip ratio
    for k=5:1:28%%loads
            z(l,k-4)=LATFORCE(i,j,k*50,LFZ0,LCX,LMUX,LEX,LKX,LHX,LVX,LGAX,LCY,LMUY,LEY,LKY,LHY,LVY,LGAY,LTR,LRES,LGAZ,LMX,LVMX,LMY,LXAL,LYKA,LVYKA,LS,FZ0);
    end
    l=l+1;%%increase one before loop to fill next row
end
i=-14:1:14;
k=250:50:1400;
surf(k,i,z)
xlabel('Loads(N)')
ylabel('Slip Angles(deg)')
zlabel('Lateral Force(N)')
title('FY vs SA  ,(4ze Racing)')
str={'Pressure=80kPa','Camber=0 degrees'};
dim = [.5 .5 .3 .3];
annotation('textbox',dim,'String',str,'FitBoxToText','on');
grid on
        designation='Pure Lateral Slip';

    case{3}

       z=ones(161,24);%%create some ones to start
l=1;%%number of row for 'Fx' data
[i,k] = meshgrid(-8:0.1:8,5*50:28*50);
j=0;
for i=-8:0.1:8%%slip ratio
    for k=5:1:28%%loads
            z(l,k-4)=ALIGNMOMENT(i,j,k*50,LFZ0,LCX,LMUX,LEX,LKX,LHX,LVX,LGAX,LCY,LMUY,LEY,LKY,LHY,LVY,LGAY,LTR,LRES,LGAZ,LMX,LVMX,LMY,LXAL,LYKA,LVYKA,LS,FZ0);
    end
    l=l+1;%%increase one before loop to fill next row
end
i=-8:0.1:8;
k=250:50:1400;
surf(k,i,z)
xlabel('Loads(N)')
ylabel('Slip Angles(deg)')
zlabel('Aligning Moment(N-m)')
title(' MZ vs SA , (4ze Racing)')
str={'Pressure=80kPa','Camber=0 degrees'};
dim = [.3 .5 .5 .3];
annotation('textbox',dim,'String',str,'FitBoxToText','on');
grid on
        designation='Aligning Moment';
        
        case{4}

       z=ones(161,24);%%create some ones to start
m=1;%%number of row for 'Fx' data
[l,k] = meshgrid(-8:0.1:8,5*50:28*50);
j=5;
for i=0%%slip ratio
    for l=-8:0.1:8%%SA
        
    for k=5:1:28%%loads
        
       [GYK,DYK,CYK,BYK,KS,EYK,SVYK,SHYK]= COEFFICIENT(l,i,j,k*50,LFZ0,LCX,LMUX,LEX,LKX,LHX,LVX,LGAX,LCY,LMUY,LEY,LKY,LHY,LVY,LGAY,LTR,LRES,LGAZ,LMX,LVMX,LMY,LXAL,LYKA,LVYKA,LS,FZ0);
          z(m,k-4)=LATFORCECS1(GYK,DYK,CYK,BYK,KS,EYK,SVYK,SHYK) ;
   
    end
   m=m+1; 
    end
    %%increase one before loop to fill next row
end
l=-8:0.1:8;
k=250:50:1400;
surf(k,l,z)
xlabel('Loads(N)')
ylabel('Slip Angles(deg)')
zlabel('Combined Lateral Force(N)')
title(' FY vs SA , (4ze Racing)')
str={'Pressure=80kPa','Camber=0 degrees'};
dim = [.3 .5 .5 .3];
annotation('textbox',dim,'String',str,'FitBoxToText','on');
grid on
        designation='Combined Lateral Slip';

 case {5}
       l=1;%%number of rows for 'Fx'
[i,k] = meshgrid(-0.25:.01:0.25,5:28);
j=0;
for s=0
    for i=-0.25:0.01:0.25
        for k=5:1:28%%loads
            z(l,k-4)=long_combslip(s,i,k*50,FZ0);
    end
    l=l+1;%%increase one before loop to fill next row
    end

i=-0.25:0.01:0.25;
k=250:50:1400;
surf(k,i,z)
end
xlabel('Loads(N)')
ylabel('Slip Ratio')
zlabel('Longitudnal Force(N)')
title(' FX vs SR , (4ze Racing)')
str={'Pressure=80kPa','Camber=0 degrees'};
dim = [.3 .5 .5 .3];
annotation('textbox',dim,'String',str,'FitBoxToText','on');
grid on
        designation='Combined Long Slip';

case{6}

       z=ones(161,24);%%create some ones to start
m=1;%%number of row for 'Fx' data
[l,k] = meshgrid(-8:0.1:8,5*50:28*50);
j=0;
for i=0%%slip ratio
    for l=-8:0.1:8%%SA
        
    for k=5:1:28%%loads
        
       z(m,k-4)=ALIGNMOMENTCS(l,i,j,k*50,LFZ0,LCX,LMUX,LEX,LKX,LHX,LVX,LGAX,LCY,LMUY,LEY,LKY,LHY,LVY,LGAY,LTR,LRES,LGAZ,LMX,LVMX,LMY,LXAL,LYKA,LVYKA,LS,FZ0);
   
    end
   m=m+1; 
    end
    %%increase one before loop to fill next row
end
l=-8:0.1:8;
k=250:50:1400;
surf(k,l,z)
xlabel('Loads(N)')
ylabel('Slip Angles(deg)')
zlabel('Combined Lateral Force(N)')
title(' FY vs SA , (4ze Racing)')
str={'Pressure=80kPa','Camber=0 degrees'};
dim = [.3 .5 .5 .3];
annotation('textbox',dim,'String',str,'FitBoxToText','on');
grid on
        designation='Combined Aligning Moment';
   
    case {7}
       z=ones(51,24);%%create some ones to start
l=1;%%number of rows for 'Fx'
[i,k] = meshgrid(-0.25:.01:0.25,5:28);
j=0;
for i=-0.25:0.01:0.25%%slip ratio
    for k=5:1:28%%loads
            z(l,k-4)=ROLLINRESIST(i,j,k*50,LFZ0,LCX,LMUX,LEX,LKX,LHX,LVX,LGAX,LCY,LMUY,LEY,LKY,LHY,LVY,LGAY,LTR,LRES,LGAZ,LMX,LVMX,LMY,LXAL,LYKA,LVYKA,LS,LONGVL,FZ0);
    end
    l=l+1;%%increase one before loop to fill next row
end
i=-0.25:0.01:0.25;
k=250:50:1400;
surf(k,i,z)
xlabel('Loads(N)')
ylabel('Slip Ratio')
zlabel('Longitudnal Force(N)')
title(' FX vs SR , (4ze Racing)')
str={'Pressure=80kPa','Camber=0 degrees'};
dim = [.3 .5 .5 .3];
annotation('textbox',dim,'String',str,'FitBoxToText','on');
grid on
        designation='Rolling Resistance';
        
        case {8}
       z=ones(161,24);%%create some ones to start
l=1;%%number of rows for 'Fx'
[i,k] = meshgrid(-8:0.1:8,5:28);
j=0;
for i=-8:0.1:8%%slip ratio
    for k=5:1:28%%loads
            z(l,k-4)=OVERTURNMOMENT(i,j,k*50,LFZ0,LCX,LMUX,LEX,LKX,LHX,LVX,LGAX,LCY,LMUY,LEY,LKY,LHY,LVY,LGAY,LTR,LRES,LGAZ,LMX,LVMX,LMY,LXAL,LYKA,LVYKA,LS,FZ0);
    end
    l=l+1;%%increase one before loop to fill next row
end
i=-8:0.1:8;
k=250:50:1400;
surf(k,i,z)
xlabel('Loads(N)')
ylabel('Slip Ratio')
zlabel('Longitudnal Force(N)')
title(' FX vs SR , (4ze Racing)')
str={'Pressure=80kPa','Camber=0 degrees'};
dim = [.3 .5 .5 .3];
annotation('textbox',dim,'String',str,'FitBoxToText','on');
grid on
        designation='Overturning Moment';
        
end;