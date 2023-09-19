create: # Create cluster
	kind create cluster --config kubernetes/kind_config.yaml

build:
	yarn build:backend
	docker image build . -f packages/backend/Dockerfile --tag backstage:1.0.0
	kind load docker-image backstage:1.0.0

deploy:
	kubectl apply -f kubernetes/deployment.yaml


all:
	$(MAKE) create

destroy:
	kind delete cluster --name backstage