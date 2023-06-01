- k create cm db-config --from-env-file=config.txt
- k get cm db-config -o yaml
- k run backend --image nginx --restart Never --dry-run=client -o yaml > backend.yaml => change the file to include all the config map keys as individual environment variables into the container.
- k apply -f backend.yaml
- k exec backend -- env