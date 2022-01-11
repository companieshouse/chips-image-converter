FROM 300288021642.dkr.ecr.eu-west-2.amazonaws.com/ch-oraclelinux:1.0.0

ENV ORACLE_HOME=/apps/oracle \
    GS_MAIN_VERSION=ghostscript/ghostscript-9.26-linux-x86_64/gs-926-linux-x86_64 \
    GS_ALT_VERSION=ghostscript/ghostscript-9.18-linux-x86_64/gs-918-linux_x86_64

RUN curl http://mirror.centos.org/centos/7/os/x86_64/Packages/libtiff-tools-4.0.3-35.el7.x86_64.rpm -o libtiff-tools.rpm && \ 
    yum -y install libtiff-tools.rpm && \
    yum clean all && \
    rm -rf /var/cache/yum && \
    rm libtiff-tools.rpm

RUN mkdir -p /apps && \
    chmod a+xr /apps && \
    useradd -d ${ORACLE_HOME} -m -s /bin/bash weblogic

USER weblogic

 # Copy all batch jobs to ORACLE_HOME
 # Install gs
COPY --chown=weblogic image-converters ${ORACLE_HOME}/

RUN cd ${ORACLE_HOME} && mkdir ghostscript && mkdir EFAttachments && cd ghostscript && \
    curl -L https://github.com/ArtifexSoftware/ghostpdl-downloads/releases/download/gs926/ghostscript-9.26-linux-x86_64.tgz -o gs.tgz && \
    tar -xvzf *.tgz && rm *.tgz && \
    curl -L https://github.com/ArtifexSoftware/ghostpdl-downloads/releases/download/gs918/ghostscript-9.18-linux-x86_64.tgz -o gs.tar && \
    tar -xvf *.tar && rm *.tar  

# JetPcl
ENV JET_PCL=JetPclLnx.tar.Z \
    JET_PCL_64=JetPclL64.zip 

COPY --chown=weblogic $JET_PCL /tmp/jet_pcl.tar.Z 

# Install JetPcl Installation
RUN cd ${ORACLE_HOME} && \ 
    gzip -d /tmp/jet_pcl.tar.Z && \ 
    tar xvf /tmp/jet_pcl.tar && \
    rm /tmp/jet_pcl.tar  

 #Install JetPcl 64 bit executable
 COPY --chown=weblogic $JET_PCL_64 /tmp/jet_pcl_64.zip

 RUN cd /tmp && \ 
     unzip jet_pcl_64.zip && \
     cp /tmp/JetPcl ${ORACLE_HOME}/JetPcl && \
     chmod +x ${ORACLE_HOME}/JetPcl/JetPcl && \
     rm -fr /tmp/JetPcl && \
     rm jet_pcl_64.zip 

 RUN bash
