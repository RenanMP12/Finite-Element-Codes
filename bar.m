%% PURPOSE: Find the displacement of a variable section bar

%% CLEANING
clear all; close all; clc

%% INPUT
nel = 20;         % Number of elements
L = 1;            % Bar length

%% COORDINATE MATRIX

coordinate_matrix = zeros(nel,2);           % Coordinate matrix pre-allocation

for i = 1:nel+1     
    coordinate_matrix(i,1) = i;             % Node number
    coordinate_matrix(i,2) = (i-1)*L/nel;   % X coordinate
end

%% INCIDENCE MATRIX

incidence_matrix = zeros(nel,5);            % Incidence matrix pre-allocation

for i = 1:nel
    incidence_matrix(i,1) = i;              % Element number
    incidence_matrix(i,2) = 1;              % Material
    incidence_matrix(i,3) = i;              % Node 1
    incidence_matrix(i,4) = i +1;           % Node 2
end

%% MATERIAL PROPERTIES

tabmat = [210E9       % Young's Module
          0.33        % Poisson Ratio
];

%% BOUNDARY CONDTIONS
%   bc = [ node | degrees of freedom | value]
%   Degree of freedom 1 --> x
%   Degree of freedom 2 --> y
%   Degree of freedom 3 --> z
%   Degree of freedom 4 --> ox
%   Degree of freedom 5 --> oy
%   Degree of freedom 6 --> oz

boundary_conditions = [ 1 1 0];
 
%% LOAD
%   F = [node | degree of freedom | value ]
%   Degree of freedom 1 --> Fx
%   Degree of freedom 2 --> Fy
%   Degree of freedom 3 --> Fz
%   Degree of freedom 4 --> Mx
%   Degree of freedom 5 --> My
%   Degree of freedom 6 --> Mz

load = [nel+1 1 1000];

%% GLOBAL STIFFNESS

kg = zeros(nel + 1,nel + 1); % global stiffness matrix pre-allocation

for i = 1:nel
    node1 = incidence_matrix(i,3);      % Node 1
    node2 = incidence_matrix(i,4);      % Node 2
    x1 = coordinate_matrix(node1,2);    % X coordinate node 1
    x2 = coordinate_matrix(node2,2);    % X coordinate node 2
    l = x2 - x1;                        % Element length
    mat = incidence_matrix(i,2);        % Material 
    E = tabmat(1,mat);                  % Young's modulus
    Ao = 0.0025;                        % Initial section area
    a = Ao*(3-2*x1/L);                  % Section area element
    ke = E*a*[1 -1; -1 1];              % Local stiffness
    loc = [node1, node2];               % Localization vector
    kg(loc,loc) = kg(loc,loc) + ke;     % Global stiffness matrix assembly 
end

%% LOAD VECTOR

F = zeros(nel+1,1);                     % Global load vector pre-allocation
nloads = size(load,1);                  % Number of loads

for i = 1 : nloads
    F(load(i,1),1) = load(i,3); 
end

loc = ones(nel+1,1);
for i = 1 : size(boundary_conditions,1)
    loc(boundary_conditions(i,2)) = 0;
end

%% DISPLACEMENT VECTOR

U = zeros(nel+1,1);             % Global displacement vector pre-allocation
U(logical(loc)) = kg(logical(loc),logical(loc))\F(logical(loc));

%% POST-PROCESSING

xmin = min(coordinate_matrix(:,2));
xmax = max(coordinate_matrix(:,2));
Lx = xmax - xmin;
xmin = xmin - 0.1*Lx;
xmax = xmax + 0.1*Lx;
axis([0 xmax -1 1]);

new_coord = coordinate_matrix(:,2) + U*1000;

y = zeros(nel+1,1);
plot(coordinate_matrix(:,2),y,'-o')
title('Variable section bar')
grid on
grid minor
hold on
plot(new_coord,y,'-d')
legend('Original position','Position after deformation')