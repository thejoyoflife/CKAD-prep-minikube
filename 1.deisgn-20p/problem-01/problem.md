- This practice problem is taken from `https://medium.com/bb-tutorials-and-thoughts/practice-enough-with-these-questions-for-the-ckad-exam-2f42d1228552`.
1. Run the command `k apply -f env.yml`
2. Switch to `ch1p01` namespace for this lab.
3. There is a pod running in namespace `ch1p01` named `multic`. Get the names of the containers running inside the pod. Then get the log for each of the containers.
4.  Check the previous logs of the cotnainer `busybox2` of the pod `multic`.
5.  Run command ls in the third cotnainer `busybox2` of the pod `multic`.
6. Show metrics of the `multic` pod containers and puts them into the file.log.
7. Create a Pod named `multic2` with main container busybox and which executes this `while true; do echo ‘Hi I am from Main container’ >> /var/log/index.html; sleep 5; done` and with sidecar container with nginx image which exposes on port 80. Use emptyDir Volume and mount this volume on path /var/log for busybox and on path /usr/share/nginx/html for nginx container. Verify both containers are running.
8. Exec into the `busybox` containers and verify that `/var/log/index.html` exists, then send a http request to `localhost:80` and ensure you get 2xx response. Finally enter into the `nginx` container and find the content in the file `/usr/share/nginx/html`.
