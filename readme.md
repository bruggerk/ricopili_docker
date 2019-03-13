**RICOPILI** stands for Rapid Imputation and COmputational PIpeLIne for GWAS - It is developed and maintained by Stephan Ripke at the Broad Institute and MGH. 

The software consists of four independent modules: Preimputation (QC), PCA, Imputation, and Meta-Analysis. These modules are not meant to be used linearly. For example, it may be necessary to repeat QC after discovering your data contains multiple populations from PCA.

Docker version of the [ricopili package](https://sites.google.com/a/broadinstitute.org/ricopili/). 


How to use this image
=====================

Run a simple command:
```bash

docker run ricopili:latest pcaer

```
