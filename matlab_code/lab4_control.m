function [x1_vector, x2_vector, x1_obs, x2_obs,u_vector, time_vector] = lab4_control(setpos, a)

Vref_arduino = 4.9748;
V_7805 = 5.5730;

Tm = 0.55;
ku = 1/36;
k0 = 0.25;
kt = 0.00361;
km = 249.3;

k2 = 8.5;
P1 = (1/Tm)*(k2*kt*km+1);
P2 = (P1^2)/4;
k1 = ((Tm*P2*kt)/(ku*k0*(P1*Tm-1)))*k2;
kr = k1;
l1 = -80;
l2 = -10;
L = L_fun(l1,l2);

maxIterations = 300;
x1_vector = zeros(1, maxIterations);
x2_vector = zeros(1, maxIterations);
x1_obs = zeros(1, maxIterations);
x2_obs = zeros(1, maxIterations);
time_vector = zeros(1, maxIterations);
u_vector = zeros(1, maxIterations);

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
u_vector(1) = 0;

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
    u = -k1*x1_obs(i-1)-k2*x2_obs(i-1)+kr*setpos;
    x1_obs(i) = x1_obs(i-1)+(((ku*k0)/kt)*x2_obs(i-1)+L(1)*(x1_vector(i-1)-x1_obs(i-1)))*dt;
    x2_obs(i) = x2_obs(i-1)+(-(1/Tm)*x2_obs(i-1)+(kt*km*u)/(Tm)+L(2)*(x1_vector(i-1)-x1_obs(i-1)))*dt;
    time_vector(i) = t1;
    
    if abs(u) > 10
        u = sign(u) * 10;
    end
    if u>0
        analogWrite(a,6,0)
        analogWrite(a,9,min(round(u / 2 * 255 / Vref_arduino) , 255))
    else
        analogWrite(a,9,0)
        analogWrite(a,6,min(round(-u / 2 * 255 / Vref_arduino) , 255))
    end
    u_vector(i) = u;
end
    analogWrite(a,6,0)
    analogWrite(a,9,0)
    %%
set(groot,'defaultLineLineWidth',1.5)

figure(1); clf;    
hold on
plot(time_vector,x2_vector)
plot(time_vector,x2_obs)
ylim([-50 20]);
legend('x2 velocity', 'observe x2');
grid on

figure(2); clf;
hold on
plot(time_vector, x1_vector)
plot(time_vector,x1_obs)
legend('x1 position', 'observe x1');
grid on

%%
%save('results/diorthlab4control_k2='+string(k2)+'_k1+'+string(k1)+'_l1='+string(l1)+'_l2='+string(l2)+...
%'apo2se5.mat','x1_vector', 'x1_obs','x2_vector','x2_obs','u_vector','time_vector',...
% 'k1', 'k2', 'kr', 'Tm', 'ku', 'k0', 'kt', 'km','l1','l2')
%POS
