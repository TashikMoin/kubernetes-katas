./helm.sh
helm repo add traefik https://helm.traefik.io/traefik
helm repo update

helm search repo traefik
# To list available charts inside the traefik repository

helm show values traefik/traefik > ./valuesFile.yaml
# This values file will help in custom configuration of traefik if we want to customize anything
# for e.g, 
#   Enabling persistent volume to store https certificates even if the traefik pod dies 
#   (do this for traefik https only)



helm install traefik traefik/traefik --values ./valuesFile.yaml -n traefik --create-namespace
# helm install <chart name> <chart source --> repo/chart> --value <path of the value file> -n <namespace> --create-namespace 
# At this point, a K8s cluster should be up and running before executing this command.


kubectl get all -n traefik
# To list all the pods and traefik service through which we can access traefik.

kubectl apply -f dashboard.yaml

# To enable the dashboard, create an ingress route using dashboard.yaml file and inside the
# match field of the ingressroute yaml, set the value --> external ip of the traefik service
# for e.g,
#   routes:
#     - match: Host(`20.212.168.187`)

# now access the traefik dashboard from your browser using this ip address.