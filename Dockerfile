FROM ubuntu:19.04
MAINTAINER Pavel Tatashin

# http://www.yoctoproject.org/docs/current/ref-manual/ref-manual.html
# Update package infos first
RUN DEBIAN_FRONTEND=noninteractive apt-get update -y --no-install-recommends \
&& DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
   apt-utils dialog locales gawk wget git-core diffstat unzip texinfo \
   gcc-multilib build-essential chrpath socat cpio python python3 python3-pip \
   python3-pexpect xz-utils debianutils iputils-ping vim bc g++-multilib \
   libsdl1.2-dev xterm make xsltproc docbook-utils fop dblatex xmlto python-git \
   sed cvs subversion coreutils texi2html python-pysqlite2 help2man  gcc g++ \
   desktop-file-utils libgl1-mesa-dev libglu1-mesa-dev mercurial autoconf \
   automake groff curl lzop asciidoc u-boot-tools ssh sudo file libssl-dev \
   libncurses-dev bison flex rsync imagemagick python-wand libmagickwand-dev \
   libunwind8 libunwind8-dev libffi-dev python-dev

# Set the locale, else yocto will complain
RUN locale-gen en_US.UTF-8
ENV LANG=en_US.UTF-8 LANGUAGE=en_US:en LC_ALL=en_US.UTF-8

# default workdir is /yocto
WORKDIR /hl

# install vsts-cli
#RUN wget https://github.com/Microsoft/vsts-cli/releases/download/0.1.4/install.py -O /tmp/install.py
# Get the latest install.py version path in /tmp/vsts-path, assume file has INSTALL_SCRIPT_URL="path"
RUN wget -O - https://aka.ms/install-vsts-cli 2>&1 | grep INSTALL_SCRIPT_URL | head -1 | cut -f2 -d= | tr -d '"' > /tmp/vsts-path
RUN wget -i /tmp/vsts-path -O /tmp/install.py
RUN chmod +x /tmp/install.py
RUN echo -e "y\n/opt/vsts-cli\ny\n/etc/bash.bashrc\n" | sudo /tmp/install.py
RUN rm /tmp/install.py /tmp/vsts-path

# Add entry point, we use entrypoint to mapping host user to
# container
COPY ./entrypoint /entrypoint
RUN chmod +x /entrypoint
ENTRYPOINT ["/entrypoint"]
