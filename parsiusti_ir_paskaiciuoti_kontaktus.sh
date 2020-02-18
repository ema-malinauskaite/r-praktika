#!/bin/bash

for i in $(cat $1); do
   PDBID="$i"

curl "https://files.rcsb.org/download/${PDBID}.pdb.gz" --output ./$2/"${PDBID}.pdb.gz"

gunzip ./$2/"${PDBID}.pdb.gz"

../voronota_1.19.2352/voronota-contacts --input-filter-query "--match 'R<LEU,ALA,GLY,VAL,GLU,SER,LYS,ILE,ASP,THR,ARG,PRO,ASN,PHE,GLN,TYR,HIS,MET,TRP,CYS,MSE>'" --contacts-query "--inter-residue" -i ./$2/"${PDBID}.pdb" > ./$2/"${PDBID}.contacts"

cat ./$2/"${PDBID}.contacts" | ../voronota_1.19.2352/voronota query-contacts --inter-residue \
| ../voronota_1.19.2352/voronota expand-descriptors | column -t > ./$2/"${PDBID}.contacts.interresidue.table"

done

