.. _campari_preparation:

Protein preparation with CAMPARI 
================================

With the latest implemented features it is now straightforward to use CAMPARI 
to directly generate a receptor mol2 file for SEED. As CAMPARI's pdb parser is 
fairly robust, in the vast majority of the cases it will be able to read a raw 
pdb without the need of any preprocessing. 

The input files required by CAMPARI to describe the receptor are a sequence file 
listing all the residues in the system and a pdb or another structural file to 
read the atom coordinates (the atoms for which no coordinates are provided will 
be rebuilt by CAMPARI). Additionally CAMPARI only requires a key file with a list 
of keywords specifying the calculation to run. We provide some key file templates
to perform a standard protein preparation protocol for docking. 
For details please refer to 
`CAMPARI v4 documentation <http://campari.sourceforge.net/V4/index.html>`_.

The sequence file can be extracted from the ``SEQRES`` of the pdb using the script 
``convert_SEQRES_toseq.sh`` provided in the CAMPARI tool directoty.

Before starting the preparation with CAMPARI be sure to be running version 4.
Once the key-file is specified, CAMPARI can be run as easy as: 

.. code-block:: bash

    campari -k keyfile.key >& log

.. comments

    If you specify in the key file the following keyword
    FMCSC_SYBYLLJMAP  ljmap_for_abs4.2_charmm36.prm

By default CAMPARI will write as structural output both a pdb and a mol2 file 
with the ``ALT_TYPE_SET`` specification as required by SEED. 

We recommend using CHARMM parameters for docking with SEED. Using AMBER/GAFF force 
field is still experimental, but can be done (see :ref:`gaff_preparation`).
CHARMM parameters can be specified in the key-file with the following keyword:

.. code-block:: bash

  PARAMETERS  <CAMPARI_PATH>/params/abs4.2_charmm36.prm
  
The output mol2 files will contain CHARMM partial charges (in the charge column) and 
the CAMPARI biotypes (in the ALT_TYPE_SET line), 
which needs to be mapped to the corresponding CHARMM atom types by running: 

.. code-block:: bash

  bash convert_CAMP_BIO_to_CGENFF.sh CAMP_BIO_to_CGENFF.map MOL2FILE > OUTPUTFILE
  
A protein receptor can be prepared with CAMPARI using the two keyfiles ``tmd_build.template.key`` and 
``cons_mini_abs_internal.template.key`` (make sure to correct filenames and paths).

``tmd_build.template.key`` rebuilds the system starting from the provided pdb. 
Missing residues are added and missing sidechains are build in random conformations.
After that a specific relaxation protocol (refer to keyword ``TMD_RELAX`` in CAMPARI documentation) 
is carried out to remove any major steric clashes. 

The mol2 output of the run (suffix ``_RELAXED.mol2`` or ``_END.mol2``) is almost ready to be 
used in SEED (only the remapping of CHARMM atom types is needed). Note that the ``RELAXED`` files 
contains the system coordinates after the relaxation, whereas the ``END`` files are the final snapshots 
of the simulation, in case for example additional molecular dynamics or Monte Carlo is run after relaxation.

We recommend to additionally run a short minimization on the relaxed output 
(pdb with suffix ``_RELAXED.pdb``). Minimization can be performed in internal 
coordinates with ``cons_mini_abs_internal.template.key``. 
We recommend the use of a freeze file (keyword ``FRZFILE``, using mode ``A``) to allow only 
side-chain terminal dihedrals (those ending with a hydrogen) 
to move during minimization. This can be accomplished 
for example by extracting the indices of the non-terminal dihedrals (the ones we 
would like to freeze) from a CAMPARI log file (keyword ``TMDREPORT`` enabled), with a 
command like the following: 

.. code-block:: bash 
  
  sed -n '/Summary of Rotation/,/End of Summary of Rotation/p' log | sed '/Mol.  #/,/Atom/d' | tail -n +2 | head -n -1 | awk '$3 > 10 {print $1}'

If the system is made up by multiple chains or molecules, make sure to include 
also constraints for rigid body translations and rotations in the ``FRZFILE``.

For the equivalent target preparation protocol for AMBER/GAFF, refer to :ref:`seed_amber_receptor`.