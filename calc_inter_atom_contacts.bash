#!/bin/bash

for i in $(cat $1); do
   PDBID="$i"



../voronota_1.19.2352/voronota-contacts --input-filter-query "--match 'R<LEU,ALA,GLY,VAL,GLU,SER,LYS,ILE,ASP,THR,ARG,PRO,ASN,PHE,GLN,TYR,HIS,MET,TRP,CYS,MSE>'" -i ./$2/"${PDBID}.pdb" \
> ./$2/"${PDBID}.contacts.interatom"

cat ./$2/"${PDBID}.contacts.interatom" \
| ../voronota_1.19.2352/voronota expand-descriptors | column -t > ./$2/"${PDBID}.contacts.interatom.table"

done

