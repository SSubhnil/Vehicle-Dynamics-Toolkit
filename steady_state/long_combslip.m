function Fx= long_combslip(alph,k,FZ,FZ0)
RBX1  				= +2.372E+001	;		
RBX2  				= +2.597E+001	;		
RCX1  				= +7.495E-001	;		
REX1  				= -4.759E-001	;		
REX2  				= +8.109E-001	;		
RHX1  				= +0.000E+000	;		
PTX1  				= +0.000E+000	;		
PTX2  				= +0.000E+000	;	
PTX3  				= +0.000E+000	;
PDX1  				= +2.850E+000	;		
PDX2  				= -3.540E-001	;		
PDX3  				= +1.223E+001	;
LFZO  				= 1 ;					
LCX   				= 1 ;					
LMUX  				= 1 ;					
LEX   				= 1 ;					
LKX   				= 1 ;					
LHX   				= 1 ;					
LVX   				= 1 ;					
LGAX  				= 1 ;					
LCY   				= 1 ;					
LMUY  				= 1 ;					
LEY   				= 1 ;					
LKY   				= 1 ;					
LHY   				= 1 ;					
LVY   				= 1 ;					
LGAY  				= 1 ;					
LTR   				= 1 ;					
LRES  				= 0 ;					
LGAZ  				= 1 ;					
LXAL  				= 1 ;					
LYKA  				= 1 ;					
LVYKA 				= 1 ;					
LS    				= 1 ;					
LSGKP 				= 1 ;					
LSGAL 				= 1 ;					
LGYR  				= 1 ;					
LMX   				= 1 ;					
LVMX  				= 1 ;					
LMY   				= 1 ;	
LXAL=1.39;
LFZO=1;
GAMMA=0;
LGAX=1;
LMUX=0.72;
Bxalph= RBX1* cos( atan( RBX2*k))*LXAL;
Cxalph=RCX1;
SHxalph=RHX1;

FZ01=FZ0*LFZO;
dfz=(FZ-FZ01)/FZ01;
Exalph=REX1+REX2*dfz;
FX0=LONFORCE(k,GAMMA,FZ,LFZO,LCX,LMUX,LEX,LKX,LHX,LVX,LGAX,LCY,LMUY,LEY,LKY,LHY,LVY,LGAY,LTR,LRES,LGAZ,LMX,LVMX,LMY,LXAL,LYKA,LVYKA,LS,FZ0)
Dxalph= FX0/(cos(Cxalph*atan(Bxalph*SHxalph-Exalph*(Bxalph*SHxalph-atan(Bxalph*SHxalph)))));
alphs=alph+SHxalph;
Gxalph=cos( Cxalph*atan(Bxalph*alphs-atan(Bxalph*alphs)))/cos(Cxalph*atan(Bxalph*SHxalph-atan(Bxalph*SHxalph)));
Fx=Dxalph*cos(Cxalph*atan(Bxalph*alphs-atan(Bxalph*alphs)));



