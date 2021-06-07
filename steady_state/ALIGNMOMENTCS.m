function MZ=ALIGNMOMENTCS(ALPHA,K,GAMMA,FZ,LFZ0,LCX,LMUX,LEX,LKX,LHX,LVX,LGAX,LCY,LMUY,LEY,LKY,LHY,LVY,LGAY,LTR,LRES,LGAZ,LMX,LVMX,LMY,LXAL,LYKA,LVYKA,LS,FZ0)

%%%[LATERAL_COEFFICIENTS]
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

%%%[ALIGNING_COEFFICIENTS]
QBZ1				= +1.182E+001;			
QBZ2				= +1.597E-001;		
QBZ3				= -2.500E+000;			
QBZ4				= +8.705E+000;			
QBZ5				= +8.085E+000;			
QBZ9				= -2.826E+001;		
QBZ10				= -3.998E+000;	
QCZ1				= +1.256E+000;		
QDZ1				= +1.215E-001;		
QDZ2				= -1.553E-002;			
QDZ3				= -4.733E-002;			
QDZ4				= -1.210E+001;			
QDZ6				= -1.554E-003;			
QDZ7				= -1.318E-002;			
QDZ8				= -1.089E+000;			
QDZ9				= -1.988E-001;			
QEZ1				= -1.114E+000;			
QEZ2				= -2.652E-001;			
QEZ3				= -1.712E+000;			
QEZ4				= +2.531E-001;			
QEZ5				= -3.851E+000;		
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
%%Pure Lat Slip

ALPHA=ALPHA*(pi/180);
GAMMA=GAMMA*(pi/180);
GAMMAY=GAMMA*LGAY;

dFZ=(FZ-FZ0*LFZ0)/(FZ0*LFZ0);

SHY=(PHY1+PHY2*dFZ)*LHY+PHY3*GAMMAY;
ALPHAY=ALPHA+SHY;KY=PKY1*FZ0*sin(2*atan(FZ/(PKY2*FZ0*LFZ0)))*(1-PKY3*abs(GAMMAY))*LFZ0*LKY;



CY=PCY1*LCY;
MUY=(PDY1+PDY2*dFZ)*(1-PDY3*GAMMAY^2)*LMUY;
DY=MUY*FZ;
BY=KY/(CY*DY);

EY=(PEY1+PEY2*dFZ)*(1-(PEY3+PEY4*GAMMAY)*sign(ALPHAY))*LEY;

SVY=FZ*((PVY1+PVY2*dFZ)*LVY+(PVY3+PVY4*dFZ)*GAMMAY)*LMUY;

FY=DY*sin(CY*atan(BY*ALPHAY-EY*(BY*ALPHAY-atan(BY*ALPHAY))))+SVY;

%%Pure Long Slip
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

FX=DX*sin(CX*atan((BX*KX)-(EX*((BX*KX)-atan(BX*KX)))))+SVX;

%%Pure Align Moment
GAMMAZ=GAMMA*LGAZ;

CT=QCZ1;

BR=((QBZ9*LKY)/LMUY)+(QBZ10*BY*CY);
BT=(QBZ1+(QBZ2*dFZ)+(QBZ3*dFZ^2))*(1+(QBZ4*(GAMMAZ))+(QBZ5*abs(GAMMAZ)))*(LKY/LMUY);
R0=0.235;
DT=FZ*(QDZ1+(QDZ2*dFZ))*(1+(QDZ3*GAMMAZ)+(QDZ4*(GAMMAZ^2)))*(R0/FZ0)*LTR;
DR=FZ*(((QDZ6+(QDZ7*dFZ))*LRES)+((QDZ8+(QDZ9*dFZ))*GAMMAZ))*R0*LMUY;
SHT=QHZ1+(QHZ2*dFZ)+((QHZ3+(QHZ4*dFZ))*GAMMAZ);

SHF=SHY+(SVY/KY);
ALPHAT=ALPHA+SHT;
ALPHAR=ALPHA+SHF;

ET=(QEZ1+(QEZ2*dFZ)+(QEZ3*dFZ^2))*(1+(QEZ4+(QEZ5*GAMMAZ))*(2/pi)*atan(BT*CT*ALPHAT));
t=(DT)*(cos(CT*atan((BT*ALPHAT)-(ET*((BT*ALPHAT)-(atan(BT*ALPHAT)))))))*(cos(ALPHA));
MZR=DR*cos(atan(BR*ALPHAR))*cos(ALPHA);

FY=DY*sin(CY*atan(BY*ALPHAY-EY*(BY*ALPHAY-atan(BY*ALPHAY))))+SVY;
MZ=-t*FY+MZR;
MUY=(PDY1+PDY2*dFZ)*(1-PDY3*GAMMAY^2)*LMUY;
DVYK=MUY*FZ*(RVY1+(RVY2*dFZ)+(RVY3*GAMMA))*cos(atan(RVY4*ALPHA));
SVYK=DVYK*sin(RVY5*atan(RVY6*K))*LVYKA;

%%Lets begin 

FY1=FY-SVYK;
ALPHAreq=atan(sqrt((((tan(ALPHA)))^2)+(((KX/KY)^2)*K^2)))*(sign(ALPHAR));
MZR=DR*(cos(atan(BR*ALPHAreq)))*cos(ALPHA);
S=(SSZ1+(SSZ2*(FY/FZ0))+((SSZ3+(SSZ4*dFZ))*GAMMA))*(R0*LS);

MZ=(-t*FY1)+MZR+(S*FX);

