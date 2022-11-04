1. Create a deployment called webapp with image nginx with 5 replicas
2. Get the deployment you just created with labels
3. Output the yaml file of the deployment you just created
4. Get the pods of this deployment
5. Scale the deployment from 5 replicas to 20 replicas and verify
6. Get the deployment rollout status
7. Get the replicaset that created with this deployment
8. Get the yaml of the replicaset and pods of this deployment
9. Delete the deployment you just created and watch all the pods are also being deleted
10. Create a deployment of webapp with image nginx:1.17.1 with container port 80 and verify the image version
11. Update the deployment with the image version 1.17.4 and verify
12. Check the rollout history and make sure everything is ok after the update
13. Undo the deployment to the previous version 1.17.1 and verify Image has the previous version
14. Update the deployment with the image version 1.16.1 and verify the image and also check the rollout history
15. Update the deployment to the Image 1.17.1 and verify everything is ok
16. Update the deployment with the wrong image version 1.100 and verify something is wrong with the deployment
17. Undo the deployment with the previous version and verify everything is Ok
18. Check the history of the specific revision of that deployment
19. Pause the rollout of the deployment
20. Update the deployment with the image version latest and check the history and verify nothing is going on
21. Resume the rollout of the deployment
22. Check the rollout history and verify it has the new version
23. Apply the autoscaling to this deployment with minimum 10 and maximum 20 replicas and target CPU of 85% and verify hpa is created and replicas are increased to 10 from 1
24. Clean the cluster by deleting deployment and hpa you just created

