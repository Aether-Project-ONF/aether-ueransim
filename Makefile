#### Variables ####

export ROOT_DIR ?= $(PWD)
export AETHER_ROOT_DIR ?= $(ROOT_DIR)

export 5GC_ROOT_DIR ?= $(AETHER_ROOT_DIR)/deps/5gc
export 4GC_ROOT_DIR ?= $(AETHER_ROOT_DIR)/deps/4gc
export AMP_ROOT_DIR ?= $(AETHER_ROOT_DIR)/deps/amp
export GNBSIM_ROOT_DIR ?= $(AETHER_ROOT_DIR)/deps/gnbsim
export K8S_ROOT_DIR ?= $(AETHER_ROOT_DIR)/deps/k8s
export UERANSIM_ROOT_DIR ?= $(AETHER_ROOT_DIR)/deps/ueransim

export ANSIBLE_NAME ?= ansible-aether
export ANSIBLE_CONFIG ?= $(AETHER_ROOT_DIR)/ansible.cfg
export HOSTS_INI_FILE ?= $(AETHER_ROOT_DIR)/hosts.ini

export EXTRA_VARS ?= "@$(AETHER_ROOT_DIR)/vars/main.yml"


#### Start Ansible docker ####

ansible:
	export ANSIBLE_NAME=$(ANSIBLE_NAME); \
	sh $(AETHER_ROOT_DIR)/scripts/ansible ssh-agent bash

aether-pingall:
	echo $(AETHER_ROOT_DIR)
	ansible-playbook -i $(HOSTS_INI_FILE) $(AETHER_ROOT_DIR)/pingall.yml \
		--extra-vars "ROOT_DIR=$(ROOT_DIR)" --extra-vars $(EXTRA_VARS)

#### Provision AETHER ####
aether-k8s-install: k8s-install
aether-5gc-install: 5gc-install
aether-gnbsim-install: gnbsim-install
aether-amp-install: amp-install

aether-install: k8s-install 5gc-install gnbsim-install amp-install
aether-uninstall: monitor-uninstall roc-uninstall gnbsim-uninstall 5gc-uninstall k8s-uninstall

aether-4gc-install: 4gc-install
aether-4gc-uninstall: 4gc-uninstall

aether-resetcore: 5gc-core-uninstall 5gc-core-install

aether-gnbsim-run: gnbsim-simulator-run

aether-add-upfs: 5gc-upf-install
aether-remove-upfs: 5gc-upf-uninstall

# Rules:
#	amp-install: roc-install roc-load monitor-install monitor-load
#	amp-uninstall: monitor-uninstall roc-uninstall

#	5gc-install: 5gc-router-install 5gc-core-install
#	5gc-uninstall: 5gc-core-uninstall 5gc-router-uninstall

## run gnbsim-docker-install before running setup
#	gnbsim-install: gnbsim-docker-router-install gnbsim-docker-start 
#	gnbsim-uninstall:  gnbsim-docker-stop gnbsim-docker-router-uninstall


###  Provision k8s ####
#	k8s-install
#	k8s-uninstall

### Provision router ####
#	5gc-router-install
#	5gc-router-uninstall

### Provision core ####
#	5gc-core-install
#	5gc-core-uninstall

### Provision  AMP ####
# amp-install: k8s-install roc-install roc-load monitor-install monitor-load
# amp-uninstall: monitor-uninstall roc-uninstall k8s-uninstall

### Provision ROC ###
# roc-install
# roc-load
# roc-uninstall

### Provision Monitoring ###
# monitor-install
# monitor-load
# monitor-uninstall

### Provision gnbsim ###
# 	gnbsim-docker-install
# 	gnbsim-docker-uninstall

# 	gnbsim-docker-router-install
# 	gnbsim-docker-router-uninstall

# 	gnbsim-docker-start
# 	gnbsim-docker-stop

### Simulation ###
# 	gnbsim-simulator-start
aether-ueransim-install: ueransim-install
aether-ueransim-uninstall: ueransim-uninstall 

#include at the end so rules are not overwritten
include $(K8S_ROOT_DIR)/Makefile
include $(GNBSIM_ROOT_DIR)/Makefile
include $(5GC_ROOT_DIR)/Makefile
include $(4GC_ROOT_DIR)/Makefile
include $(AMP_ROOT_DIR)/Makefile
include $(UERANSIM_ROOT_DIR)/Makefile
