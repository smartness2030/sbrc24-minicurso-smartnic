# P4 Programming Tutorial on Netronome SmartNICs
This tutorial provides a basic introduction to P4 (Programming Protocol-independent Packet Processors) programming on Netronome SmartNICs. Here you will find all the steps for installing and setting up the development environment, as well as presenting, implementing, and running a simple P4 program on a Netronome SmartNIC.

The tutorial is designed in a simple and straightforward manner, aiming to abstract away the common complexities found in hardware programming. The goal is to provide a quick learning curve by covering only the essential topics up to the implementation of the first program.

# Prerequisites
- Advanced knowledge of computer networks.
- Familiarity with Linux and command line.
- Basic understanding of the P4 language.
-Access to a Netronome SmartNIC (in this tutorial, we will use the Netronome Agilio CX 2x10Gb).

# Installation and Environment Setup
To install the necessary drivers and modules and configure the environment, follow the instructions below, as root:

`cd ~'`
`git clone git clone https://github.com/guimvmatos/SBRC24NetronomeTutorial.git`

- Access the Agilio-P4-SmartNIC directory.
- Follow the presented tutorial to install the required drivers and modules.

By following these steps, you will be ready to start developing and running your P4 programs on Netronome SmartNIC. In the instalation directory you'll find a lot of netronome related documents, that can be usefull in case of you want do deep into this technology.

## Details about Netronome architecture

The Netronome SmartNIC uses single-root input/output virtualization (SRIOV), which enables virtual functions (VFs) to be created from a physical function (PF). The VFs thus share the resources of a PF, while VFs remain isolated from each other. The isolated VFs are typically assigned to virtual machines (VMs) on the host. In this way, the VFs allow the VMs to directly access the PCI device, thereby bypassing the host kernel. In this tutorial, we have two physical (p0, p1) and four virtual interfaces (Vf0\_1 to Vf0\_5). We will work with a P4 program that implements simple IPv6 forwarding, which can be found at IPv6Forwarding.

# Deployment

Here we'll show how to deploy, configure, and debug your programs on Netronome SmartNICs. We are taking into consideration that you already clone this repository and that your environment is already installed and configured.

Once you already have your Netronome installed and configured on your machine, you need to locate the src/p4-16 folder, inside the Agilio-P4-SmartNIC directory (probably in `/root/SBRC24NetronomeTutorial/Agilio-P4-SmartNIC/src`). This folder contains all the programs that you can run on your Netronome SmartNIC. You may even find different programs from the one we are going to test. To get started, make sure you are inside the p4-16 folder, and then create a folder called SimpleIPv6. After that, copy the contents of the IPv6Forwarding folder into the folder you just created:
```
cd /root/SBRC24NetronomeTutorial/Agilio-P4-SmartNIC/src
mkdir SimpleIPv6
cd SimpleIPv6/
cp ../../../IPv6Forwarding/ipv6_forward.p4 ./
cp ../../../IPv6Forwarding/user_config.json ./
```

For P4 programming using Netronome, these two files are all that is needed. The ipv6_forwarding.p4 file represents our program itself. And the user_config.json is the file that will populate the control plane tables. As this tutorial is for those who are already familiar with the P4 programming language, we will not go into details. However, a very common issue for those who are starting to program using Netronome SmartNICs is how to perform interface assignment in the data plane table. For example, looking at the P4 code, we can find the following action:

```action ipv6_forward (macAddr_t dstAddr, egressSpec_t port) {
        standard_metadata.egress_spec = port;
        hdr.ethernet.dstAddr = dstAddr;
```

Esta ação receberá uma porta com parametro, que será a porta de saída do pacote em questão. Quando estamos trabalhando com smartnics Netronome, temos as interfaces físicas e as virtuais. You can configure this setting by editing the following file: `/lib/systemd/system/nfp-sdk6-rte.service`. locate and change the following line.

This action will receive a port as a parameter, which will be the output port of the packet. When we are working with Netronome SmartNICs, we have physical and virtual interfaces. You can configure this setting by editing the following file: `/lib/systemd/system/nfp-sdk6-rte.service`. Locate and change the following line.

`Environment=NUM_VFS=4`

With this configuration, you will have 4 virtual interfaces, called VFs. And they can be instantiated in the control plane tables as "v0.0", "v0.1", "v0.2", and "v0.3". If you want to use the physical interfaces, you should refer to them as "p0" and "p1".

In the user_config.json file, we can find examples of how to populate the control plane tables using the aforementioned nomenclature.

Now that we have copied the two necessary files, we should call the compiler passing the P4 file as a parameter to create firmware. Then, we will deploy the firmware to the board, and finally, we will populate the control plane tables. To do this, execute the following commands:

```
sudo /opt/netronome/p4/bin/./nfp4build --nfp4c_p4_version 16 --no-debug-info -p out -o firmware.nffw -l lithium -4 ipv6_forward.p4
sudo /opt/netronome/p4/bin/./rtecli design-load -f firmware.nffw -p out/pif_design.json
sudo /opt/netronome/p4/bin/rtecli config-reload -c user_config.json
```

To debug, you can look at the logs in /var/log/nfp-sdk6-rte.log. Here you will find all errors related to the service, deployment, and usage. In other words, if you encounter issues with initializing the service or deploying the program, you can find the logs and better understand what is happening.

Note: after creating the firmware, you will notice that many files have been generated. Don't worry, this is normal.

About the control plane configuration, if you want, you can check the configured rules.
```
sudo /opt/netronome/p4/bin/./rtecli tables -i 0 list-rules
```

Now your board is properly configured with a simple code that will forward data from one virtual port to another using IPv6. You can use the Python scripts send_pkt.py and receive.py, where the first one will send a packet from interface v0.0 to interface v0.3. And the second one will capture the packet on the destination interface.

To run the test programs, open more two shells, navigate `/root/SBRC24NetronomeTutorial/IPv6Forwarding` directory, and in the first shell, run the command `python3 receive.py`. The program will execute and wait for any packet received on interface v0.3. After that, in the second terminal, run `python3 send_pkt.py`. Following this, a packet will be sent on interface v0.0 destined for v0.3. The execution of these Python programs depends on the configuration of each computer and the version of Python.

If the execution of the programs was successful, congratulations! You have completed this tutorial, and the program is ready for the next step. If you are interested in delving deeper and performing more advanced functions, perhaps [this repository](https://github.com/guimvmatos/P4-INCA) will interest you. There, you will also find a tutorial for deploying a more advanced program, using SRv6 to connect traffic from multiple virtual machines. Feel free to explore and give it a try.
