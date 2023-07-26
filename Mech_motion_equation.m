function dy = jnaKretanjaTeta(t,y,R, omega)

global g

dy = zeros(2,1);

dy(1) = y(2);
dy(2) = sin(y(1))*(R*omega*omega*cos(y(1)) - g) / R;