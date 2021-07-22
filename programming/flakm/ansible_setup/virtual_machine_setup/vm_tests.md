# How to test using virtual machines

Create vm using installation media: 

```bash
virt-install --name=linuxconfig-vm \
--vcpus=2 \
--memory=10240 \
--cdrom=/home/flakm/Downloads/kubuntu-21.04-desktop-amd64.iso \
--disk path=/media/old_windows//ububu.qcow2,size=80,format=qcow2 \
--os-variant=ubuntu20.10
```

create snapshot:

```bash
virsh snapshot-create-as \
    --domain linuxconfig-vm \
    --name linuxconfig-vm-snap \
    --description "snap with empty kuubuntu"

# list snapshots
virsh snapshot-list linuxconfig-vm 
# revert snapshot
virsh snapshot-revert linuxconfig-vm linuxconfig-vm-snap

```
