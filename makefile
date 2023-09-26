create: # Create cluster
	kind create cluster --config kubernetes/kind_config.yaml

ingress:
    # Install Ingress Nginx
	kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml
	kubectl wait --namespace ingress-nginx \
	--for=condition=ready pod \
	--selector=app.kubernetes.io/component=controller \
	--timeout=90s

helm-operator:
    # Install Helm Operator
	kubectl create namespace flux --dry-run=client -o yaml | kubectl apply -f -
	helm repo add fluxcd https://charts.fluxcd.io
	helm upgrade -i helm-operator fluxcd/helm-operator \
    --namespace flux \
    --set helm.versions=v3

instal-helmrelease:
	kubectl apply -f kubernetes/helm-release.yamlyaen

build:
	yarn tsc
	yarn build:backend

build-image:
	docker image build . -f packages/backend/Dockerfile --tag backstage:1.0.0
	kind load docker-image backstage:1.0.0 --name backstage

deploy:
	@echo "Deploy"
	kubectl apply -f kubernetes/bs-deployment.yaml
	kubectl apply -f kubernetes/bs-ingress.yaml

all-local:
	$(MAKE) create
	$(MAKE) ingress
	$(MAKE) helm-operator
	$(MAKE) build
	$(MAKE) deploy

helm-install:
	helm repo add backstage https://backstage.github.io/charts
	helm upgrade -i backstage backstage/backstage --namespace backstage --create-namespace -f kubernetes/backstage-values.yaml

helm-uninstall:
	helm uninstall backstage --namespace backstage

all-helm:
	$(MAKE) create
	$(MAKE) ingress
	$(MAKE) helm-install

destroy:
	kind delete cluster --name backstage