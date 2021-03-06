function fy = Pacejka4_Model(P,X)

x1  = X(:,1);  %Slip
x2  = X(:,2);  % Fz
D1  = P(1);
D2  = P(2);
B   = P(3);
C   = P(4);
D   = (D1 + D2/1000.*x2).*x2;   % peak value (normalized
fy  = D.*sin(C.*atan(B.*x1));