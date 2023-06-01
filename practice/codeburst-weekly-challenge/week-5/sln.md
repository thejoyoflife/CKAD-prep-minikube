- k create secret generic mysecret --from-literal=password=12345678 --dry-run=client -o yaml > secret1.yaml
- k apply -f secret1.yaml
- k run pod1 --image bash --dry-run=client -o yaml -- sleep infinity > pod1.yaml
- Change the pod1.yaml file to incorporate a volume based on the secret, and mount the volume in the bash container.
- k apply -f pod1.yaml
- k exec pod1 -- ls /tmp/secret1 `will show a password file`
- k exec pod1 -- cat /tmp/secret1/password `will show the actual password i.e. 12345678`
- mkdir drinks; echo ipa > drinks/beer; echo red > drinks/wine; echo sparkling > drinks/water
- k create cm mycm --from-file=drinks
- k get cm mycm -o yaml
- Edit pod1.yaml file to introduce environment variables based on the secret.
- k apply -f pod1.yaml --force --grace-period=0
- k exec pod1 -- env | grep -A1 -E 'wine|beer|water'