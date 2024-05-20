#deleting bridges
ovs-vsctl del-br ovsbr1
ovs-vsctl del-br ovsbr2

ovs-vsctl add-br ovsbr1
ovs-vsctl add-br ovsbr2

#add ports
ovs-vsctl add-port ovsbr1 p0
ovs-vsctl add-port ovsbr1 pf0hpf
ovs-vsctl add-port ovsbr2 p1
ovs-vsctl add-port ovsbr2 pf1hpf

#delete all SFs

for i in `mlnx-sf -a show | grep pci/ | awk '{print $3}'`; do echo $i ; /opt/mellanox/iproute2/sbin/mlxdevm port del $i ; done

#creating two SFs
/opt/mellanox/iproute2/sbin/mlxdevm port add pci/0000:03:00.0 flavour pcisf pfnum 0 sfnum 10

/opt/mellanox/iproute2/sbin/mlxdevm port add pci/0000:03:00.1 flavour pcisf pfnum 1 sfnum 10

macID=1;
for i in `mlnx-sf -a show | grep pci/ | awk '{print $3}'`; do echo $i ; /opt/mellanox/iproute2/sbin/mlxdevm port function set $i hw_addr 00:00:00:00:00:0$macID trust on state active ; macID=$((macID+1)) ;  done

#deploying (bindind driver)
for i in `mlnx-sf -a show | grep mlx5 | awk '{print $3}'`; do echo $i ; echo $i > /sys/bus/auxiliary/drivers/mlx5_core.sf_cfg/unbind ; echo $i > /sys/bus/auxiliary/drivers/mlx5_core.sf/bind ; done

#add SF to OVS

netdev=`mlnx-sf -a show | grep en3f0 | awk '{print $3}'`
ovs-vsctl add-port ovsbr1 $netdev

netdev=`mlnx-sf -a show | grep en3f1 | awk '{print $3}'`
ovs-vsctl add-port ovsbr2 $netdev
