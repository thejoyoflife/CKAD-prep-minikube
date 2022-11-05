- Create the test environment by using `k apply -f env.yml`

1. Check the log of the pod `service-list`, it's having an error. It's calling a k8s api and it does not have enough permission. All the necessary resources are created in the namespace `ch4p02`. `api-call` serviceaccount  has the necessary permission, take necessary step to fix the problem. The pod is created using the `pod.yml file.

