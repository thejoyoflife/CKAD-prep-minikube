* Create pv.yaml for PV and pvc.yaml for PVC as per the requirement.
* `k apply -f pv.yaml -f pvc.yaml`
* Check the PVC is bound to the PV
  * `k get pv,pvc` - the 'STATUS' column should show as 'Bound' for both PV and PVC
* Create pod.yaml file as per the requirement and `k apply -f pod.yaml`.
* Verify the volume mounts: `k exec app -- ls -ld /var/app/config`. Or, by showing the events: `k describe po app | grep -A 10 -i events:`.