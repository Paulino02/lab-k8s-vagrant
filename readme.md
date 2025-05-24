# metallb
helm repo add metallb https://metallb.github.io/metallb
helm install metallb metallb/metallb --namespace metal-lb --create-namespace

# nginx
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm install ingress-nginx ingress-nginx/ingress-nginx --namespace ingress-nginx --create-namespace
