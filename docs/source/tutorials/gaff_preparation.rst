.. _gaff_preparation:

Gaff preparation (WORK IN PROGRESS)
***********************************

IMPORTANT: this development is still a work in progress and the use 
of AMBER/GAFF with SEED has not been tested extensively yet.

This is a little tutorial for preparing the receptor and library for running 
SEED using Amber/GAFF force fields.
Using other workflows and software is of course possible, but we provide custom
scripts (in ``scripts`` folder) to automatize most of the needed steps. 

For specific tasks we rely on the following free software:

* `CAMPARI <http://campari.sourceforge.net/>`_ software package for target preparation.
* `AmberTools <https://ambermd.org/AmberTools.php>`_ (and specifically *antechamber*) for ligand parametrization.

Before starting the input preparation tutorials read about the :ref:`input_files` to 
understand the format for structural input read by SEED (standard mol2 with ALT_TYPE_SET specification).

To run the code provided in this tutorial as is, you should set the 
``PYTHONSCRIPTS`` variable to ``"SEED/scripts/python"``.

**Note** The Python scripts for preparation have been updated to Python 3.

External software installation
==============================

Please refer to the official documentation for external software installation; we report
here only quick installation instructions.

For AmberTools you can get a pre-compiled version through conda:

.. code-block:: bash

    conda install -c conda-forge ambertools=22 compilers

For a standard campari installation a configuration file can be used to generate 
the system-specific makefile:

.. code-block:: bash

    cd campari/source
    ./configure --enable-mpi=auto
    make all install

This will install all campari executables (serial, threaded, MPI, etc.).
For protein preparation, the serial executable might be sufficient (``make campari install``).

.. _seed_amber_receptor:

Writing a SEED-compatible receptor with AMBER parameters
========================================================

For general preparation of a docking-ready receptor from a crystal PDB with 
CAMPARI (missing atom reconstruction, protonation, relaxation, minimization, etc.)
refer to `here <../restricted/restry.html>`_. Note that those instructions are for CHARMM, but it would
be enough to change force field in the key-file (e.g. with ``PARAMETERS abs3.2_a03.prm``) 
to use AMBER parameters for the charges and write the correct biotypes in the output mol2.
The use of ``FMCSC_SYBYLLJMAP`` is no longer needed.

Alternatively, if you have an already prepared receptor, you can easily output a mol2 file by 
simple conversion using the provided ``conv2amber.template.key`` (make sure to change paths and filenames) 
and running:

.. code-block:: bash 

    campari -k conv2amber.template.key >& log 

This will output a mol2 (``conv2amber_RELAXED.mol2``) with the CAMPARI biotypes specified as 
``ALT_TYPE_SET`` and AMBER.

The CAMPARI biotypes needs now to be remapped to the correct AMBER atom types by running 
(this is exactly the same procedure to prepare SEED-ready CHARMM mol2 files): 

.. code-block:: bash

  bash convert_CAMP_BIO_to_GAFF.sh ../../params/CAMP_BIO_to_GAFF2.map INPUT.mol2 > OUTPUT.mol2

The ``OUTPUT.mol2`` file will now contain AMBER charges and atom types.


Ligand parametrization with GAFF2 
=================================

General information on how to prepare a ligand/ligand library for SEED can be found
in the `relative tutorial <preparation.html>`_. We here focus on the GAFF-specific steps.

Starting from a protonated ligand mol2, GAFF2 parameters (atom types and charges) can be 
assigned with *antechamber*:

.. code-block:: bash 

    antechamber -i INPUT.mol2 -fi mol2 -o OUTPUT.mol2 -fo mol2 -c bcc -at gaff2 -rn LIG

``-c bcc`` request to use AM1-BCC semi-empirical method for fitting the charges. This is the 
recommended choice for compatibility in the virtual screening setting. Other choices 
(both more and less accurate) are also possible. *Antechamber* can also read other file formats 
in input (e.g. sdf), and these will require the additional specification of the net charge of 
the molecule (with ``-nc NETCHARGE``).

Now the GAFF2 parameters (charges and atom types) can be copied back in the original mol2 
with the correct format for seed input (partial charges in the charge column and atom types as ALT_TYPE_SET):

.. code-block:: bash 

    python ${PYTHONSCRIPTS}/mol2ori_to_mol2seed4_gaff.py INPUT.mol2 ANTECHAMBER.mol2 OUTPUT.mol2

where ``INPUT.mol2`` is the original mol2, ``ANTECHAMBER.mol2`` the output of *antechamber* 
and ``OUTPUT.mol2`` the final SEED-ready mol2.

Running SEED
============

Now SEED can be run normally, but in the input file (.inp) the correct 
parameter file (.par) containing AMBER/GAFF van der Waals parameters should be used: ``params/seed4_gaff.par``.

.. code-block:: bash 

    seed_4 seed.inp >& log

A script to semi-automatically extract AMBER VdW parameters for SEED from the original amber force field files 
is also provided (``${PYTHONSCRIPTS}/gaff2_to_seed_vdw_param.py``).



      
    
      
    
