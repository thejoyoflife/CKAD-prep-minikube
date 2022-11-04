- Create the test environment by using `k apply -f env.yml`
- Switch to ch2p00

1. Create a deployment called `webapp` with image `nginx` with 2 replicas
    - k create deploy webapp --image=nginx --replicas=2
    - get deploy
2. Get the deployment you just created with labels
    - k get deploy --show-labels
3. Output the yaml file of the deployment you just created
    - k get deploy webapp -o yaml
4. Get the pods of this deployment
    - k get deploy webapp --show-labels `get the labels`
    - k get pods -l=app=webapp `use it to search pods`
5. Scale the deployment from 2 replicas to 3 replicas and verify
    - k scale deploy webapp --replicas=3
6. Get the deployment rollout status
    - k rollout status deploy webapp
7. Get the replicaset that created with this deployment
    - k get rs -l=app=webapp
8. Get the yaml of the replicaset and pods of this deployment
    - k get rs -l=app=webapp -o yaml
9. Delete the deployment you just created and watch all the pods are also being deleted
    - k delete deploy webapp
10. Create a deployment of webapp with image nginx:1.17.1 with container port 80 and verify the image version
    - k create deploy webapp --image=nginx:1.17.1 --port=80
11. Update the deployment with the image version 1.17.4 and verify
    - k describe deploy | grep 'Image:'
    ```
     Image:        nginx:1.17.1
    ```
12. Check the rollout history and make sure everything is ok after the update
    - k rollout status deploy webapp
13. Update the deployment with the image version 1.16.1 and verify the image and also check the rollout history
    - k set image deploy webapp nginx=nginx:1.16.1
    - k rollout status deploy webapp
14. Update the deployment with the wrong image version 1.100 and verify something is wrong with the deployment.
  - k set image deploy webapp nginx=nginx:1.100
  - k rollout status deploy webapp `it should block(hang)`
  - k get rs -l=app=webapp
  - k get rs -l=app=webapp --sort-by=.metadata.creationTimestamp `The last row is the latest one, it should have desired=1,current=1, ready=1`
15. Undo the deployment with the previous version and verify everything is Ok
    - k rollout undo deploy webapp
    - k rollout status deploy webapp
    - k describe deploy webapp |  grep 'Image:' `It should show the last version nginx:1.16.1`
    ```
        Image:        nginx:1.16.1
    ```
16. Check the history of the specific revision of that deployment
    - k rollout history deploy webapp
    - k rollout history deploy webapp --revision=3
17. Pause the rollout of the deployment
    - k rollout pause deploy webapp
18. Update the deployment with the image  nginx:latest and check the history and verify there is no new revision history.
    - k set image deploy webapp nginx=nginx:latest
    - k rollout history deploy webapp
    ```
    REVISION  CHANGE-CAUSE
    1         <none>
    3         <none>
    4         <none>
    ```
    -  k describe deploy webapp | grep 'Image:' - `It's showing the latest nginx image though, very misleading`
    ```
        Image:        nginx:latest
    ```
    - k describe pod webapp-6bc856f659-qpb7n | grep 'Image:' - `The pod running is still using the old image nginx:1.16.1 which is expected`
        ```
        Image:          nginx:1.16.1
        ```
    
19. Resume the rollout of the deployment
    - k rollout resume deploy webapp
    - k rollout history deploy webapp
    ```
    REVISION  CHANGE-CAUSE
    1         <none>
    3         <none>
    4         <none>
    5         <none>
20. Check the rollout history and verify it has the new version
    - k describe pod webapp-747fb4b77-jfrhb  | grep 'Image:' - `It should show nginx:latest now`
    ```
    ```
        Image:          nginx:latest
    ```
21. Apply the autoscaling to this deployment with minimum 2 and maximum 3 replicas and target CPU of 85% and verify hpa is created and replicas are increased to 2 from 1
    - kubectl autoscale deployment webapp --min=2 --max=3 --cpu-percent=85
    - k get hpa
    - k get pods
    ```
    NAME                     READY   STATUS    RESTARTS   AGE
    webapp-747fb4b77-bnhrl   1/1     Running   0          10s
    webapp-747fb4b77-jfrhb   1/1     Running   0          3m57s
    ```


