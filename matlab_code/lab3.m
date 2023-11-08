function [x1_vector, x2_vector, u_vector, time_vector, z_vector] = lab3(setpos, a)

Vref_arduino = 4.9748;
V_7805 = 5.5730;

Tm = 0.55;
ku = 1/36;
k0 = 0.25;
kt = 0.00361;
km = 249.3;

k1 = 5; % k1 > (Tm*ki)/(1+kt*km*k2) από θεωρητική ανάλυση
k2 = 3; % k2 > -1/(kt*km) = -1.111POS111 από θεωρητική ανάλυση
ki = 5; % ki > 0 από θεωρητική ανάλυση

if k1 <= (Tm*ki)/(1+kt*km*k2)
    disp('Not valid choice for k1')
    k1 = (Tm*ki)/(1+kt*km*k2) + 1;
    disp('k1 =' + string(k1) + 'chosen instead')
end
maxIterations = 300;
x1_vector = zeros(1, maxIterations);
x2_vector = zeros(1, maxIterations);
z_vector = zeros(1, maxIterations);
time_vector = zeros(1, maxIterations);
u_vector = zeros(1, maxIterations);



velocity = analogRead(a,3);
position = analogRead(a,5);
x1 = 3 * Vref_arduino * position/1024;
x2 = 2 * (2 * velocity * Vref_arduino / 1024 - V_7805);
x1_vector(1) = x1;
x2_vector(1) = x2;
z_vector(1) = -2.5;
time_vector(1) = 0;
u_vector(1) = 0;
tic;

i = 1;
while i < maxIterations
    i = i + 1;
    velocity = analogRead(a,3);
    position = analogRead(a,5);

    x1 = 3 * Vref_arduino * position/1024;
    x2 = 2 * (2 * velocity * Vref_arduino / 1024 - V_7805);
    u = -k1*x1-k2*x2-ki*z_vector(i-1);
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

    dt =toc - time_vector(i-1);
    
    x1_vector(i) = x1;
    x2_vector(i) = x2;
    u_vector(i) = u;
    z_vector(i) = z_vector(i-1) + (x1-setpos)*dt;
    time_vector(i) = toc;
end

analogWrite(a,6,0)
analogWrite(a,9,0)
%%
figure(1); clf;   
set(groot,'defaultLineLineWidth',1.0)
plot(time_vector, x1_vector)
hold on
plot(time_vector, x2_vector)
plot(time_vector, u_vector)
plot(time_vector, z_vector)

ylim([-7 9]);
xlabel('Time')
grid on
legend('x1 position', 'x2 velocity', 'u', 'z');
save('results/Plab3_k1='+string(k1)+'_k2='+string(k2)+'_ki='+string(ki)+'z(1)='+string(z_vector(1))+'apo2se5.mat',...
'x1_vector','x2_vector','u_vector','time_vector','z_vector', 'k1', 'k2', 'ki', 'Tm', 'ku', 'k0', 'kt', 'km')
POS

