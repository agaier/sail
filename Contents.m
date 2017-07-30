% SRC
%
% Algorithm Functions:
%   sail                - Surrogate Assisted Illumination Algorithm
%   vanillaMapElites    - vanillaMapElites - Runs the standard MAP-Elites algorithm
%
% ACQUISITION
%   computeFitness      - Computes fitness with penalties from drag, lift, area
%   constructSurrogate  - Creates GP surrogate functions
%   sobol2indx          - Given a point on a sobol set, returns the map linear index
%
% CONFIG
%   defaultParamSet     - Loads default parameters for SAIL algorithm
%   loadBaseAirfoil     - Creates base struct with drag, lift, and geometry
%
% MAPELITES
%   createChildren      - Produce new children through mutation of map elite
%   createMap           - Defines map struct and feature space cell divisions
%   getBestPerCell      - Returns index of best individual in each cell
%   mapElites           - Multi-dimensional Archive of Phenotypic Elites algorithm
%   nicheCompete        - results of competition with map's existing elites
%   updateMap           - Replaces all values in a set of map cells
%   viewMap             - Computes fitness with penalties from drag, lift, area
%
% MODULES
%   airFoilTools        - Scripts to support the PARSEC representation,
%                       including optimization with CMA-ES
%   gaussianProcess     - Scripts to support the construction of Gaussian
%                       Process models, include the GPML package
%   matlabExtensions    - Miscellaneous MATLAB scripts self created and
%                       downloaded from File Exchange
