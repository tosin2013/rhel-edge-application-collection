# set locale defaults for the Install
lang en_US.UTF-8
keyboard us
timezone UTC

# initialize any invalid partition tables and destroy all of their contents
zerombr

# erase all disk partitions and create a default label
clearpart --all --initlabel

# automatically create xfs partitions with no LVM and no /home partition
autopart --type=plain --fstype=xfs --nohome

# reboot after installation is successfully completed
reboot

# installation will run in text mode
text

# activate network devices and configure with DHCP
network --bootproto=dhcp


# create default user with sudo privileges
user --name=core --groups=wheel --password=edge

# set up the OSTree-based install with disabled GPG key verification, the base
# URL to pull the installation content, 'rhel' as the management root in the
# repo, and 'rhel/8/x86_64/edge' as the branch for the installation
ostreesetup --nogpg --url=http://10.0.2.2:8000/repo/ --osname=rhel --remote=edge --ref=rhel/8/x86_64/edge

%post --log=/root/admin-ks.log

mkdir -p /home/admin/data
curl -L https://raw.githubusercontent.com/jeremyrdavis/quarkuscoffeeshop-majestic-monolith/main/init-postgresql.sql  --output /tmp/init-postgresql.sql
cp /tmp/init-postgresql.sql /home/admin/data/init-postgresql.sql

# Set the update policy to automatically download and stage updates to be
# applied at the next reboot
#stage updates as they become available. This is highly recommended
echo AutomaticUpdatePolicy=stage >> /etc/rpm-ostreed.conf

git clone https://github.com/tosin2013/rhel-edge-application-collection.git
cd rhel-edge-application-collection
sed -i "s/192.168.1.10/$(hostname -I | awk '{print $1}')/g"  build-scripts/applications/postgresql/app_env
export ENABLE_PCP=true
./build-scripts/applications/postgresql/postgresql.sh 
podman generate systemd   --new --files --name postgresql
mv pod-postgresql.service /etc/systemd/system/pod-postgresql.service
mv container-postgresql-1.service /etc/systemd/system/container-postgresql-1.service
systemctl enable pod-postgresql.service
systemctl enable container-postgresql-1.service
%end