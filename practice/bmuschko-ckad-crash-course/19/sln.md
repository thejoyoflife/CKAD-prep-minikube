- `k apply -f pod.yaml`
- The pod is in Running status. `k logs date-recorder` shows that there is an error related to nonexistent file.
- `k exec date-recorder -it -- sh` => failed. because there is no shell available in the container (distroless image).
- There is no way to access the file system of a container from another container in the same pod. We can run an ephemeral container in the pod by sharing the process namespace like below, but the problem can't be solved.
    * `k debug date-recorder --image bash --target debian --share-processes -it` => `target` specifies the container with which the process namespace will be shared so that we can view the process list of that container from the ephemeral container that runs as part of the `debug` command.
- The best way to solve this is to mount a shared volume to the location in the container where the nodejs script is writing information to.