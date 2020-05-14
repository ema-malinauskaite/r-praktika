#!/bin/bash

for i in $(cat $1); do
   PDBID="$i"

curl "https://www.rcsb.org/fasta/entry/${PDBID}" --output ./lizocimai/"${PDBID}.fasta"

done


