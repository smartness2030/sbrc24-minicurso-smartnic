# Nvidia BlueField-2 Hands-on Activity

We will demonstrate the step-by-step process of setting up a DOCA application. Firstly, we need to set up our environment correctly. Afterward, we will describe a simple DOCA Flow application that utilizes DOCA pipes to offload packet processing to the BlueField SmartNIC. For this hands-on activity, we skip the DOCA installation procedure. For more details, please check the SBRC book chapter or the NVIDIA DOCA documentation.  

## Getting Acess the BlueField Server

We set a server having a Nvidia BlueField-2 to our activitiy. First we need to access our gateway, then we jump to our server. Finally we access the BlueField. 
- Gateway: IP 200.132.136.81 (usr: sbrc24, psw: sbrc2024@niteroi)
- Server: IP 10.10.10.202 (usr: sbrc24, psw: sbrc2024@niteroi)
- BlueField: IP 192.168.100.2 (usr: sbrc24, psw: sbrc2024@niteroi)

- Everything needs to be executed as `root`

## Step 1: Understanding how BlueField steer network traffic

- **Goal 1:** understand how physical ports and virtual ports are interconnected in the BlueField
- **Goal 2:** add and configure virtual ports (SFs) in the BlueField
  
If everything goes smoothly, you will be logged into the SmartNIC operating system. By default, the SmartNIC OS comes with an Open vSwitch (OVS) that has two default bridges named *ovsbr1* and *ovsbr28. In each bridge, there is a physical port attached, namely *p1* and *p2*. Each OVS bridge has at least one host interface representator, such as *pf1hpf* and *pf0hpf*. These interface representators are used to connect with the host interfaces. Lastly, each OVS bridge comes with a Scalable Function (e.g., *en3f1pf1sf0* and *en3f0pf0sf0*). Scalable Functions (SFs), or sub-functions, are similar to Virtual Functions (VFs) that are part of a Single Root I/O Virtualization (SR-IOV) solution. An SF is a lightweight function that has a parent PCIe function on which it is deployed. The SF, therefore, has access to the capabilities and resources of its parent PCIe function, and it has its own function capabilities and resources. This means that an SF also has its own dedicated queues (i.e., txq, rxq).

- Show OVS bridges and existing attached ports: execute `ovs-vsctl show`
- Show existing Scalable Functions in the system: execute `/opt/mellanox/iproute2/sbin/mlxdevm port show` 

SFs are used by DOCA applications and communicate with the physical port by SF representators. It is possible to dynamically add, remove, or modify SFs according to the application's needs using the *mlxdevm port* command.  Next, we can use the *mlxdevm port show* command to list all registered SFs and their features. For instance, we can see the SF identifier (e.g., 229408) and to which physical port each SF is attached. For example, the SF *pci/0000:03:00.0/229408* is attached to physical port 0.

### Creating Scalable Functions

Next, we will create, configure and deploy two Scalable Functions. SFs need to be created, configured, and deployed. 

To create a new SF, we need to attach it to a physical port (either pci/0000:03:00.0 or pci/0000:03:00.1). Then, we should defined an id to SF (sfnum) -- in the example below, we set sfnum to 10. **IMPORTANT**: please ensure to select a different sfnum than other atendees (we are using the same BlueField card here)

`/opt/mellanox/iproute2/sbin/mlxdevm port add pci/0000:03:00.0 flavour pcisf pfnum 0 sfnum 10`
`/opt/mellanox/iproute2/sbin/mlxdevm port add pci/0000:03:00.1 flavour pcisf pfnum 1 sfnum 10`
`/opt/mellanox/iproute2/sbin/mlxdevm port show` 

At this point, running the coomand below, you should see the new added SFs. A SF has netdev representator en3f1pf1sf10 and en3f0pf0sf10.  

To configure SFs, we run the following command. Note that we need to specify the SF refenrece id (something like pci/0000:03:00.1/294945). To get it, analyze the output of command (mlxdevm port show). 

`/opt/mellanox/iproute2/sbin/mlxdevm port function set pci/0000:03:00.1/294945 hw_addr 00:00:00:00:00:01 trust on state active`

`/opt/mellanox/iproute2/sbin/mlxdevm port function set pci/0000:03:00.0/229409 hw_addr 00:00:00:00:00:02 trust on state active`

To deploy SFs, we need to bind them to the mlx5 driver. Before, we need to get the *auxiliary device name* (something like mlx5_core.sf.4). For that, run `mlnx-sf -a show` and look for the SF just created (either by the SF Index or by SF representator netdev). Then execute the following (replacing the *auxiliary device name*)

`echo mlx5_core.sf.4  > /sys/bus/auxiliary/drivers/mlx5_core.sf_cfg/unbind`
`echo mlx5_core.sf.4  > /sys/bus/auxiliary/drivers/mlx5_core.sf/bind`
`echo mlx5_core.sf.5  > /sys/bus/auxiliary/drivers/mlx5_core.sf_cfg/unbind`
`echo mlx5_core.sf.5  > /sys/bus/auxiliary/drivers/mlx5_core.sf/bind`

Run `mlnx-sf -a show` and you will see that everything now is configured. 

