IMAGE_REPO=docker.pkg.github.com/monax/ci
### Record versions pushed here
builder_version=2.6.0

export BUILD_DATE:=$(shell date --rfc-3339=seconds)

.PHONY: builder
builder: builder.img builder.push

# pattern rule to build images from this directory
%.img: VERSION=$($*_version)
%.img: %/Dockerfile
	docker build --build-arg VERSION=$(VERSION) --build-arg BUILD_DATE="$(BUILD_DATE)" --tag $(IMAGE_REPO)/$*:$(VERSION) $*

# Push image built above
%.push: VERSION=$($*_version)
%.push: %/Dockerfile
	docker push $(IMAGE_REPO)/$*:$(VERSION)
