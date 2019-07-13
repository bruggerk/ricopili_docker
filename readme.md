**RICOPILI** stands for Rapid Imputation and COmputational PIpeLIne for GWAS - It is developed and maintained by Stephan Ripke at the Broad Institute and MGH. 

The software consists of four independent modules: Preimputation (QC), PCA, Imputation, and Meta-Analysis. These modules are not meant to be used linearly. For example, it may be necessary to repeat QC after discovering your data contains multiple populations from PCA.

Docker version of the [ricopili package](https://sites.google.com/a/broadinstitute.org/ricopili/). 


How to use this image
=====================

Run a command (pcaer in this case):
```bash

docker run ricopili:latest pcaer

```
However as the majority of the tools needs, and generates, data you will need to make a directory available through volumes:


```bash
# This will run docker mounting your current working directory in /run, and execute the program in /run
docker run -v`pwd`:/run/ -w /run ricopili:latest pcaer

```

Special directories
===================

The container have been build and configured with two special directories that can be mounted to local directories. Some of these are required for TSD (Norwegian Service for Sensitive Data), and migth need to be tweaked for other services.

* /refs: reference data to be used in the analysis
* /scratch: where tmp files are placed
* /cluster (tsd requirement)
* /work (tsd requirement) 
* /tsd (tsd requirement) 
* /projects (tsd requirement)
