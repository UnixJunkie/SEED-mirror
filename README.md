# SEED (Solvation Energy for Exhaustive Docking) version 4.0.0

SEED is a program for fragment docking with force-field based evaluation of binding energy.

The new SEED documentation is now online at: [https://caflischlab-seed.readthedocs.io/en/latest/](https://caflischlab-seed.readthedocs.io/en/latest/)!

For details about the energy models implemented in SEED please refer to the original publications and to the pdf user manual (seed_4.0.0_doc.pdf).

### Installation ###
cd to directory src and make SEED with the following command (you may have to modify the Makefile.local):
```sh
make seed
```
The binary is compiled into the bin directory.
### Run SEED ###
Run SEED with the following command:
```sh
./seed_4 seed.inp >& log
```
You can find an example seed.inp and seed.par, along with the results of simple study cases,
in the test_cases folder.

### Citations ###
Assessment of SEED on 15 different protein targets, with a focus on its scoring power. Advantages, limitations and practical tips for usage are discussed:
 * K. Goossens, B. Wroblowski, C. Langini, H. van Vlijmen, A. Caflisch, and H. De Winter. Assessment of the Fragment Docking Program SEED.
Journal of Chemical Information and Modeling, 60(10):4881–4893, 2020.\
https://doi.org/10.1021/acs.jcim.0c00556

Review of the applications of SEED in the period 1999-2018, including a discussion on its strenghts and weaknesses in light of our experience:
 * J.-R. Marchand, and A. Caflisch. In silico fragment-based drug design with SEED.
European Journal of Medicinal Chemistry, 156:907-917, 2018.\
https://doi.org/10.1016/j.ejmech.2018.07.042

Original paper describing SEED:
 * N. Majeux, M. Scarsi, J. Apostolakis, C. Ehrhardt, and A. Caflisch. Exhaustive docking of
molecular fragments on protein binding sites with electrostatic solvation.
Proteins: Structure, Function and Genetics, 37:88-105, 1999.\
[https://doi.org/10.1002/(SICI)1097-0134(19991001)37:1<88::AID-PROT9>3.0.CO;2-O](https://doi.org/10.1002/(SICI)1097-0134(19991001)37:1<88::AID-PROT9>3.0.CO;2-O)

Second SEED paper including the description of the fast energy evaluation:
 * N. Majeux, M. Scarsi, and A. Caflisch. Efficient electrostatic solvation model for protein-
fragment docking.
Proteins: Structure, Function and Genetics, 42:256-268, 2001.\
[https://doi.org/10.1002/1097-0134(20010201)42:2<256::AID-PROT130>3.0.CO;2-4](https://doi.org/10.1002/1097-0134(20010201)42:2<256::AID-PROT130>3.0.CO;2-4)

Accurate energy continuum electrostatic model implemented in SEED:
 * M. Scarsi, J. Apostolakis, and A. Caflisch. Continuum Electrostatic Energies of Macromolecules in Aqueous Solutions.
The Journal of Physical Chemistry A, 101(43):8098–8106, 1997.\
https://doi.org/10.1021/jp9714227
