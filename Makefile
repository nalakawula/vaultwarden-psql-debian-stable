NAME = vaultwarden.moe

ifndef VAULTWARDEN_VERSION
    VAULTWARDEN_VERSION = 1.30.5
endif

build: tmp/.vaultwarden-build

purge:
	-docker rmi vaultwarden.moe
	-rm tmp/.vaultwarden-build

tmp/.vaultwarden-build: Dockerfile
	docker build -t $(NAME) \
		--build-arg vaultwarden_version=$(VAULTWARDEN_VERSION) \
		--file Dockerfile ./
	mkdir -p ./tmp
	@touch tmp/.vaultwarden-build

.PHONY: build purge
