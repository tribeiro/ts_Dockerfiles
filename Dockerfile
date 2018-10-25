# Dockerfile to execute a base machine with all set to execute the Test example of a CSC of salObj

FROM lsstsqre/centos:7-stack-lsst_distrib-v16_0

LABEL author="Andres Anania <aanania@lsst.org>"

# CMD source /opt/lsst/software/stack/loadLSST.bash
# RUN setup lsst_distrib
USER root

RUN yum install -y https://centos7.iuscommunity.org/ius-release.rpm

RUN yum -y --enablerepo=extras install java-1.8.0-openjdk-devel \
  which \
  nano \
  emacs \
  python36-devel

RUN ln -s /usr/include/python3.6m/ /usr/local/include/python3.6m

USER lsst

WORKDIR /home/lsst
RUN mkdir repos
WORKDIR /home/lsst/repos

RUN git clone https://github.com/lsst-ts/ts_opensplice.git
RUN git clone https://github.com/lsst-ts/ts_sal.git -b "v3.8.13"
RUN git clone https://github.com/lsst-ts/salobj.git -b develop
RUN git clone https://github.com/lsst-ts/ts_xml.git

WORKDIR /home/lsst/repos/ts_xml
RUN git checkout "f8163fcc782a03980e6580d7b08ace22e586d4c6"

WORKDIR /home/lsst/

ADD --chown=lsst:lsst ./environment.env /home/lsst/repos/environment.env
ADD --chown=lsst:lsst ./salgenerate.sh /home/lsst/repos/salgenerate.sh
RUN chmod u+x /home/lsst/repos/environment.env
RUN chmod u+x /home/lsst/repos/salgenerate.sh

ENV LSST_SDK_INSTALL=/home/lsst/repos/ts_sal
ENV OSPL_HOME=/home/lsst/repos/ts_opensplice/OpenSpliceDDS/V6.4.1/HDE/x86_64.linux
ENV PYTHON_BUILD_VERSION=3.6m
ENV PYTHON_BUILD_LOCATION=/usr/local
ENV LSST_DDS_DOMAIN=citest

#CMD source /home/lsst/repos/ts_sal/setup.env

#WORKDIR /home/lsst/repos/ts_sal/test
#RUN cp /home/lsst/repos/ts_xml/sal_interfaces/Test/Test_* .
#RUN cp /home/lsst/repos/ts_xml/sal_interfaces/SALSubsystems.xml .

#RUN sh /home/lsst/repos/salgenerate.sh
#COPY startup.sh /home/lsst/startup.sh
#RUN chmod +x /home/opsim/startup.sh

# entrypoint
#ENTRYPOINT source /home/lsst/ts_sal/setup.env && \
#cd /home/lsst/ts_sal/test \
#ENTRYPOINT ["/bin/bash", "--"]
#CMD ["/home/lsst/repos/salgenerate.sh"]
