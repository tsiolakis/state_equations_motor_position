function [x1_vector, x2_vector, x1_obs, x2_obs, time_vector] = lab4_test_observer(u, a)


Vref_arduino = 4.9748;
V_7805 = 5.5730;

Tm = 0.55;
ku = 1/36;
k0 = 0.25;
kt = 0.00361;
km = 249.3;
l1 = -10;
l2 = -80;
L = L_fun(l1,l2);

%diegersh tou systhmatos
analogWrite(a,6,0);
analogWrite(a,9,min(round(u / 2 * 255 / Vref_arduino) , 255));

maxIterations = 300;
x1_vector = zeros(1, maxIterations);
x2_vector = zeros(1, maxIterations);
x1_obs = zeros(1, maxIterations);
x2_obs = zeros(1, maxIterations);
time_vector = zeros(1, maxIterations);
test_vec = zeros(1,maxIterations);

tic;

velocity = analogRead(a,3);
position = analogRead(a,5);
x1 = 3 * Vref_arduino * position/1024;
x2 = 2 * (2 * velocity * Vref_arduino / 1024 - V_7805);
t1 = toc;
x1_vector(1) = x1;
x2_vector(1) = x2;
x1_obs(1) = x1;
x2_obs(1) = x2;
time_vector(1) = t1;
test_vec(1) = 0;

i = 1;
while i < maxIterations
    i = i + 1;
    
    velocity = analogRead(a,3);
    position = analogRead(a,5);
    x1 = 3 * Vref_arduino * position/1024;
    x2 = 2 * (2 * velocity * Vref_arduino / 1024 - V_7805);
    
    t2 = toc;
    dt = t2 - t1;
    t1 = t2;
    
    x1_vector(i) = x1;
    x2_vector(i) = x2;
    
    x1_obs(i) = x1_obs(i-1)+(((ku*k0)/kt)*x2_obs(i-1)+L(1)*(x1_vector(i-1)-x1_obs(i-1)))*dt;
    x2_obs(i) = x2_obs(i-1)+(-(1/Tm)*x2_obs(i-1)+((kt*km*u)/(Tm))+L(2)*(x1_vector(i-1)-x1_obs(i-1)))*dt;
    test_vec(i) = x1_vector(i-1)-x1_obs(i-1);
    time_vector(i) = t1;
end
    analogWrite(a,6,0)
    analogWrite(a,9,0)
    %%

set(groot,'defaultLineLineWidth',1.5)

figure(1); clf;    
hold on
plot(time_vector,x2_vector)
plot(time_vector,x2_obs)
ylim([-30 20]);
legend('x2 velocity', 'observe x2');
grid on

figure(2); clf;
hold on
plot(time_vector, x1_vector)
plot(time_vector,x1_obs)
legend('x1 position', 'observe x1');
grid on

% save('results/MAKROSKOPIKlab4test_l1='+string(l1)+'_l2='+string(l2)+'_apo2se5.mat',...
% 'x1_vector', 'x1_obs','x2_vector','x2_obs','time_vector',...
% 'Tm', 'ku', 'k0', 'kt', 'km','l1','l2');
% POS
