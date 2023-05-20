## Need to practice more on:

### Topics:
- Jsonpath, JQ, Go-Template
- OS Commands/Tools (tar, )
- Helm CLI

### Some specific points:
- Lots of pods are running in qa,alan,test,production namespaces. All of these pods are configured with liveness probe. Please list all pods whose liveness probe are failed in the format of <namespace>/<pod name> per line.
- In the `volumes` section of a Pod, the "configmap" volume is defined like `configMap -> name` whereas the "secret" volume is defined with `secret -> secretName`. Its to be noted that for secret, `secretName` is being used, whereas for configMap, only `name` is used.
- Listing labels and annotations for pods can be done using:
   * `k label pods -l app=v1 --list`
   * `k label pods nginx{1..3} --list`
   * `k annotate pods -l app=v1 --list`
   * `k annotate pods nginx{1..3} --list`
- To make kubectl wait for certain events to occur:
   * `k wait --for=condition=complete jobs/pi --timout 10s`
   * `k wait --for=jsonpath='{.status.phase}'=Running pods -l app=nginx --timeout 15s`

   