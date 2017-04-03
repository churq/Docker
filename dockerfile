FROM centos:7


# Enable EPEL and install ssh

ENV http_proxy http://192.168.99.42:3128/
ENV https_proxy http://192.168.99.42:3128/

RUN yum -y --disableplugin=fastestmirror install epel-release 

RUN yum -y --disableplugin=fastestmirror update 
RUN yum -y --disableplugin=fastestmirror install openssh openssh-server openssh-clients openssl-libs 
RUN yum -y --disableplugin=fastestmirror clean all

RUN echo 'root:docker!' | chpasswd

RUN sed -i 's/#PermitRootLogin yes/PermitRootLogin yes/' /etc/ssh/sshd_config

RUN adduser sftp
RUN echo 'sftp:sftp' | chpasswd

COPY rsa_key.pub /home/sftp/.ssh/

EXPOSE 22

ENTRYPOINT ["/usr/sbin/sshd"]
