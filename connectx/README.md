# Nvidia Connectx Hands-on with SmartNIC offload capabilities

We will demonstrate the offload capabilities of the Nvidia Connectx SmartNIC. We will compare the performance of a software router with and without offloads. To implement the software router, we will use Vector Packet Processing (VPP) [Barach et al. 2018], a high-performance network stack that supports different data planes (Linux, RDMA, and DPDK). VPP can be used as vSwitches, vRouters, Gateways, Firewalls, and Load-Balancers. The reference traffic generator from DPDK, Pktgen-DPDK, will be used to stress test VPP. It can generate 100Gbps using a single CPU core. We will conduct the tests using Nvidia Connectx-6 SmartNIC, which is available on testbeds like FABRIC and RNP Testbed Service16 to facilitate replication of this example.

# Getting Acess to the Nvidia ConnectX SmartNIC

This tutorial is using resources from the [FABRIC Testbed](https://portal.fabric-testbed.net/), you can register an account and submit a project proposal.
To replicate this tutorial, copy the content of this repository to your FABRIC JupyterHub and execute the stpes in [dpdk_vpp_trex.ipynb](dpdk_vpp_trex.ipynb)
The expected output for the tutorial is also available at [dpdk_vpp_trex-dirty.ipynb](dpdk_vpp_trex-dirty.ipynb)
