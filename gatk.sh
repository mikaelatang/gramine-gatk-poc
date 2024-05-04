#!/usr/bin/env bash

cd gatk
ulimit -n 65000
./gatk --list
./gatk ValidateSamFile -I /inputs/NA12878_24RG_small.hg38.bam -M SUMMARY
