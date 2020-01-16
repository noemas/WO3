# WO3
WO3 paper repository

### relaxed WO3 bulk structures ###

these can be found in [/BULK/](https://github.com/noemas/WO3/tree/master/BULK)

### WO3 beta domain wall supercells ###
the relaxed VASP cells and input files can be found in [/DOMAIN_WALLS/](https://github.com/noemas/WO3/tree/master/DOMAIN_WALLS):
- [/DOMAIN_WALLS/BETA_FIXED/](https://github.com/noemas/WO3/tree/master/DOMAIN_WALLS/BETA_FIXED) for the case where some atoms in each domain were fixed. The cut out unit cells for the phonon mode (order parameter) decomposition are stored in [DOMAIN_WALLS/BETA_FIXED/UCS](https://github.com/noemas/WO3/tree/master/DOMAIN_WALLS/BETA_FIXED/UCS)

- [/DOMAIN_WALLS/BETA_FREE/](https://github.com/noemas/WO3/tree/master/DOMAIN_WALLS/BETA_FREE) for the case where all atoms were free to relax

- [/DOMAIN_WALLS/BETA_CHARGE/](https://github.com/noemas/WO3/tree/master/DOMAIN_WALLS/BETA_CHARGE) for the case where additional charge was introduced to the BETA_FIXED relaxed cell. The x-integrated planar density of the additional charge is contained in "vplanar.txt"

The directory furthermore contains a script ("mode_decomposition.ipynb") that calls ISODISTORT for the cut out unit cell and calculates angle and amplitude of the order parameter across the domain wall.    

### Landau-Ginzburg theory of WO3 beta domain walls ###
All scripts and data concerning this are found in [/LG_BETA/](https://github.com/noemas/WO3/tree/master/LG_BETA) where the main script "Landau_Ginzburg_Beta.ipynb" uses all data to calculate the Landau and Ginzburg parameters with and without additional charge and minimizes the the Landau-Ginzburg potential to obtain the domain walls.

The data in [/LG_BETA/DATA/](https://github.com/noemas/WO3/tree/master/LG_BETA/DATA) contains the following:
- [/LG_BETA/DATA/STRUCTURES](https://github.com/noemas/WO3/tree/master/LG_BETA/DATA/STRUCTURES) contains all relevant structures in VASP format. The Q_#.vasp files contain structures where the Q order parameter is introduced and increased in one tetragonal direction of the P4/ncc structure (P4/ncc -> Pbcn). The P_#.vasp files contain structures where the R order parameter is increased (P4/ncc -> P4/ncc, where the P4/nmm is attained at a certain amplitdue). The 2Q_#.vasp contain structures where the Q order parameter is introduced in both tetragonal directions (P4/ncc -> P21212). Finally, the PQ_#.vasp files contain structures where Q and P are increased. The order parameter increases with the index of the files.

- [/LG_BETA/DATA/SCF](https://github.com/noemas/WO3/tree/master/LG_BETA/DATA/SCF) contains all input and output files of the Landau parameter calculations for the structures with and without additional charge. The "unstrained" in the directory names refers to the fact that the cells were relaxed according to the internal coordinates. No further cell relaxations were perfomred upon addition of charge.

- [/LG_BETA/DATA/ENERGIES](https://github.com/noemas/WO3/tree/master/LG_BETA/DATA/ENERGIES) contains the Landau energy curves obtained from the calculations.

[/LG_BETA/DATA/DYNMAT](https://github.com/noemas/WO3/tree/master/LG_BETA/DATA/DYNAMT) contains the dynamical matrices for different amount of charges which are used to calculate the Ginzburg parameters.

[/LG_BETA/DATA/DOMAIN_WALLS](https://github.com/noemas/WO3/tree/master/LG_BETA/DATA/DOMAIN_WALLS) contains the minimized domain walls.

[/LG_BETA/DATA/P4ncc_mode](https://github.com/noemas/WO3/tree/master/LG_BETA/DATA/P4ncc_mode) contains tools to generate modulations of modes obtained from the dynamical matrices.

### Electron-phonon coupling and superconductivity in WO3 ###
The data and scripts for electron-phonon coupling calculations can be found in [/EPC/](https://github.com/noemas/WO3/tree/master/EPC). There are two calculation series. One denoted by "fc" for fixed cell (which are used in the paper) and one with "vc" for variable cell. Fixed cell refers to the manual setting of the charged cells without explicit relaxation and variable cell refers to explicit relaxation of charged cells. For every calculation, the electron bands, phonon bands, phonon dos, phonon linewidth and a2f function are stored in the respective directories. Scripts for the plots and calculation of Tc are in the "coupling_plots.ipynb" notebook and a script to calculate the a2f function from lambdas on a grid in the "a2f.ipynb" notebook. 



Make sure that you enable git lfs as many files are stored with lfs.
