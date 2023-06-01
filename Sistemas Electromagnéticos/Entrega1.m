% Define variables
N_z = 15; % Precisión de la absisas
N_y = 15; % Precisión de la ordenadas
zmin = -3; % Límite inferior de las absisas
zmax = 3; % Límite superior de las absisas
ymin = -7; % Límite inferior de las ordenadas
ymax = 7; % Límite superior de las ordenadas
N_int = 100; % Precisión de la integral

visualizeCampo(N_y, N_z, ymin, ymax, zmin, zmax, 3, 5, N_int)
visualizeCampo(N_y, N_z, ymin, ymax, zmin, zmax, -3, 5, N_int)
visualizeCampo(N_y, N_z, ymin, ymax, zmin, zmax, 6, 2, N_int)

function [ds] = vds(theta) % Calcular vector ds
    ds = [-sin(theta); cos(theta); zeros(size(theta))];
end

function [r] = vr(theta, R, x, y, z) % Calcular vector r
    r = [(x - R * cos(theta)); (y - R * sin(theta)); (zeros(size(theta)) + z)];
end

function [mr] = mr(theta, R, x, y, z) % Calcular magnitud de vector r
    mr = (x - R * cos(theta)).^2 + (y - R * sin(theta)).^2 + z^2;
end

function [B_i, B_j, B_k] = getCampoMagnetico(I, R, N_int, x, y, z)
    % Constante miu_0
    miu_0 = (4 * pi) * 1e-7;
    % Vector de intervalos de integración
    theta = linspace(0, 2 * pi, N_int);
    % Tamaño de cada intervalo de integración
    diff = 2 * pi / N_int;
    
    B = ((miu_0 * I * R) / (4 * pi)) * cross(vds(theta), vr(theta, R, x, y, z) ./ (mr(theta, R, x, y, z)).^(3/2)) * diff;
    
    % Sumar componentes del vector resultante
    B_i = sum(B(1, :));
    B_j = sum(B(2, :));
    B_k = sum(B(3, :));

end

function visualizeCampo(N_y, N_z, ymin, ymax, zmin, zmax, I, R, N_int)
    % Create grids
    z = linspace(zmin, zmax, N_z);
    y = linspace(ymin, ymax, N_y);
    [Z, Y] = meshgrid(z, y);
    
    [~, z_dim] = size(z);
    [~, y_dim] = size(y);

    B_k = zeros(z_dim, y_dim);
    B_j = zeros(z_dim, y_dim);
    B_i = zeros(z_dim, y_dim);
    
    % Calcular campo magnético para todo punto en el plano
    for i = 1:y_dim
        for j = 1:z_dim
            [B_i(i,j), B_j(i,j), B_k(i,j)] = (getCampoMagnetico(I, R, N_int, 0, Y(i, j), Z(i, j)));
        end
    end

    quiver(Z, Y, B_k, B_j);
    title("Corriente: " + string(I) + " Radio: " + string(R))
    xlabel("Eje Z");
    ylabel("Eje Y");

end