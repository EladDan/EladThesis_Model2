function [ Nreal, N, r_red, r_blue, a_red, a_blue ] = getNumberLayers( Chla, Chlb_, Car_ )
%%%%%%%%%%%%%%%%%%
width = 4;                      % PBR width cm
c_diam = 6e-4;                  % cell diameter cm = x10,000 um
c_Xsec = pi*c_diam^2/4;         % cell cross section cm2
c_vol = pi*c_diam^3/6;          % cell volume cm3
c_cube = c_vol^(1/3);           % dimension of diameter for equivalent cube cm
% c_chla = 5.88E-10;            % cell Chla content mg/cell
c_chla = 0.0044/7.48E6;
%%%%%%%%%%%%%%%%%%%%

cell_density = Chla / c_chla;            % cells density cell/cm3
cells_per_cm2 = cell_density * width;    % amount of cells in 1x1xWidth cm^3

Chla_in = (Chla/cell_density)/c_vol;     % intracellular Chla concentration in mg/cm^3
Nreal = cells_per_cm2 * c_Xsec;          % Number of layers with Xsec=1cm2
N = ceil(Nreal);                         % Number of layers rounded up

p_encount = Nreal/N;                     % empty residue equally distributed on N layers
                                         % = probability of photon:cell encounter
% epsilons [cm^2/mg]
% red
rEpsa = 0.07523 * 1000;
rEpsb = 0.07815 * 1000;
rEpsc = 0 * 1000;
% rPBR = 1.24;
% rX = 10^(-rPBR/3);                     % percent transmitted through 1/3 PBR

% blue
bEpsa = 0.1093 * 1000;
bEpsb = 0.1705 * 1000;
bEpsc = 0.5189 * 1000;
% bPBR = 1.518;
% bX = 10^(-bPBR/3);                     % percent transmitted through 1/3 PBR

% a_red = 0;
% a_blue = 0;
% probability for a photon to be absorbed AFTER it entered a cell
a_red = (1 - 10^(-(((rEpsa+rEpsb*Chlb_+rEpsc*Car_)*Chla_in*c_cube))));
a_blue = (1 - 10^(-(((bEpsa+bEpsb*Chlb_+bEpsc*Car_)*Chla_in*c_cube))));

% probability for a photon to be reflected by an INCOMPLETE layer
r_red = p_encount * 0.05;
r_blue = p_encount * 0.03;
end

