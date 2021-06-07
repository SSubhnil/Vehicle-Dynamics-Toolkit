function fy = Pacejka6_Model(P,X)
% x1  = X(:,1);  %Slip
% x2  = X(:,2);  % Fz
D   = (P(1) + P(2)/1000.*X(:,2)).*X(:,2);   % peak value (normalized)
fy  = D.*sin(P(4).*atan(P(3).* (X(:,1)+P(6)))) + P(5) ;