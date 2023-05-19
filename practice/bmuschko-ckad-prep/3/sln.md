- `k run adapter --image busybox --restart Never --dry-run=client -o yaml -- sh > adapter.yaml` - change the `adapter.yaml` file according to the description.
- `k apply -f adapter.yaml`
- `k exec adapter -c transformer -- sh`
   * `ls -lt *transformed.txt`
   * `cat <any_of_the_transformed.txt_file>` - to see the output of `du -sh ~` command. 