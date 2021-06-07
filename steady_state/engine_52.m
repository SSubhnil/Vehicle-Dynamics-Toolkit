function Radius_Error = engine_52(delta)

%This function takes in Delta value (from an initial TARGET guess). See line
%479 of nonlin.m. And updates the reqd. global variables. nonlin then stores the data in an array for each
%speed and delta (481 onwards).

%This subfunction computes vehicle dynamics of a 2 DOF system as a
% starting example for a FSAE Simulationist.  There is NO roll degree of
% freedom, but I simulated load transfer by applying load transfers
% proportional to lateral acceleration. 

% A few notes and disclaimers:

% Units are engineering practise (as in what comes off instrumentation),
% so its deg, kg, N, g, you get the idea.  Purists should go shovel a
% sidewalk.

% The same tire is used front and rear. That's just a convenience here. Use
% a different one on each wheel for all I care...
% Weights are inverted to produce an understeering car as a first form.
% Consider removing the aligning moment reactons and see what happens. 
% It can make quite a difference.

% The format is of a constant radius test, but you can probably guess what
% it takes to produce a step, pulse, frequency response, sine, and constant
% speed tests.  They are all important functions to explore the dynamics
% with.  This is actually a smll time based simulation run out to steady
% state to get ending values.  The transients ought to be just as useful.

% Crude (but fair) yaw inertia estimate. BFD for a constant speed test.
% Probably a good first order estimate of steering moments coming out of
% the front tire moments if you care to add the geometric effects.
% A good simulaton comes from piling on more and more complexity until it
% answers basic questions with the known answers. Then you can move on to
% the unknown ones.

% You can easily take these results and produce Understeer, Cornering
% Compliances, Sideslip gain, and Tangent Speed from just the results table.

% Add a roll degree of freedom and couple the roll steer and camber
% influence coefficients to the slip angle variables.  Then you will be ready for prime time.

% You will need to FSAE.mat file containing a sample Matlab Spline tire
% function to run this example.  All the other tire models (Pacejka, MRA,
% Fiala, LapSim, etc, will work too. Watch your signs and input units.

% When you get a Roll DOF in here, add the OVTM data and watch what it does
% to your max lat results...

%  Bill Cobb
%  zzvyb6@yahoo.com

%  I Used to do this for a living. Now I play with boats, tractors,
%  snowmobiles and Laborador Retrievers.

global WF WR L SPEED TARGET A B IZZ TF1 TF2 TF3 TR1 TR2 TR3
global R BETA AYG MAX_SPEED ALPHALF ALPHARF ALPHAR CAMG CAM0 ALPHAF
global ENFB ENFC RADIUS DELTA TOEIN WHL_LIFT RGRAD TLLTD WT

enf  = 0;
u    = SPEED/3.6;
R    = 0;    %initial condition for yaw rate
BETA = 0; % initial condition for sideslip
AYG  = 0;
WHL_LIFT = [0 0];

WLF  = WF/2;
WRF  = WF/2;
WLR  = WR/2;
WRR  = WR/2;

dt   =.01;
for t= 0:dt:2.0   % 2.0 seconds ought to do it.
    %[wlf,wrf,wlr,wrr]=weight(WLF,WRF,WLR,WRR)
    DelWR=(TR1*AYG)*TR2+(TR3*AYG);%Total load transfer elastic, kinematic, unsprung
    DelWF=(TF1*AYG)*TF2+(TF3*AYG);
    wlf=WLF+DelWF;%loads after transfer
    wrf=WRF-DelWF;
    wlr=WLR+DelWR;
    wrr=WRR-DelWR;
    %WTraR=DelWR/KrR;
    %WTraF=DelWF/KrF;
    TLLTD=DelWR/(DelWR+DelWF)*100;%rear biased
    WT=(DelWR+DelWF)/(WF+WR)*100;
    
    if(wrf <=0) 
        wrf=0;
        WHL_LIFT(1) =1;
    end
    if(wrr <=0) 
        wrr=0;
        WHL_LIFT(2) =1;
    end
    
    ALPHAF =  BETA + A*R/u - delta + enf;   
    ALPHAR =  BETA - B*R/u; 
    
    ALPHALF= ALPHAF-TOEIN/2;
    ALPHARF= ALPHAF+TOEIN/2;
    
    GAMMAL=CAM0+(RGRAD*AYG*CAMG);%Camber angle
    GAMMAR=CAM0-(RGRAD*AYG*CAMG);
      
    %2nd part of calling function looks for closest match  for SA and FZ from the look-out table.
    %FY & MZ carry coefficients from the nonlin       
    fylf   = LATFORCE(ALPHALF,GAMMAL,wlf); %Nonlinear tire FY representation
    fyrf   = LATFORCE(ALPHARF,GAMMAR,wrf); %
    fylr   = LATFORCE(ALPHAR,0,wlr); %
    fyrr   = LATFORCE(ALPHAR,0,wrr); %

    nlf    = ALIGNMOMENT(ALPHALF,GAMMAL,wlf); % Nonlinear tire MZ representation
    nrf    = ALIGNMOMENT(ALPHARF,GAMMAR,wrf);%
    nlr    = ALIGNMOMENT(ALPHAR,0,wlr);
    nrr    = ALIGNMOMENT(ALPHAR,0,wrr);
  
    fyf    = fylf + fyrf;
    fyr    = fylr + fyrr;
    
    nf     = nlf + nrf;
    enf    = -sign(nf).*ENFB*ENFC/100.*log(abs(nf)./ENFC+1)/2;
  
    rd     = (180/pi)*(A*fyf - B*fyr +nlf +nrf +nlr +nrr) /IZZ;
    betad  = (180/pi)*(fyf + fyr)/(WF + WR)/u - R;
    R      = R    + rd*dt;
    BETA   = BETA + betad*dt;
    AYG    = u*(R + betad)/(180/pi)/9.806 ;
end

DELTA      = delta;   % cheezy workaround for global pass.
RADIUS     = (180/pi)*u/R;       % return a turn radius error value.
Radius_Error = TARGET -RADIUS;      % return a turn radius error value.
end