function [ Params ] = get_default_parameters( )

Params = struct();

% 
Params.Chla = 0.01;                   % chla concentration in mg/cm3
Params.Chlb_ = 0.35;                   % weight ratio Chlb/Chla
Params.Car_ = 0.56;                    % weight ratio Car/Chla
Params.cell_diam = 6e-4;               % cell diameter cm = x10,000 um
Params.cell_chla = 5.88235E-10;        % chla content per cell in mg/cell
%
Params.r_red = 0.2;                    % elementary probability for red reflection
Params.r_blue = 0.03;                  % elementary probability for blue reflection

end

