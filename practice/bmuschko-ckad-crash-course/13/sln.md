- k create secret generic db-credentials --from-literal=db-password=passwd
- k run backend --image nginx --restart Never --dry-run=client -o yaml > backend.yaml => change the file to include the secret key as an environment variable.
- k apply -f backend.yaml
- k exec backend -- env | grep -i db => should show the DB_PASSWORD environment variable with the correct value as specified in the secret.