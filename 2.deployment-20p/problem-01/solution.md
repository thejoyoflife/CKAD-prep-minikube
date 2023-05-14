- Create the test environment by using `k apply -f env.yml`
- Switch to ch2p01

1. Create a Job with an image node which prints node version and also verifies there is a pod created for this job.
    - k create job node --image=node -- node -v
    - k get jobs
2. Get the logs of the job just created
    - k logs job/node
3. Output the yaml file for the Job with the image busybox named busybox which echos “Hello I am from job”
- k create job busybox --image=busybox -n ch2p01 $do -- echo 'Hello I am from job' 
```
apiVersion: batch/v1
kind: Job
metadata:
  creationTimestamp: null
  name: busybox
  namespace: ch2p01
spec:
  template:
    metadata:
      creationTimestamp: null
    spec:
      containers:
      - command:
        - echo
        - Hello I am from job
        image: busybox
        name: busybox
        resources: {}
      restartPolicy: Never
status: {}
```
4. Copy the above YAML file to hello-job.yaml file and create the job
    - k create job busybox --image=busybox -n ch2p01 $do -- echo 'Hello I am from job' > hello-job.yaml
    - k apply -f hello-job.yaml
5. Verify the job and the associated pod is created and check the logs as well
    - k logs job/busybox
6. Delete the job we just created
    - k delete -f hello-job.yaml 
7. Create the same job and make it run 3 times one after one
    - k create job busybox2 --image=busybox -n ch2p01 $do -- echo 'Hello I am from job' > hello-job-2.yaml
    - k apply -f hello-job-2.yaml 
8. Watch the job that runs 3 times one by one and verify 3 pods are created and delete those after it’s completed
    - k get pods -w
    - k delete job busybox2 node
9. Create the same job and make it run 3 times parallel
    - k create job busybox3 --image=busybox -n ch2p01 $do -- echo 'Hello I am from job' > hello-job-3.yaml
    - k apply -f hello-job-3.yaml 
10. Watch the job that runs 3 times parallelly and verify 10 pods are created and delete those after it’s completed
    - k get pods -w
    - k delete job busybox3
11. Create a Cronjob with busybox image that run every minute and each job prints date and `hello from kubernetes cluster` message 
    - k create cj busybox --image=busybox --schedule="*/1 * * * *" $do -- sh -c "date;echo 'hello from kubernetes cluster'" > cron-1.yml
12. Verify that CronJob creating a separate job and pods for every minute to run and verify the logs of the pod
    - k get jobs -w `wait for 3-4 minutes`
    - k get pods -w `wait for 3-4 minutes`
    - k logs busybox-27792785-wdbql
13. Delete the CronJob and verify all the associated jobs and pods are also deleted.
    - k delete cj busybox