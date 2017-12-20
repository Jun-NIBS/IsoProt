FROM biocontainers/biocontainers:latest

USER root

# Install R
RUN apt-get update && \
    apt-get install -y apt-transport-https && \
    echo "deb https://cran.wu.ac.at/bin/linux/ubuntu xenial/" >> /etc/apt/sources.list && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9 && \
    apt-get update && \
    apt-get install -y libcurl4-openssl-dev libssl-dev libxml2-dev r-base r-base-dev 

# Setup R
ADD DockerSetup/install_packages.R /tmp/

RUN Rscript /tmp/install_packages.R && \
    rm /tmp/install_packages.R

# Install Mono
RUN apt-get install -y mono-complete

# Install SearchGui and PeptideShaker
USER biodocker

RUN ZIP=PeptideShaker-1.10.3.zip && \
    wget -q https://github.com/BioDocker/software-archive/releases/download/PeptideShaker/$ZIP -O /tmp/$ZIP && \
    unzip /tmp/$ZIP -d /home/biodocker/bin/ && \
    rm /tmp/$ZIP && \
    bash -c 'echo -e "#!/bin/bash\njava -jar /home/biodocker/bin/PeptideShaker-1.10.3/PeptideShaker-1.10.3.jar $@"' > /home/biodocker/bin/PeptideShaker && \
    chmod +x /home/biodocker/bin/PeptideShaker && \
    ZIP=SearchGUI-2.8.6.zip && \
    wget -q https://github.com/BioDocker/software-archive/releases/download/SearchGUI/$ZIP -O /tmp/$ZIP && \
    unzip /tmp/$ZIP -d /home/biodocker/bin/ && \
    rm /tmp/$ZIP && \
    bash -c 'echo -e "#!/bin/bash\njava -jar /home/biodocker/bin/SearchGUI-2.8.6/SearchGUI-2.8.6.jar $@"' > /home/biodocker/bin/SearchGUI && \
    chmod +x /home/biodocker/bin/SearchGUI


ENV PATH /home/biodocker/bin/SearchGUI:/home/biodocker/bin/PeptideShaker:$PATH

WORKDIR /data/