function [GYK,DYK,CYK,BYK,KS,EYK,SVYK,SHYK]= COEFFICIENT(ALPHA,K,GAMMA,FZ,LFZ0,LCX,LMUX,LEX,LKX,LHX,LVX,LGAX,LCY,LMUY,LEY,LKY,LHY,LVY,LGAY,LTR,LRES,LGAZ,LMX,LVMX,LMY,LXAL,LYKA,LVYKA,LS,FZ0)

%%%-------------------------------------------------Lateral Coefficients%%%
%pg 48
PCY1				= +1.434E+000;		
PDY1				= +2.716E+000;		
PDY2				= -5.444E-001;			
PDY3				= +5.190E+000;			
PEY1				= -4.869E-001;			
PEY2				= -1.487E+000;			
PEY3				= +6.282E-002;			
PEY4				= +1.154E+000;			
PKY1				= -5.322E+001;			
PKY2				= +2.060E+000;			
PKY3				= +8.336E-001;			
PHY1				= +0.000e+000;		
PHY2				= +0.000e+000;		
PHY3				= -2.030E-002;			
PVY1				= +0.000e+000;		
PVY2				= +0.000e+000;		
PVY3				= -2.713E+000;			
PVY4				= -1.517E+000;
%pg 50
%pg 55
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
%
%??
PTY1				= +1.941e+000;			
PTY2				= +2.093e+000;	


ALPHA=ALPHA*(pi/180);
GAMMA=GAMMA*(pi/180);

dFZ=(FZ-FZ0*LFZ0)/(FZ0*LFZ0);

SHYK=RHY1+(RHY2*dFZ);
KS=K+SHYK;

BYK=RBY1*cos(atan(RBY2*(ALPHA-RBY3)))*LYKA;
CYK=RCY1;
GAMMAY=GAMMA*LGAY;
SHY=(PHY1+PHY2*dFZ)*LHY+PHY3*GAMMAY;
ALPHAY=ALPHA+SHY;KY=PKY1*FZ0*sin(2*atan(FZ/(PKY2*FZ0*LFZ0)))*(1-PKY3*abs(GAMMAY))*LFZ0*LKY;



CY=PCY1*LCY;
MUY=(PDY1+PDY2*dFZ)*(1-PDY3*GAMMAY^2)*LMUY;
DY=MUY*FZ;
BY=KY/(CY*DY);

EY=(PEY1+PEY2*dFZ)*(1-(PEY3+PEY4*GAMMAY)*sign(ALPHAY))*LEY;

SVY=FZ*((PVY1+PVY2*dFZ)*LVY+(PVY3+PVY4*dFZ)*GAMMAY)*LMUY;

FY=DY*sin(CY*atan(BY*ALPHAY-EY*(BY*ALPHAY-atan(BY*ALPHAY))))+SVY;

BYK=RBY1*cos(atan(RBY2*(ALPHA-RBY3)))*LYKA;
CYK=RCY1;
EYK=REY1+(REY2*dFZ);
GAMMAY=GAMMA*LGAY;
DYK=(FY)/(cos(CYK*atan((BYK*SHYK)-(EYK*((BYK*SHYK)-atan(BYK*SHYK))))));
MUY=(PDY1+PDY2*dFZ)*(1-PDY3*GAMMAY^2)*LMUY;
DVYK=MUY*FZ*(RVY1+(RVY2*dFZ)+(RVY3*GAMMA))*cos(atan(RVY4*ALPHA));
SVYK=DVYK*sin(RVY5*atan(RVY6*K))*LVYKA;

GYK=(cos(CYK*atan((BYK*KS)-(EYK*((BYK*KS)-(atan(BYK*KS)))))))/(cos(CYK*atan((BYK*SHYK)-(EYK*((BYK*SHYK)-atan(BYK*SHYK))))));

end





