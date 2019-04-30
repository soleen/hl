FROM ubuntu:18.04
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
   libunwind8 libunwind8-dev libffi-dev python-dev software-properties-common

# Set the locale, else yocto will complain
RUN locale-gen en_US.UTF-8
ENV LANG=en_US.UTF-8 LANGUAGE=en_US:en LC_ALL=en_US.UTF-8

# default workdir is /highlands
WORKDIR /highlands

# install vsts-cli
#RUN wget https://github.com/Microsoft/vsts-cli/releases/download/0.1.4/install.py -O /tmp/install.py
# Get the latest install.py version path in /tmp/vsts-path, assume file has INSTALL_SCRIPT_URL="path"
RUN wget -O - https://aka.ms/install-vsts-cli 2>&1 | grep INSTALL_SCRIPT_URL | head -1 | cut -f2 -d= | tr -d '"' > /tmp/vsts-path
RUN wget -i /tmp/vsts-path -O /tmp/install.py
RUN chmod +x /tmp/install.py
RUN echo -e "y\n/opt/vsts-cli\ny\n/etc/bash.bashrc\n" | sudo /tmp/install.py
RUN rm /tmp/install.py /tmp/vsts-path

RUN DEBIAN_FRONTEND=noninteractive apt-add-repository ppa:git-core/ppa -y
RUN DEBIAN_FRONTEND=noninteractive apt-get update && sudo apt-get install -y git

RUN DEBIAN_FRONTEND=noninteractive apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF
RUN DEBIAN_FRONTEND=noninteractive apt-get install apt-transport-https
RUN DEBIAN_FRONTEND=noninteractive apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y mono-devel

RUN curl -o /tmp/cmake-3.14.2-Linux-x86_64.sh -O https://cmake.org/files/v3.14/cmake-3.14.2-Linux-x86_64.sh
RUN chmod +x ./cmake-3.14.2-Linux-x86_64.sh
RUN ./cmake-3.14.2-Linux-x86_64.sh --prefix=/opt --skip-license --include-subdir
RUN ln -s /opt/cmake-3.14.2-Linux-x86_64/bin/cmake /usr/bin/cmake
RUN ln -s /opt/cmake-3.14.2-Linux-x86_64/bin/ctest /usr/bin/ctest
RUN rm -rf /tmp/cmake-3.14.2-Linux-x86_64.sh
RUN wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key|sudo apt-key add -
RUN DEBIAN_FRONTEND=noninteractive apt-add-repository "deb http://apt.llvm.org/bionic/ llvm-toolchain-bionic-7 main"
RUN DEBIAN_FRONTEND=noninteractive apt-get update && sudo apt-get install -y clang-7 lld-7 libc++-dev libc++abi-dev

RUN ln -s /usr/bin/clang-7 /usr/bin/clang
RUN ln -s /usr/bin/clang++-7 /usr/bin/clang++
RUN ln -s /usr/bin/ld.lld-7 /usr/bin/ld.lld
RUN update-alternatives --install /usr/bin/cc cc /usr/bin/clang 100
RUN update-alternatives --install /usr/bin/c++ c++ /usr/bin/clang++ 100

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y python-pip
RUN pip install pyodbc
RUN pip install psutil

RUN curl https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
RUN curl -o /etc/apt/sources.list.d/microsoft.list https://packages.microsoft.com/config/ubuntu/$VERSION/prod.list
RUN DEBIAN_FRONTEND=noninteractive apt-get update && sudo apt-get install -y powershell

COPY ./entrypoint /entrypoint
RUN chmod +x /entrypoint
ENTRYPOINT ["/entrypoint"]
