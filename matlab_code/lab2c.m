function [x1_vector, x2_vector, u_vector, time_vector, theta_ref] = lab2c(freq, a)

Vref_arduino = 4.9748;
V_7805 = 5.5730;

Tm = 0.55;
ku = 1/36;
k0 = 0.25;
kt = 0.00361;
km = 249.3;

k2 = 8.5
P1 = (1/Tm)*(k2*kt*km+1);
P2 = (P1^2)/4;
k1 = ((Tm*P2*kt)/(ku*k0*(P1*Tm-1)))*k2
kr = k1;
maxIterations = 2000;
i = 0;

x1_vector = zeros(1, maxIterations);
x2_vector = zeros(1, maxIterations);
u_vector = zeros(1, maxIterations);
time_vector = zeros(1, maxIterations);
theta_ref = zeros(1, maxIterations);
setpos = 5;
tic
while i < maxIterations
    i = i + 1;
    theta_ref(i) = setpos;
    velocity = analogRead(a,3);
    position = analogRead(a,5);
    x1 = 3 * Vref_arduino * position/1024;
    x2 = 2 * (2 * velocity * Vref_arduino / 1023 - V_7805);

    u = -k1*x1-k2*x2+kr*setpos;
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
    x1_vector(i) = x1;
    x2_vector(i) = x2;
    u_vector(i) = u;
    t = toc;
    time_vector(i) = t;
    setpos = 5 + 2*sin(freq*t);
end
    analogWrite(a,6,0)
    analogWrite(a,9,0)
figure(1); clf;    
plot(time_vector, x1_vector)
hold on
plot(time_vector,x2_vector)
plot(time_vector,u_vector)
plot(time_vector, theta_ref)
ylim([-5 15]);
legend('x1 position', 'x2 velocity', 'u input', 'desired position');
save('results/diorthlab2c_k2=' + string(k2) + '_k1=' + string(k1) + '_freq=' + string(freq) + '.mat','x1_vector','x2_vector','u_vector','time_vector', 'theta_ref', 'k1', 'k2', 'kr', 'Tm', 'ku', 'k0', 'kt', 'km')

