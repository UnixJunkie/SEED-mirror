#!/bin/bash

if [[ -z "$1" ]] || [[ -z "$2" ]] || [[ -n "$3" ]]; 
then
  echo -e "Usage:\n\n/bin/bash convert_CAMP_BIO_to_CGENFF.sh MAP MOL2FILE > OUTPUTFILE\n"
  exit
fi

awk -v fn1=$1 '{if ($1 == "CAMP_BIO") {while (( getline line<fn1) > 0) {split(line,ele," "); xx[ele[1]]=ele[3]}; printf("GAFF2 "); for (k=2;k<=NF;k=k+2) {printf ("%d %s ",$k,xx[$(k+1)])}; printf("\n")} else if ($1 == "CAMP_BIO_ALT_TYPE_SET") {print "GAFF2_ALT_TYPE_SET"} else {print}}' $2

# how to get the map
# OLD for charmm # cat charmm36.prm | awk '{if ($1 == "biotype") {print}}' | sed -e 's|".*"||' | awk '{if (($4 >= 57) && ($4 <=59)) {print $4+57} else if (($2 == 344) || ($2 == 364) || ($2 == 6) || ($2 == 1200)) {print "117"} else {print $6}}' > tmplst

# cat bio_amber03.txt | awk '{if ($1 == "biotype") {print}}' | sed -e 's|".*"||' | awk '{print $6}' > tmplst

