function FYCS=LATFORCECS1(GYK,DYK,CYK,BYK,KS,EYK,SVYK,SHYK)

FYCS=DYK*cos(CYK*atan((BYK*SHYK)-(EYK*((BYK*SHYK)-atan(BYK*SHYK)))));