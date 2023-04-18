IMAGE_REPO=ghcr.io/monax/ci
### Versions for each image
VERSION:=$(shell scripts/version.sh)

export BUILD_DATE:=$(shell date --rfc-3339=seconds)

version:
	@echo $(VERSION)

.PHONY: builder
builder: builder.img builder.push

# pattern rule to build images from this directory
%.img: %/Dockerfile
	docker build --build-arg VERSION=$(VERSION) --build-arg BUILD_DATE="$(BUILD_DATE)" --tag $(IMAGE_REPO)/$*:$(VERSION) $*

# Push image built above
%.push: %/Dockerfile
	docker push $(IMAGE_REPO)/$*:$(VERSION)
