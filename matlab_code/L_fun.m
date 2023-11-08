% This function is used in lab4_test_observer.m to calculate matrix L
function [L] = L_fun(l1,l2)
Tm = 0.55;
ku = 1/36;
k0 = 0.25;
kt = 0.00361;
km = 249.3;

p1 = -(l1+l2);
p2 = l1*l2;
% syms Tm ku k0 kt km p1 p2
A = [0 ku*k0/kt; 0 -1/Tm];
B = [0; kt*km/Tm];
C = [1 0];
W = [C;C*A];
Wper = inv([1 0; 1/Tm 1]);




L = inv(W) * Wper * [p1-(1/Tm);p2];

end

