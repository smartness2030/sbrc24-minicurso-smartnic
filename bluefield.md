# Nvidia BlueField-2 Hands-on Activity

We will demonstrate the step-by-step process of setting up a DOCA application. Firstly, we need to set up our environment correctly. Afterward, we will describe a simple DOCA Flow application that utilizes DOCA pipes to offload packet processing to the BlueField SmartNIC. For this hands-on activity, we skip the DOCA installation procedure. For more details, please check the SBRC book chapter or the NVIDIA DOCA documentation.  

## Getting Acess the BlueField Server

We set a server having a Nvidia BlueField-2 to our activitiy. First we need to access our gateway, then we jump to our server. Finally we access the BlueField. 
- Gateway: IP 200.132.136.81 (usr: sbrc24, psw: sbrc2024@niteroi)
- Server: IP 10.10.10.202 (usr: sbrc24, psw: sbrc2024@niteroi)
- BlueField: IP 192.168.100.2 (usr: sbrc24, psw: sbrc2024@niteroi)

## Configuring Scalable Functions

If everything goes smoothly, you will be logged into the SmartNIC operating system. By default, the SmartNIC OS comes with an Open vSwitch (OVS) that has two default bridges named *ovsbr1* and *ovsbr28. In each bridge, there is a physical port attached, namely *p1* and *p2*. Each OVS bridge has at least one host interface representator, such as *pf1hpf* and *pf0hpf*. These interface representators are used to connect with the host interfaces. Lastly, each OVS bridge comes with a Scalable Function (e.g., *en3f1pf1sf0* and *en3f0pf0sf0*). Scalable Functions (SFs), or sub-functions, are similar to Virtual Functions (VFs) that are part of a Single Root I/O Virtualization (SR-IOV) solution. An SF is a lightweight function that has a parent PCIe function on which it is deployed. The SF, therefore, has access to the capabilities and resources of its parent PCIe function, and it has its own function capabilities and resources. This means that an SF also has its own dedicated queues (i.e., txq, rxq).

