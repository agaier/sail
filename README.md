# sail
Source code for the Surrogate-Assisted Illumination (SAIL) algorithm, as
described in: 

"Data-Efficient Exploration, Optimization, and Modeling of Diverse Designs
 through Surrogate-Assisted Illumination" presented at GECCO 2017. 
https://arxiv.org/abs/1702.03713

and 

"Aerodynamic Design Exploration through Surrogate-Assisted Illumination"
presented at AIAA Aviation and Aeronautics Forum 2017.
https://hal.inria.fr/hal-01518786/file/aiaa_sail.pdf


Two domains are provided with parameterized and feed forward deformation encodings: 2D airfoils and 3D velomobile shells. To apply SAIL to a new domain only new representation and evaluation functions must be created. More sample domains will be madepublic as their are published. If you are interested in creating a new domain and having trouble, don't hesistate to ask!

Produced using

    Matlab R2017b


Required MATLAB Toolboxes:

* Parallel Computing (for parallel speed ups)

* Statistics and Machine Learning (for Sobol sequence)


Includes:
    GMPL  Version 4.1, Rasmussen & Nickisch (help gpml)


Required Software:

    Airfoil domain:

         XFOIL low Rn airfoil design and analysis code 
        
        (raphael.mit.edu/xfoil/)
        
        
    Velo domain:
        
        OpenFOAM computation fluid dynamics simulator (version 2.4.0)
        
        (https://openfoam.org/download/2-4-0-ubuntu/)
