**RICOPILI** stands for Rapid Imputation and COmputational PIpeLIne for GWAS - It is developed and maintained by Stephan Ripke at the Broad Institute and MGH, this is a docker version of this [ricopili](https://sites.google.com/a/broadinstitute.org/ricopili/). 



How to use this image
=====================

Run a ricopili command in the container (pcaer in this case):
```bash

docker run bruggerk/ricopili:latest pcaer
```

give ricopili access to  reference data in read-only mode ( see below how to get the reference data)

```bash
docker run -v [PATH-TO-REFERENCE-DATA]:/ricopili/reference/:ro ricopili [TOOL-NAME]
```


However as the majority of the tools needs, and generates, data you will need to make a directory available through volumes:


```bash
# This will run docker mounting your current working directory in /run, and execute the program in /run
docker run -v`pwd`:/run/ -w /run ricopili:latest  [TOOL-NAME]

```





Reference data:
===============

Due to size constrictions it is not possible to include reference data in the container image. However it is easy to download and make these available
Please be advised that the total reference dataset is about 41GB.

```
# make a directory for the reference and cd into it
# Download the reference files ( with curl)
curl -LO https://storage.googleapis.com/cloud-ricopili/dependencies/HRC.r1-1.EGA.GRCh37.metafiles.deploy.tar.gz 
curl -LO https://storage.googleapis.com/cloud-ricopili/dependencies/HRC.r1-1.EGA.GRCh37.1KG_pops.tar.gz
curl -LO https://storage.googleapis.com/cloud-ricopili/dependencies/human_g1k_v37.fasta.gz
# Not required, but recomended  ( very large file!)
curl -LO https://storage.cloud.google.com/cloud-ricopili/reference-genotypes/1KG_ref_ricopili.tar.gz

# downloading with wget if curl is not available 
wget https://storage.googleapis.com/cloud-ricopili/dependencies/HRC.r1-1.EGA.GRCh37.metafiles.deploy.tar.gz 
wget https://storage.googleapis.com/cloud-ricopili/dependencies/HRC.r1-1.EGA.GRCh37.1KG_pops.tar.gz
wget https://storage.googleapis.com/cloud-ricopili/dependencies/human_g1k_v37.fasta.gz
# Not required, but recomended  ( very large file!)
wget https://storage.cloud.google.com/cloud-ricopili/reference-genotypes/1KG_ref_ricopili.tar.gz

# uncompress the reference files
tar zxf HRC.r1-1.EGA.GRCh37.metafiles.deploy.tar.gz 
tar zxf HRC.r1-1.EGA.GRCh37.1KG_pops.tar.gz
gunzip human_g1k_v37.fasta.gz
# Not required, but recomended ( very large file!)
tar zxf 1KG_ref_ricopili.tar.gz

```


Special directories
===================

The container have been build and configured with two special directories that can be mounted to local directories. Some of these are required for TSD (Norwegian Service for Sensitive Data), and migth need to be tweaked for other services.

* /ricopili/reference: reference data to be used in the analysis
* /scratch: where tmp files are placed
* /cluster (tsd requirement)
* /work (tsd requirement) 
* /tsd (tsd requirement) 
* /projects (tsd requirement)
