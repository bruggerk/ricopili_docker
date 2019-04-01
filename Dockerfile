FROM centos

MAINTAINER Kim Brugger <kim.brugger@uib.no>
LABEL authors="Kim Brugger" \
    description="Docker image containing an installation of the ricopili tools version: 2019_Feb_6.001"

#Stuff we need:
RUN yum install -y epel-release && \
    yum install -y libgomp perl bzip2 R mailx python2-pip python-devel perl-IO-Zlib less vim  && \
    yum clean  packages


RUN Rscript -e 'install.packages("rmeta", repos = "http://cran.us.r-project.org")'
    

RUN pip install --upgrade pip --no-cache-dir
RUN /usr/bin/pip install  --no-cache-dir --no-deps bitarray==0.8 pandas==0.20 pybedtools==0.7 pysam==0.15 


RUN curl -o /tmp/Miniconda2-latest-Linux-x86_64.sh https://repo.anaconda.com/miniconda/Miniconda2-latest-Linux-x86_64.sh && \
  sh /tmp/Miniconda2-latest-Linux-x86_64.sh -b -f -p /usr/local/ && \
  rm /tmp/Miniconda2-latest-Linux-x86_64.sh



RUN mkdir -p  /ricopili/{rp_bin,rp_dep} /scratch /refs/ /cluster /work /tsd /projects /net


RUN curl -o /tmp/rp_dep.tgz  https://personal.broadinstitute.org/sripke/share_links/JeklRDhPD6FKm8Gnda7JsUOsMan2P2_Ricopili_Dependencies.1118b.tar.gz/Ricopili_Dependencies.1118b.tar.gz && \
  tar zxvf /tmp/rp_dep.tgz -C /ricopili/rp_dep/ && \
  chmod 755 /ricopili/rp_dep/ && \
  rm /tmp/rp_dep.tgz && \
  chmod 755 -R /ricopili/rp_dep/ && \
  cd /ricopili/rp_dep/ldsc/ && \
  conda env create --file environment.yml


RUN curl -Lo /tmp/rp_bin.tgz https://sites.google.com/a/broadinstitute.org/ricopili/download/rp_bin.2019_Feb_18.001.tar.gz && \
   tar zxvf /tmp/rp_bin.tgz -C /ricopili/ && \
   chmod 755 /ricopili/rp_bin/ 



RUN curl -o  /ricopili/ricopili.conf https://raw.githubusercontent.com/bruggerk/ricopili_docker/master/ricopili.conf


ENV PATH /ricopili/rp_bin:/ricopili/rp_bin/pdfjam:$PATH
ENV rp_perlpackages /ricopili/rp_dep/perl_modules/
ENV RPHOME /ricopili


