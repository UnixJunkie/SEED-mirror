#!/usr/bin/python
from __future__ import print_function
import sys, os

ATOM_MASS = {"C": 12, "H":1, "F":19, "CL":35, 
             "BR": 80, "I":127, "N":14,"O":16, 
             "P":31,"S":32,"CU":63, "CU2": 64,
             "CA":40, "MG":24, "FE": 55, "ZN": 65, "EP": 0}
ATOM_NUMBER = {"C": 6, "H": 1, "F": 9, "CL": 17,
               "BR": 35, "I": 53, "N": 7, "O": 8,
               "P": 15, "S": 16, "CU": 29, "CU2": 29,
               "CA":20, "MG":12, "FE": 26, "ZN": 30, "EP": 0}

def search_dict(my_dict, elem):
    for k, v in my_dict.items():
        if v == elem:
            return(k)

def main(argv):
    parin = argv[0]
    par_offset = int(argv[1])

    with open(parin, "r") as f:
        pars = f.readlines()

    atmtype = []
    atmrepr = {}
    atmnum = {}
    vdw_R = {}
    vdw_eps = {}

    out = ""
    
    inpars = True
    invdw = False

    for iline, line in enumerate(pars[1:]):
        
        # if line.startswith("AMBER"):
        #     inpars = True 
        #     continue

        if line.startswith("MOD4"):
            vdw_line = iline
            invdw = True 
            continue 

        if inpars and len(line.split()) == 0:
            inpars = False
            continue

        if invdw and len(line.split()) == 0:
            invdw = False 
            continue

        if inpars:
            ls = line.split()
            atmtype.append(ls[0])
            mass = round(float(ls[1]))
            elem = search_dict(ATOM_MASS, mass) # get the element from the mass
            # print(ls[0], mass, elem)
            atmnum[ls[0]] = ATOM_NUMBER[elem] # stores the atom numbers for the atomtype
            atmrepr[ls[0]] = line.rstrip("\n")[37:] #" ".join(ls[3:])
            continue

        if invdw:
            ls = line.split()
            if ls[0] == "END":
                invdw = False
                continue

            # print(ls)
            vdw_R[ls[0]] = float(ls[1])
            vdw_eps[ls[0]] = float(ls[2])

    equivalences = {}

    iline = vdw_line-1
    # print(vdw_line-1)
    while iline > 0:
        line = pars[iline]
        ls = line.split()
        
        if len(ls) == 0:
            break
        else:
            equivalences[ls[0]] = ls[1:]

        iline -= 1
    
    for k, v in equivalences.items():
        for k1 in v:
            vdw_R[k1] = vdw_R[k]
            vdw_eps[k1] = vdw_eps[k]

    # for k in atmtype:
    #     try:
    #         print(k, atmnum[k], vdw_R[k], vdw_eps[k], atmrepr[k])
    #     except KeyError:
    #         print("ERROR, missing key!")

    counter = 0 + par_offset
    for i, k in enumerate(atmtype):
        try:
            print(counter, k, atmnum[k], vdw_R[k], vdw_eps[k], "# "+atmrepr[k], sep="\t")
            counter += 1
        except KeyError:
            print("# MISSING KEY ", k)

if __name__ == "__main__":
    main(sys.argv[1:])
