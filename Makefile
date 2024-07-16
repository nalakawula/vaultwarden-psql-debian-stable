# Default Vaultwarden version if not specified
VAULTWARDEN_VERSION ?= 1.31.0

# Docker image name
IMAGE_NAME = vaultwarden:$(VAULTWARDEN_VERSION)-postgres
CONTAINER_NAME = vaultwarden_build_container

# Build the Docker image
build: tmp/.vaultwarden-build

# Remove the Docker image and build indicator
purge:
	-docker rmi $(IMAGE_NAME)
	-rm -f tmp/.vaultwarden-build

# Copy vaultwarden binary from the container to the host
copy: tmp/.vaultwarden-build
	docker create --name $(CONTAINER_NAME) $(IMAGE_NAME)
	docker cp $(CONTAINER_NAME):/app/target/release/vaultwarden ./vaultwarden-$(VAULTWARDEN_VERSION)-postgres
	docker rm $(CONTAINER_NAME)

# Target to build the Docker image and create the build indicator
# Rebuilds if Dockerfile changes
tmp/.vaultwarden-build: Dockerfile
	docker build -t $(IMAGE_NAME) \
		--build-arg vaultwarden_version=$(VAULTWARDEN_VERSION) \
		-f Dockerfile .
	mkdir -p tmp
	@touch tmp/.vaultwarden-build

# Declare targets that do not represent files
.PHONY: build purge copy
