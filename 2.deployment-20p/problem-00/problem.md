- Create the test environment by using `k apply -f env.yml`
- Switch to ch2p00

1. Create a deployment called `webapp` with image `nginx` with 2 replicas
2. Get the deployment you just created with labels
3. Output the yaml file of the deployment you just created
4. Get the pods of this deployment
5. Scale the deployment from 2 replicas to 3 replicas and verify
6. Get the deployment rollout status
7. Get the replicaset that created with this deployment
8. Get the yaml of the replicaset and pods of this deployment
9. Delete the deployment you just created and watch all the pods are also being deleted
10. Create a deployment of webapp with image nginx:1.17.1 with container port 80 and verify the image version
11. Update the deployment with the image version 1.17.4 and verify
12. Check the rollout history and make sure everything is ok after the update
13. Update the deployment with the image version 1.16.1 and verify the image and also check the rollout history
14. Update the deployment with the wrong image version 1.100 and verify something is wrong with the deployment.
15. Undo the deployment with the previous version and verify everything is Ok
16. Check the history of the specific revision of that deployment
17. Pause the rollout of the deployment
18. Update the deployment with the image  nginx:latest and check the history and verify there is no new revision history.    
19. Resume the rollout of the deployment
20. Check the rollout history and verify it has the new version
21. Apply the autoscaling to this deployment with minimum 2 and maximum 3 replicas and target CPU of 85% and verify hpa is created and replicas are increased to 2 from 1


