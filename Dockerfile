FROM ubuntu:18.04

MAINTAINER Kim Brugger <kim.brugger@uib.no>
LABEL authors="Kim Brugger" \
    description="Docker image containing an installation of the ricopili tools version: 2019_Jun_25.001"

# for the tzdata package
RUN ln -fs /usr/share/zoneinfo/Europe/Berlin /etc/localtime


RUN apt-get update && apt-get install -y --no-install-recommends curl  ca-certificates \
             r-base make tk-dev gcc gfortran texlive texlive-fonts-extra \
	     libreadline-dev xorg-dev libxml2-dev libcurl4-gnutls-dev  libgfortran3  \
	     && apt-get clean

RUN useradd -d /ricopili -U -m -s /bin/bash ricopili

RUN mkdir -p  /ricopili/bin \
              /ricopili/dependencies \
              /ricopili/log/ \
	      /ricopili/reference \
	      /scratch /refs/ /cluster /work /tsd /projects /net

RUN curl -Lo /tmp/rp_bin.tgz https://sites.google.com/a/broadinstitute.org/ricopili/download/rp_bin.2019_Jun_25.001.tar.gz && \
      tar zxvf /tmp/rp_bin.tgz --strip 1 -C /ricopili/bin/ && \
      chmod 755 -R /ricopili/bin/ && \
      rm /tmp/rp_bin.tgz

RUN curl -Lo /tmp/rp_dep.tgz https://storage.googleapis.com/cloud-ricopili/dependencies/Ricopili_Dependencies.1118b.tar.gz && \
    tar zxvf /tmp/rp_dep.tgz -C /ricopili/dependencies/ && \
    chmod 755 /ricopili/dependencies/ && \
    rm /tmp/rp_dep.tgz 

RUN Rscript -e 'install.packages("rms",   repos="https://cloud.r-project.org" lib="/ricopili/dependencies/R_packages")' && \
    Rscript -e 'install.packages("rmeta", repos="https://cloud.r-project.org")' && \
    Rscript -e 'install.packages("pROC",  repos="https://cloud.r-project.org")' && \
    Rscript -e 'install.packages("MASS",  repos="https://cloud.r-project.org")'

RUN curl -o /tmp/Miniconda2-latest-Linux-x86_64.sh https://repo.anaconda.com/miniconda/Miniconda2-latest-Linux-x86_64.sh && \
    sh /tmp/Miniconda2-latest-Linux-x86_64.sh -b -f -p /usr/local/ && \
    rm /tmp/Miniconda2-latest-Linux-x86_64.sh &&\
    cd /ricopili/dependencies/ldsc/ && \
    conda env create --file environment.yml


#RUN cd /ricopili/reference && curl -LO https://storage.googleapis.com/cloud-ricopili/dependencies/HRC.r1-1.EGA.GRCh37.metafiles.deploy.tar.gz.cksum
#RUN cd /ricopili/reference \
#    && curl -LO https://storage.googleapis.com/cloud-ricopili/dependencies/HRC.r1-1.EGA.GRCh37.metafiles.deploy.tar.gz \
#    && tar zxf HRC.r1-1.EGA.GRCh37.metafiles.deploy.tar.gz \
#    && rm HRC.r1-1.EGA.GRCh37.metafiles.deploy.tar.gz
    

#RUN cd /ricopili/reference && curl -LO https://storage.googleapis.com/cloud-ricopili/dependencies/HRC.r1-1.EGA.GRCh37.1KG_pops.tar.gz.cksum
#RUN cd /ricopili/reference \
#    && curl -LO https://storage.googleapis.com/cloud-ricopili/dependencies/HRC.r1-1.EGA.GRCh37.1KG_pops.tar.gz \
#    && tar zxf HRC.r1-1.EGA.GRCh37.1KG_pops.tar.gz \ 
#    && rm HRC.r1-1.EGA.GRCh37.1KG_pops.tar.gz

#RUN cd /ricopili/reference && curl -LO https://storage.googleapis.com/cloud-ricopili/dependencies/human_g1k_v37.fasta.gz.cksum
#RUN cd /ricopili/reference \
#    && curl -LO https://storage.googleapis.com/cloud-ricopili/dependencies/human_g1k_v37.fasta.gz \
#    && gunzip -q human_g1k_v37.fasta.gz || touch /tmp/gzip.warning

RUN pip install --upgrade pip --no-cache-dir && \
    pip install  --no-cache-dir --no-deps bitarray==0.8 pandas==0.20 scipy #pybedtools==0.7 pysam==0.15 

#log-files
RUN touch /ricopili/log/preimp_dir_info \
          /ricopili/log/impute_dir_info \
	  /ricopili/log/pcaer_info \
	  /ricopili/log/idtager_info \
	  /ricopili/log/repqc2_info \
	  /ricopili/log/areator_info \
	  /ricopili/log/merge_caller_info \
	  /ricopili/log/postimp_navi_info \
	  /ricopili/log/reference_dir_info \
	  /ricopili/log/test_info \
	  /ricopili/log/clumper_info

#RUN curl -o /ricopili/rp_config.custom.serial.txt https:/personal.broadinstitute.org/sripke/share_links/rp_config_collections/rp_config.custom.serial.txt

#RUN curl -o  /ricopili/ricopili.conf https://raw.githubusercontent.com/bruggerk/ricopili_docker/master/ricopili.conf
# To build wo/ caching from now on: docker build -t your-image --build-arg CACHEBUST=$(date +%s)
ARG CACHEBUST=1
RUN rm -f /ricopili/ricopili.conf && \
    curl -o  /ricopili/ricopili.conf https://raw.githubusercontent.com/bruggerk/ricopili_docker/master/ricopili.conf


ENV PATH /ricopili/bin:/ricopili/bin/pdfjam:$PATH
ENV rp_perlpackages /ricopili/dependencies/perl_modules/
ENV RPHOME /ricopili/


