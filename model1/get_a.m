function [ a_red, a_blue ] = get_a( Params )

% Chla = Params.Chla;           % removed !!!!!
cell_diam = Params.cell_diam;
cell_chla = Params.cell_chla;
Chlb_ = Params.Chlb_;
Car_ = Params.Car_;

%%%%%%%%%%%%%%%%%%
% cell_chla = Chla/cell_density;   cell Chla content mg/cell

% cell_density = Chla / cell_chla;         % cells / cm^3
% cells_per_cm2 = cell_density * width;    % amount of cells in 1x1xWidth cm^3
% cell_Xsec = pi*cell_diam^2/4;            % cell cross section cm2

% cell_density = Chla / cell_chla;   
% Chla_in = (Chla/cell_density)/cell_vol;   intracellular Chla concentration in mg/cm^3
%%%%%%%%%%%%%%%%%%%%

cell_vol = pi*cell_diam^3/6;            % cell volume cm3
cell_dim_cube = cell_vol^(1/3);         % dimension of side (cell width) for equivalent cube cm
Chla_in = cell_chla/cell_vol;           % intracellular Chla concentration in mg/cm^3

% epsilons [cm^2/mg] (1 L/mg/cm = 1000 cm^2/mg)
% red
rEpsa = 0.07523 * 1000;                 % eps red for Chla
rEpsb = 0.06075 * 1000;                 % eps red for Chlb
rEpsc = 0 * 1000;                       % eps red for Car

% blue
bEpsa = 0.1093 * 1000;                  % eps blue for Chla
bEpsb = 0.1708 * 1000;                  % eps blue for Chlb
bEpsc = 0.5189 * 1000;                  % eps blue for Car

% probability for a photon to be absorbed AFTER it entered a cell
a_red = 1 - 10^-((rEpsa+rEpsb*Chlb_+rEpsc*Car_)*Chla_in*cell_dim_cube);
a_blue = 1 - 10^-((bEpsa+bEpsb*Chlb_+bEpsc*Car_)*Chla_in*cell_dim_cube);

end