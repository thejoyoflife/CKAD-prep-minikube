- Create the `operator-crd.yaml` file by copying a sample from kubernetes doc (https://kubernetes.io/docs/tasks/extend-kubernetes/custom-resources/custom-resource-definitions/). Change the yaml file as pert the requirement.
- `k create -f operator-crd.yaml`
- Create a custom object for the CRD `operator-obj.yaml`, and apply the file `k apply -f operator-obj.yaml`.
- `k get op` / `k get operators` / `k get operator`