HASH := $(shell git log -1 --pretty=oneline | cut -d ' ' -f 1)
SUBMODULES := $(shell find shiny-server/ -mindepth 1 -maxdepth 1 -type d)

bump_metrics_submodule:
	for i in $(SUBMODULES); do cd $$i; git pull --ff-only; cd -;done
	git commit -m 'Bump metrics dashboard submodule' $(SUBMODULES)
	git review

update:
	git pull --ff-only
	git submodule update --init --recursive
ifneq ($(HASH),$(shell git log -1 --pretty=oneline | cut -d ' ' -f 1))
	sudo service shiny-server restart
endif

provision:
	sudo bash -e ./setup.sh


