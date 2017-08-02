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

'help sail' for contents of source code and main algorithm syntax

Two domains are provided: 2D airfoils (help airfoil) and 3D velomobile 
shells (help velo). To apply SAIL to a new domain only new representation 
and evaluation functions must be created. More sample domains will be made
public as their are published. If you are interested in creating a new
domain and having trouble, don't hesistate to ask!

Produced using
    Matlab Version: 9.1.0.441655 (R2016b)

Required Toolboxes:
    Parallel Computing (for precise evaluation speed up)
    Statistics and Machine Learning (for Sobol sequence)

Includes:
    GMPL  Version 3.6, Rasmussen & Nickisch (help gpml)


Required Software:
    Airfoil domain:
        XFOIL low Rn airfoil design and analysis code 
        (raphael.mit.edu/xfoil/)
    Velo domain:
        OpenFOAM computation fluid dynamics simulator (version 2.4.0)
        (https://openfoam.org/download/2-4-0-ubuntu/)