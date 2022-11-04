- This practice problem is taken from `https://medium.com/bb-tutorials-and-thoughts/practice-enough-with-these-questions-for-the-ckad-exam-2f42d1228552`.
1. Run the command `k apply -f env.yml`
2. Switch to `ch1p01` namespace for this lab.
    -  kn ch1p01
3. There is a pod running in namespace `ch1p01` named `multic`. Get the names of the containers running inside the pod. Then get the log for each of the containers.
    - k describe pod multic `busybox1,busybox2,busybox3`
    - k logs multic -c busybox1
    - k logs multic -c busybox2
    - k logs multic -c busybox3
4.  Check the previous logs of the cotnainer `busybox2` of the pod `multic`.
    - k logs multic -c busybox3 -p
5.  Run command ls in the third cotnainer `busybox2` of the pod `multic`.
    - k exec multic -c busybox2 -it -- ls
6. Show metrics of the `multic` pod containers and puts them into the file.log.
    - k top pod multic --containers > file.log
7. Create a Pod named `multic2` with main container busybox and which executes this `while true; do echo ‘Hi I am from Main container’ >> /var/log/index.html; sleep 5; done` and with sidecar container with nginx image which exposes on port 80. Use emptyDir Volume and mount this volume on path /var/log for busybox and on path /usr/share/nginx/html for nginx container. Verify both containers are running.
    - k run multic2 --image=busybox $do  -- sh -c "while true; do echo 'Hello at $date' >> /var/log/index.html; sleep 5; done" > sol.yaml
    - vi sol.yml
    - add the necessary changes. Here is the final version.
    - k get pods `READY column should have 2/2, restart column should have 0`

```
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: multic2
  name: multic2
spec:
  containers:
  - args:
    - sh
    - -c
    - while true; do dt=$(date);echo "Hello at $dt" > /var/log/index.html; sleep 5; done
    image: busybox
    name: busybox
    resources: {}
    volumeMounts:
    - mountPath: /var/log
      name: web
  - name: nginx
    image: nginx
    volumeMounts:
    - mountPath: /usr/share/nginx/html
      name: web
    ports:
      - name: web-port
        containerPort: 80

  dnsPolicy: ClusterFirst
  restartPolicy: Always
  volumes:
  - name: web
    emptyDir: {}
status: {}

```
8. Exec into the `busybox` containers and verify that `/var/log/index.html` exists, then send a http request to `localhost:80` and ensure you get 2xx response. Finally enter into the `nginx` container and find the content in the file `/usr/share/nginx/html`.
    - k exec multic2 -c busybox -it -- cat /var/log/index.html
    - k exec multic2 -c busybox -it -- wget -O- http://localhost -T 2