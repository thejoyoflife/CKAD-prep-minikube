- k create secret generic mysec --from-env-file=env-file
- k get secret mysec -o yaml `each entries in the file will be present in the secret as a separate key/value pair `
- k run mypod --image bash --restart Never --image-pull-policy IfNotPresent --dry-run=client -o yaml -- sleep 1d > mypod.yaml
- Change the pod spec to incoporate each of the entries of the previously generated secret as environment variables. `envFrom -> - secretRef -> name`
- k apply -f mypod.yaml
- k exec mypod -- env `verify the entries are present as mentioned in the env-file`