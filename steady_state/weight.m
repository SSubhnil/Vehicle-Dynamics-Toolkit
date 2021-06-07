function [WN1,WN2,WN3,WN4]=Suspension(W1,W2,W3,W4)
global TLLTD AYG WT TF1 TF2 TF3 TR1 TR2 TR3
%{
FTrack=1.2;
RTrack=1.2;
Wt=WF+WR;
WDist=WR/Wt;
WuR=WR*0.3;%unsprung is 20% of total rear weight
WuF=WF*0.2;
Ws=Wt-Wt*0.255;%unsprung mass is 25% of total mass
TrackSpr=0.850;%Spring track on beam. Try to get higher closer to 0.950
CGH=0.240;
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
KwF=(MRf^2)*SPF;
KwR=(MRr^2)*SPR;
KrF=(KwF+Kt)/(Kt*KwF);
KrR=(KwR+Kt)/(Kt*KwR);
%Roll Rates obtained through Ride Rates
KphiF=(KrF*(FTrack^2)/2);%for front SLA (LETS PLAY!!! WITH ROLL RATES) actually the last term is being used to manipulate the kphi
KphiR=((Kt*(RTrack^2)/2)*(KwR*(TrackSpr^2)/2))/((Kt*(RTrack^2)/2)+(KwR*(TrackSpr^2)/2));%rear beam
RGRAD=Ws*Hs/(KphiR+KphiF)*(57.3);
Kphi=KphiF+KphiR;%rear biased
%}
DelWR=(TR1*AYG)*TR2+(TR3*AYG);%Total load transfer elastic, kinematic, unsprung
DelWF=(TF1*AYG)*TF2+(TF3*AYG);
WN1=W1-DelWF;%loads after transfer
WN2=W2+DelWF;
WN3=W3-DelWR;
WN4=W4+DelWR;
WTraR=DelWR/KrR;
WTraF=DelWF/KrF;
TLLTD=DelWR/(DelWR+DelWF)*100;%rear biased
WT=(DelWR+DelWF)/Wt;
%{
WuF=WuF/9.81;
WuR=WuR/9.81;
Wsr=Ws*WDist/9.81;
Wsf=(Ws/9.81)-Wsr;
Wr=Wt*WDist/9.81;
Wf=(Wt-Wr)*9.81;
%}
%DamperCalc(KwF,KwR,KrF,KrR,Wf,Wr,Wsf,Wsr,WuF,WuR);
end