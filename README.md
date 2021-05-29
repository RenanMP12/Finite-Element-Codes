# Finite Element Method in Matlab and Python

## General Finite Element Method Algorithm
1. Establish a coordinate matrix
    1. Set all nodes
2. Establish a incidence matrix
    1. Set all elements
3. Establish a boundary condition vector
    ```diff 
    + Python: Create a Mask vector to remove the constraints lines and columns 
    - Matlab: 
    ```
4. Establish a load vector
5. Global stiffness matrix 
    1. Compute the local stiffness matrix
    2. Assembly
6. Compute the displacement vector
7. Post-processing
    1. Plot the deformed elements
