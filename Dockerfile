FROM 300288021642.dkr.ecr.eu-west-2.amazonaws.com/ch-oraclelinux:1.0.0

 ENV ORACLE_HOME=/apps/oracle \
     GS_MAIN_VERSION=ghostscript/ghostscript-9.26-linux-x86_64/gs-926-linux-x86_64 \
     GS_ALT_VERSION=ghostscript/ghostscript-9.18-linux-x86_64/gs-918-linux-x86_64 

 RUN mkdir -p /apps && \
     chmod a+xr /apps && \
     useradd -d ${ORACLE_HOME} -m -s /bin/bash weblogic

 USER weblogic

 # Copy all batch jobs to ORACLE_HOME
 COPY --chown=weblogic image-converters ${ORACLE_HOME}/

 RUN cd ${ORACLE_HOME} && mkdir ghostscript && cd ghostscript && \
    curl -L https://github.com/ArtifexSoftware/ghostpdl-downloads/releases/download/gs926/ghostscript-9.26-linux-x86_64.tgz -o gs.tgz && \
    tar -xvzf *.tgz && rm *.tgz && \
    curl -L https://github.com/ArtifexSoftware/ghostpdl-downloads/releases/download/gs918/ghostscript-9.18-linux-x86_64.tgz -o gs.tar && \
    tar -xvf *.tar && rm *.tar

 RUN bash
