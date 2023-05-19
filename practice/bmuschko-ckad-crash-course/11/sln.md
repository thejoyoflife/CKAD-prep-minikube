- k create ns rq-demo
- kn rq-demo
- k create quota app --hard=pods=2,requests.cpu=2,requests.memory=500Mi
- k describe qutoa app
- k run mypod --image nginx --restart Never --dry-run=client -o yaml > mypod.yaml => edit the file to include the memory resource requests exceeding the quota value e.g. "1Gi", but cpu requests below the value of the resource quota i.e. "0.5".
- k create -f mypod.yaml => should show "forbidden - quota exceeded" type of error message right away.
- Change the pod spec again to request resources within the quota limit i.e. "500Mi", and create the resource again. This time it should succeed.
- k describe quota app
Name:            app
Namespace:       rq-demo
Resource         Used   Hard
--------         ----   ----
pods             1      2
requests.cpu     500m   2
requests.memory  500Mi  500Mi