sudo apt-get -yy update
sudo apt-get -yy install ansible git

cd /tmp

# Assuming here we don't rely on any ssh keys
git clone https://github.com/matiasozdy/tempstats.git

cd tempstats

sudo ansible-pull -U /tmp/tempstats -i hosts
