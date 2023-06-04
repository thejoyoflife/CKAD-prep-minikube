- `k apply -f configmap.yaml`
- `k apply -f deployment.yaml` => there are errors in the file that need to be fixed according to latest version (1.26) of Kubernetes.
    * Change the `apiVersion` from `apps/v1beta2` to `apps/v1`.
    * `selector` is a mandatory field for a deployment. Add the field and also make sure the pod template labels match with this `selector` labels.
    * Save the changes in a new `deployment-new.yaml` file.
- `k apply -f deployment-new.yaml` => this should succeed now.    
    