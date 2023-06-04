- Create `adapter.yaml` file as per the requirement.
- `k apply -f adapter.yaml`
- `k exec adapter -c transformer -it -- sh`
    * `watch -n 20 ls -l '*.txt'` => a new file (sometimes more than one ;-)) should appear in every 20 seconds.