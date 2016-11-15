# Tempstats
This is a project for automating the install of a gearman server/client that gathers temperature statistics from a given city.

Methods of provisioning it:
- Vagrant: just type "vagrant up" on this root.
- Amazon: Using terraform, type "terraform apply" on this root (need to edit provision.tf file for key/Access keys).

Automation has been done using Ansible.

Access:
- Vagrant: http://localhost:1234/?city=CITYNAME . SSl certificates installed for api.tempstats.com.
- Amazon: http://instanceip/?city=CITYNAME. SSl certificates also installed.

