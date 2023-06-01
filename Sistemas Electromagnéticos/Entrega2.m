delta = 0.01; % Cambio de tiempo (y alturas en caso de las primeras
miu_0 = 4 * pi * (10 ^ -7); % constante miu_0
m_empty = 7460; % peso de la gongola vacia
m_full = 8360; % peso de la gongola con las personas
I = 650000; % Corriente en la base
R = 10; % Radio de la base
miu = I * R^2 * pi;
H = 100; % Altura inicial
t_final = 20; % Tiempo final

Z = 0:delta:H; 

% Funcion de magnitud campo magnetico con respecto a z
B = @(z) (miu_0 * I * R^2)/(2 * (R^2 + z^2)^(3/2));
B_z = arrayfun(B, Z);
plot(Z, B_z)

% Funcion de magnitud fuerza magnetica con respecto a z
F = @(z) ((3/2)*I*miu*miu_0*R^2) * (z/(R^2 + z^2)^(5/2));
F_z = arrayfun(F, Z);
plot(Z, F_z)

% Funcion de magnitud aceleracion con respecto a z
a = @(z) F(z)/m_full - 9.8;
a_z = arrayfun(a, Z);
plot(Z, a_z)

t = 0:delta:t_final; % vector de tiempo
h = zeros(size(t)); % vector de alturas
v = zeros(size(t)); % vector de velocidades

h(1) = H;
v(1) = 0;
[~, i_max] = size(t);

for i = 2:i_max
    v_temp = v(i-1) + a(h(i-1))*delta/2;
    h(i) = h(i-1) + v_temp*delta;
    v(i) = v_temp + a(h(i))*delta/2;
end

plot(t, h)
hold on
plot(t, v)
plot(t, arrayfun(a, h))
hold off
legend({"Altura", "Velocidad", "Aceleracion"})
