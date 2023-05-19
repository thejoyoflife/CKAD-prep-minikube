- k run secured --image nginx --restart Never --dry-run=client -o yaml > secured.yaml => change the pod sepc to include `fsGroup: 3000` under the `securityContext` field.
- k apply -f secured.yaml
- k exec -it secured -- bash
    * ls -ld /data/app => should show the `setgid` bit set, and `3000` as the group owner
    * touch /data/app/logs.txt
    * ls -l /data/app => should show the file is created with permission as `3000` as the group owner.
    * chmod g-s /data/app => removing the `setgid` bit will again allow new files in the directory to be created under "root" group.