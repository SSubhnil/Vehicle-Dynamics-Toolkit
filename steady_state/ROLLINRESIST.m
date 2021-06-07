function MY=ROLLINRESIST(K,GAMMA,FZ,LFZ0,LCX,LMUX,LEX,LKX,LHX,LVX,LGAX,LCY,LMUY,LEY,LKY,LHY,LVY,LGAY,LTR,LRES,LGAZ,LMX,LVMX,LMY,LXAL,LYKA,LVYKA,LS,LONGVL,FZ0)

%%%[LONGITUDINAL_COEFFICIENTS]
PCX1  				= +1.786E+000;			
PDX1  				= +2.850E+000;			
PDX2  				= -3.540E-001;			
PDX3  				= +1.223E+001;			
PEX1  				= +8.710E-001;			
PEX2  				= -3.800E-002;			
PEX3  				= +0.000E+000;			
PEX4  				= +7.100E-002;			
PKX1  				= +8.125E+001;			
PKX2  				= -2.025E+001;			
PKX3  				= +5.000E-001;		
PHX1  				= +0.000E+000;			
PHX2  				= +0.000E+000;		
PVX1  				= +0.000E+000;			
PVX2  				= +0.000E+000;		
RBX1  				= +2.372E+001;			
RBX2  				= +2.597E+001;			
RCX1  				= +7.495E-001;		
REX1  				= -4.759E-001;		
REX2  				= +8.109E-001;			
RHX1  				= +0.000E+000;			
PTX1  				= +0.000E+000;			
PTX2  				= +0.000E+000;			
PTX3  				= +0.000E+000;

%%%[ROLLING_COEFFICIENTS]
QSY1 				= -2.367E-002;			
QSY2 				= +0.000e+000;			
QSY3 				= +0.000e+000;			
QSY4 				= +0.000e+000;	


GAMMA=GAMMA*(pi/180);
GAMMAX=GAMMA*LGAX;

dFZ=(FZ-FZ0*LFZ0)/(FZ0*LFZ0);

SHX=(PHX1+(PHX2*dFZ))*LHX;
KX=K+SHX;
MUX=(PDX1+(PDX2*dFZ))*(1-(PDX3*GAMMAX^2))*LMUX;
DX=MUX*FZ;
CX=PCX1*LCX;
kX=FZ*(PKX1+(PKX2*dFZ))*exp(PKX3*dFZ)*LKX;
BX=kX/(CX*DX);
EX=(PEX1+(PEX2*dFZ)+(PEX3*dFZ^2))*(1-(PEX4*sign(KX)))*(LEX);
SVX=FZ*(PVX1+(PVX2*dFZ))*LVX*LMUX;
R0=0.235;

FX=DX*sin(CX*atan((BX*KX)-(EX*((BX*KX)-atan(BX*KX)))))+SVX;

MY=R0*FZ*(QSY1+(QSY2*(FX/FZ0))+(QSY3*abs(LVX/LONGVL))+(QSY4*((LVX/LONGVL)^4)));