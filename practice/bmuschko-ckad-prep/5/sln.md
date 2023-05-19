### #1
- `k run frontend --image nginx --restart Never --image-pull-policy IfNotPresent --port 80`
- `k run backend --image nginx --restart Never --image-pull-policy IfNotPresent --port 80` 
- `k run database --image nginx --restart Never --image-pull-policy IfNotPresent --port 80` 
- `k label pod/frontend env=prod team=shiny`
- `k label pod/backend env=prod team=legacy app=v1.2.4`
- `k label pod/database env=prod team=storage`
- `k get pods -L env,team,app`
- `k annotate pod frontend 'contact=John Doe' commit=2d3mg3`
- `k annotate pod backend 'contact=Mary Harris'`
- `k get pods -l env=prod -o json | jq '[.items[] | {"name": .metadata.name, "labels": .metadata.labels, "annotations": .metadata.annotations}]'`
- `k label pods -l env=prod --list`
- `k get pods -l 'env=prod,team in (shiny,legacy)'` - `database` pod won't be shown as its in "database" team.
- `k label po/backend env-`
- `k get pods -l 'env=prod,team in (shiny,legacy)'` - `backend` pod won't be listed anymore.
- `k get pods -o yaml | grep -iC 3 annotations:`

### #2
- `k create deploy deploy --image nginx --replicas 3 --dry-run=client -o yaml > deploy.yaml` - then, chage the file to incorate the asked labels.
- `k create -f deploy.yaml`
- `k get deploy deploy` - should show 3 replicas as available.
- `k set image deploy/deploy nginx=nginx:latest` - a separate revision will be created for this image change.
- `k get deploy/deploy -o wide` - `nginx:latest` should be shown under the "IMAGES" column
- Or, `k get pods -l app=v1 -o yaml | grep -i image:` - this should `nginx:latest` for all `image` fields.
- `k scale deploy/deploy --replicas 5` - NB: no revision will be created for scaling the deployment
- `k rollout undo deploy/deploy --to-revision 1` - another revision #3 would be created for this rollback operation.
- `k get deploy/deploy -o wide` - now the deployment should show `nginx` as the image.

### #3
- `k create cj current-date --image bash --schedule '*/1 * * * *' -- sh -c 'echo Current date: $(date)'` - single quote, around the echo command, is really important here; putting a double quote will put a hard-coded timestamp value (the timestamp of the host machine when the create command is run) as the command string of the container which is not intended here.
- `k get jobs -w` - pick a job from the list which is under the `current-date` cronjob.
- `k logs jobs/<job_name>` - will show the timestamp when the job actually ran. NB: `k logs cj/current-date` won't work as its not implemented yet.
- `k delete cj current-date`