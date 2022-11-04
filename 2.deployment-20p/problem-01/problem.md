- Create the test environment by using `k apply -f env.yml`
- Switch to ch2p01

1. Create a Job with an image node which prints node version and also verifies there is a pod created for this job.
2. Get the logs of the job just created
3. Output the yaml file for the Job with the image busybox named busybox which echos “Hello I am from job”
4. Copy the above YAML file to hello-job.yaml file and create the job
5. Verify the job and the associated pod is created and check the logs as well
6. Delete the job we just created
7. Create the same job and make it run 3 times one after one
8. Watch the job that runs 3 times one by one and verify 3 pods are created and delete those after it’s completed
9. Create the same job and make it run 3 times parallel
10. Watch the job that runs 3 times parallelly and verify 10 pods are created and delete those after it’s completed
11. Create a Cronjob with busybox image that run every minute and each job prints date and `hello from kubernetes cluster` message 
12. Verify that CronJob creating a separate job and pods for every minute to run and verify the logs of the pod
13. Delete the CronJob and verify all the associated jobs and pods are also deleted.