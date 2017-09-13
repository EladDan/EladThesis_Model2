function [ N, Nreal, p_encount ] = get_number_layers( Params )
Chla = Params.Chla;
cell_diam = Params.cell_diam;
cell_chla = Params.cell_chla;
%%%%%%%%%%%%%%%%%%
width = 4;                        % PBR width cm
% cell_vol = pi*cell_diam^3/6     : cell volume cm^3
% cell_dim_cube = cell_vol^(1/3)  :  dimension of diameter for equivalent cube cm
% cell_chla = Chla/cell_density   :  cell Chla content mg/cell
% cell_density = Chla / cell_chla :  cells / volume  cell/cm^3

%%%%%%%%%%%%%%%%%%%%
cell_density = Chla / cell_chla;         % cells / cm^3
cells_per_cm2 = cell_density * width;    % amount of cells in 1x1xWidth cm^3
cell_Xsec = pi*cell_diam^2/4;            % cell cross section cm2

Nreal = cells_per_cm2 * cell_Xsec;       % Number of layers with Xsec=1 cm^2
N = ceil(Nreal);                         % Number of layers rounded up

p_encount = Nreal/N;                     % empty residue equally distributed on N layers
end