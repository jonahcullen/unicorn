**Variant database workshop**

##Collect required data
```
mkdir test
cd test
wget https://equinegenomics.uky.edu/data_warehouse/Equus_caballus/UMN_VariantCatalog_subset.vcf.gz
wget https://equinegenomics.uky.edu/data_warehouse/Equus_caballus/UMN_VariantCatalog_subset.vcf.gz.tbi
wget https://equinegenomics.uky.edu/data_warehouse/Equus_caballus/QH_subset.vcf.gz
wget https://equinegenomics.uky.edu/data_warehouse/Equus_caballus/QH_subset.vcf.gz.tbi
wget https://equinegenomics.uky.edu/data_warehouse/Equus_caballus/UMN_breeds.txt

```

##Determine the allele frequency of three suspected phenotype-causing variants in a population of 504 horses

```
python ../unicorn/breed_AF.py -v chr11:53345548
python ../unicorn/breed_AF.py -v chr26:8667651
python ../unicorn/breed_AF.py -v chr11:28345
```

#Note. The top two variants are known variants in the OMIA database. 
##IMM variant: https://www.omia.org/OMIA002141/9796/
##GBED variant: https://www.omia.org/OMIA000420/9796

##Identify variants unique to the disease case and not present in a population of 504 horses
#Identify how many variants in the disease case vcf
```
bcftools stats QH_subset.vcf.gz > QH.stats
less QH.stats
```
#Filter variants
```
##Instance Users##

~/gatk-4.3.0.0/gatk VariantFiltration --output test.vcf.gz --variant QH_subset.vcf.gz --mask https://equinegenomics.uky.edu/data_warehouse/Equus_caballus/UMN_VariantCatalog_subset.vcf.gz --mask-name UMN_catalog
~/gatk-4.3.0.0/gatk SelectVariants -V test.vcf.gz --exclude-filtered -O test_output.vcf.gz

##Home HPC Users##

gatk VariantFiltration --output test.vcf.gz --variant QH_subset.vcf.gz --mask https://equinegenomics.uky.edu/data_warehouse/Equus_caballus/UMN_VariantCatalog_subset.vcf.gz --mask-name UMN_catalog
gatk SelectVariants -V test.vcf.gz --exclude-filtered -O test_output.vcf.gz


```
#Identify how many variants are unique to the disease case vcf
```
bcftools stats test_output.vcf.gz > test.stats
less test.stats
```