# then paste this (with "#" to top of "tmplst")
# bonded_type   0   ! XXX dummy
# bonded_type   1   ! H bonded to nitrogen atoms in arg
# bonded_type   2   ! HA arom. bond. to C without elctrwd. groups (HD phe)
# bonded_type   4   ! HO hydroxyl group
# bonded_type   5   ! HO hydroxyl group (threonine)
# bonded_type   6   ! H bonded to nitrogen atoms
# bonded_type   7   ! H bonded to nitrogen atoms in Gly # CHECK
# bonded_type   9   ! H bonded to nitrogen atoms in lys
# bonded_type   10  ! H bonded to nitrogen atoms in N-terminal pro(+)
# bonded_type   11  ! HS hydrogen bonded to sulphur (pol?)
# bonded_type   12  ! HO hydroxyl group (tyrosine)
# bonded_type   13  ! H bonded to nitrogen atoms (trp)
# bonded_type   15  ! HC aliph. bond. to C without electrwd. group
# bonded_type   16  ! HC aliph. bond. to C without electrwd. group (CB leucine)
# bonded_type   17  ! H1 aliph. bond. to C with 1 electrwd. group
# bonded_type   18  ! N sp2 nitrogen in amide groups
# bonded_type   19  ! N sp2 nitrogen in amide groups
# bonded_type   20  ! N sp2 nitrogen proline
# bonded_type   22  ! N3 sp3 N for charged amino groups (Lys, etc)
# bonded_type   23  ! N3 N-terminal pro(+)
# bonded_type   24  ! NA sp2 N in 5 memb.ring w/H atom (HIS)
# bonded_type   25  ! NB sp2 N in 5 memb.ring w/LP (HIS,ADE,GUA)
# bonded_type   26  ! N2 sp2 N in amino groups ARG/HIP/LYS>!PRO
# bonded_type   27  ! O carbonyl group oxygen
# bonded_type   28  ! O2 carboxyl and phosphate group oxygen
# bonded_type   29  ! OH oxygen in hydroxyl group
# bonded_type   31  ! OH oxygen in hydroxyl (tyrosine)
# bonded_type   35  ! CT sp3 aliphatic C (C gamma)
# bonded_type   36  ! CX sp3 aliphatic C-alpha in Glycine #CHECK
# bonded_type   37  ! CX sp3 aliphatic C-alpha
# bonded_type   38  ! C sp2 C carbonyl group
# bonded_type   39  ! CO sp2 C carboxylate group
# bonded_type   40  ! CA CD,CE,CZ phe
# bonded_type   41  ! CA sp2 C pure aromatic (benzene), CG phe
# bonded_type   42  ! C sp2 C carbonyl group (CZ tyrosine)
# bonded_type   43  ! CA CA sp2 C pure aromatic (benzene), CZ arg
# bonded_type   46  ! CT sp3 aliphatic C (e.g. C beta)
# bonded_type   47  ! 3C sp3 aliphatic C with three (tres) heavy atoms (e.g. CB valine)
# bonded_type   48  ! 2C sp3 aliphatic C with two (duo) heavy atoms (e.g. CB leucine)
# bonded_type   49  ! 3C sp3 aliphatic C with three (tres) heavy atoms (e.g. CB ile)
# bonded_type   50  ! 2C sp3 aliphatic C with two (duo) heavy atoms (CB serine)
# bonded_type   51  ! 3C sp3 aliphatic C with three (tres) heavy atoms (CB thr)
# bonded_type   52  ! 2C sp3 aliphatic C with two (duo) heavy atoms (CB cys)
# bonded_type   53  ! 2C CB cysteine (-SS-)
# bonded_type   54  ! CT CB proline
# bonded_type   55  ! CT CB phenylalanine
# bonded_type   56  ! CT CB tyrosine
# bonded_type   57  ! CT CB tryptophan
# bonded_type   58  ! CT CB his(+)
# bonded_type   59  ! 2C CB asp(-)
# bonded_type   60  ! 2C CB asn
# bonded_type   61  ! 2C CB glu
# bonded_type   62  ! 2C CB gln
# bonded_type   63  ! 2C CB met
# bonded_type   64  ! C8 sp3 aliphatic C basic AA side chain (lys)
# bonded_type   65  ! C8 sp3 aliphatic C basic AA side chain (arg)
# bonded_type   73  ! C* sp2 arom. 5 memb.ring w/1 subst. (TRP)
# bonded_type   74  ! CC sp2 aromatic C, 5 memb. ring HIS
# bonded_type   75  ! CR sp2 arom as CQ but in HIS
# bonded_type   76  ! CV sp2 arom. 5 memb.ring w/1 N and 1 H (HIS)
# bonded_type   77  ! CR sp2 arom as CQ but in HIS
# bonded_type   78  ! CW sp2 arom. 5 memb.ring w/1 N-H and 1 H (HIS)
# bonded_type   79  ! SH in cysteine
# bonded_type   80  ! S in met
# bonded_type   81  ! S in disulfide linkage,pol:JPC,102,2399,98
# bonded_type   82  ! OW in SPC water
# bonded_type   83  ! HW in SPC water
# bonded_type   84  ! OW in TIP3P water
# bonded_type   85  ! HW in TIP3P water
# bonded_type   90  ! CB sp2 aromatic C, 5&6 membered ring junction (CD2 trp)
# bonded_type   91  ! CN sp2 C aromatic 5&6 memb.ring junct.(TRP)
# bonded_type   92  ! CW sp2 arom. 5 memb.ring w/1 N-H and 1 H (HIS)
# bonded_type  154  ! CC sp2 aromatic C, 5 memb. ring HIS
# bonded_type  155  ! CT CD proline 
# bonded_type  156  ! H1 aliph. bond. to C with 1 electrwd. group (HA in Glycine)
# bonded_type  157  ! HP H bonded to C next to positively charged gr (N-terminal gly(+))
# bonded_type  158  ! HP H bonded to C next to positively charged gr (N-terminal res(+))
# bonded_type  159  ! HP H bonded to C next to positively charged gr

# then:
# awk '{if ($2 == "bonded_type") {btn[$3] = $5;} else {k=k+1; if (btn[$1] != ""){print k,$1,btn[$1]}else{print k, $1, "YYY"}}}' tmplst > CAMP_BIO_to_GAFF2.map

# for the bonded types for which we have not written a correspondence (yet), we print out YYY
