#!/bin/bash

for i in $(cat $1); do
   PDBID="$i"



../voronota_1.19.2352/voronota-contacts --input-filter-query "--match 'R<LEU,ALA,GLY,VAL,GLU,SER,LYS,ILE,ASP,THR,ARG,PRO,ASN,PHE,GLN,TYR,HIS,MET,TRP,CYS,MSE>'" -i ./lizocimai/"${PDBID}.pdb" \
> ./lizocimai/"${PDBID}.contacts.interatom"

cat ./lizocimai/"${PDBID}.contacts.interatom" \
| ../voronota_1.19.2352/voronota expand-descriptors | column -t > ./lizocimai/"${PDBID}.contacts.interatom.table"

done

