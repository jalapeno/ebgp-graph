REGISTRY_NAME?=docker.io/iejalapeno
IMAGE_VERSION?=latest

.PHONY: all ebgp-graph container push clean test

ifdef V
TESTARGS = -v -args -alsologtostderr -v 5
else
TESTARGS =
endif

all: ebgp-graph

ebgp-graph:
	mkdir -p bin
	$(MAKE) -C ./cmd compile-ebgp-graph

ebgp-graph-container: ebgp-graph
	docker build -t $(REGISTRY_NAME)/ebgp-graph:$(IMAGE_VERSION) -f ./build/Dockerfile.ebgp-graph .

push: ebgp-graph-container
	docker push $(REGISTRY_NAME)/ebgp-graph:$(IMAGE_VERSION)

clean:
	rm -rf bin

test:
	GO111MODULE=on go test `go list ./... | grep -v 'vendor'` $(TESTARGS)
	GO111MODULE=on go vet `go list ./... | grep -v vendor`
