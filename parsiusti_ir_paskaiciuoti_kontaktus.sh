#!/bin/bash

for i in $(cat $1); do
   PDBID="$i"
   echo "toks $PDBID"


curl "https://files.rcsb.org/download/${PDBID}.pdb.gz" --output ./lizocimai/"${PDBID}.pdb1.gz"

gunzip ./lizocimai/"${PDBID}.pdb1.gz"

../voronota_1.19.2352/voronota-contacts -i ./lizocimai/"${PDBID}.pdb1" > ./lizocimai/"${PDBID}.pdb1.contacts"

cat ./lizocimai/"${PDBID}.pdb1.contacts" | ../voronota_1.19.2352/voronota query-contacts --inter-residue \
| ../voronota_1.19.2352/voronota expand-descriptors | column -t > ./lizocimai/"${PDBID}.pdb1.contacts.iterresue.table"

done
