

22. Create a deployment called webapp with image nginx with 5 replicas
Get the deployment you just created with labels
Output the yaml file of the deployment you just created
Get the pods of this deployment
Scale the deployment from 5 replicas to 20 replicas and verify
Get the deployment rollout status
Get the replicaset that created with this deployment
Get the yaml of the replicaset and pods of this deployment
Delete the deployment you just created and watch all the pods are also being deleted
Create a deployment of webapp with image nginx:1.17.1 with container port 80 and verify the image version
Update the deployment with the image version 1.17.4 and verify
Check the rollout history and make sure everything is ok after the update
Undo the deployment to the previous version 1.17.1 and verify Image has the previous version
Update the deployment with the image version 1.16.1 and verify the image and also check the rollout history
Update the deployment to the Image 1.17.1 and verify everything is ok
Update the deployment with the wrong image version 1.100 and verify something is wrong with the deployment
Undo the deployment with the previous version and verify everything is Ok
Check the history of the specific revision of that deployment
Pause the rollout of the deployment
Update the deployment with the image version latest and check the history and verify nothing is going on
Resume the rollout of the deployment
Check the rollout history and verify it has the new version
Apply the autoscaling to this deployment with minimum 10 and maximum 20 replicas and target CPU of 85% and verify hpa is created and replicas are increased to 10 from 1
Clean the cluster by deleting deployment and hpa you just created
Create a Job with an image node which prints node version and also verifies there is a pod created for this job
Get the logs of the job just created
Output the yaml file for the Job with the image busybox which echos “Hello I am from job”
Copy the above YAML file to hello-job.yaml file and create the job
Verify the job and the associated pod is created and check the logs as well
Delete the job we just created
Create the same job and make it run 10 times one after one
Watch the job that runs 10 times one by one and verify 10 pods are created and delete those after it’s completed
Create the same job and make it run 10 times parallel
Watch the job that runs 10 times parallelly and verify 10 pods are created and delete those after it’s completed
Create a Cronjob with busybox image that prints date and hello from kubernetes cluster message for every minute
Verify that CronJob creating a separate job and pods for every minute to run and verify the logs of the pod
Delete the CronJob and verify all the associated jobs and pods are also deleted.