#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Oct 30 13:11:06 2019

@author: durwa004
"""
import argparse
import os
import gzip

def make_arg_parser():
    parser = argparse.ArgumentParser(
            prog="GeneratePBS.py",
            formatter_class=argparse.ArgumentDefaultsHelpFormatter)
    parser.add_argument(
            "-v", "--variant",
            default=argparse.SUPPRESS,
            metavar="",
            required=True,
            help="variant of interest - format e.g. chr1:4332 [required]")
    return parser

if __name__ == '__main__':

    parser = make_arg_parser()
    args = parser.parse_args()

    variant = args.variant

#Get breed specific allele frequencies
    variant = variant.split(":")
    breeds = []
    with gzip.open("UMN_VariantCatalog_subset.vcf.gz", "rt") as input_f, open("UMN_breeds.txt", "r") as input2:
        for line in input_f:
            line = line.rstrip("\n").split("\t")
            if line[0] == variant[0] and line[1] == variant[1]:
               line1 = []
               for i,v in enumerate(line[9:]):
                    a = v.split(":")
                    if "/" in a[0]:
                        b = a[0].split("/")
                    elif "|" in a[0]:
                        b = a[0].split("|")
                    if b[0] == "." or b[1] == ".":
                        genotype = "miss"
                    elif b[0] == "0":
                        if int(b[1]) > 0:
                            genotype = "het"
                        elif int(b[1]) == 0:
                            genotype = "hom_WT"
                    elif int(b[0]) >0:
                        if int(b[1]) == 0:
                            genotype = "het"
                        elif int(b[1]) > 0:
                            genotype = "hom"
                    else:
                        print(line[0:15])
                        print(a[0])
                    line1.append(genotype)
               break
        for line in input2:
            line = line.rstrip("\n").split("\t")
            if line[1] == "NA":
                next
            else:
                breeds.append(line[1])
    breed_d = {}
    for i,v in enumerate(line1):
        if breeds[i] not in breed_d.keys():
            breed_d[breeds[i]] = 0
        else:
            if v == "het":
                a = int(breed_d[breeds[i]]) 
                a +=1
                breed_d[breeds[i]] = a
            elif v == "hom":
                a = int(breed_d[breeds[i]]) 
                a +=2
                breed_d[breeds[i]] = a
    for key in breed_d.keys():
        print("Allele frequency of ", variant[0], ":", variant[1], " in ", key, ": ", int(breed_d[key])/(int(breeds.count(key)*2)))
        
         

