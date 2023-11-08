theta = 5*ones(1, size(x1_vector,2));

figure(1); clf;   
set(groot,'defaultLineLineWidth',1.5)
plot(time_vector, x1_vector)
hold on
plot(time_vector, x2_vector)
plot(time_vector, theta)
%plot(time_vector, u_vector)
%plot(time_vector, z_vector)


%ylim([-3 9]);
xlabel('Time')
grid on
legend('x_1 Θέση', 'x_2 ταχύτητα', 'Θ_{ref} επιθυμητή θέση');
%legend('u είσοδος ελέγχου', 'z');