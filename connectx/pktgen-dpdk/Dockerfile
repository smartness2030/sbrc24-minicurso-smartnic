FROM ubuntu:22.04
RUN apt update; apt install -y build-essential git libibverbs-dev libnuma-dev libpcap-dev librte-net-bond22 meson ninja-build pciutils pkg-config python3-pyelftools
RUN git clone -b v24.03 https://github.com/DPDK/dpdk
RUN git clone -b pktgen-24.03.1 https://github.com/pktgen/Pktgen-DPDK
WORKDIR /dpdk
RUN meson build
RUN ninja -C build
WORKDIR /dpdk/build
RUN meson install
ENV PKG_CONFIG_PATH=/usr/lib/x86_64-linux-gnu/pkgconfig
WORKDIR /Pktgen-DPDK
RUN make
RUN make install
RUN cp usr/local/bin/pktgen /usr/local/bin/
RUN ldconfig
CMD pktgen
