### Question 1: Multi-Container Pods
a. (b,c,d) Create a Multi-Container POD with the name of kplabs-multi-container. There should be three containers in the pod. Name the first container should be first-container, 2nd container should be second-container and 3rd container should be third-container. 1st container should be launched from nginx image, second container should be launched from mykplabs/kubernetes:nginx image and third container from busybox image.
- k run kplabs-multi-container --image=nginx --restart Never --image-pull-policy IfNotPresent $do > mcpod.yaml
- vi mcpod.yml
- add the necessary changes. Below is the final version.
- k apply -f mcpod.yaml
```
apiVersion: v1
kind: Pod
metadata:
  labels:
    run: kplabs-multi-container
  name: kplabs-multi-container
spec:
  containers:
  - image: nginx
    imagePullPolicy: IfNotPresent
    name: first-container
  - image: mykplabs/kubernetes:nginx
    imagePullPolicy: IfNotPresent
    name: second-container
  - image: busybox
    imagePullPolicy: IfNotPresent
    name: third-container
    command: ["sleep", "3600"]  
  dnsPolicy: ClusterFirst
  restartPolicy: Never

```
e. Connect to the first-container and run the following command: apt-get update && apt-get install net-tools
- k exec -it kplabs-multi-container -c first-container -- sh -c "apt-get update && apt-get install -y net-tools"

f. Connect to the third-container and identify the ports in which processes are listening. Perform wget command on those ports and check if you can download the HTML page.
- k exec -it kplabs-multi-container -c third-container -- sh
- netstat -l
- The ports are 80 and 9080
- wget -qO- localhost -T 2
- wget -qO- localhost:9080 -T 2

### Question 2: Ambassador Container
- 
```
cat <<EOF > haproxy.cfg
global
    daemon
    maxconn 256

defaults
    mode http
    timeout connect 5000ms
    timeout client 50000ms
    timeout server 50000ms

listen http-in
    bind *:80
    server server1 127.0.0.1:9080 maxconn 32
EOF
```
- k create cm kplabs-ambassador-config --from-file=haproxy.cfg
- 
```
cat <<EOF | k apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: kplabs-ambassador-pod
spec:
  containers:
  - name: legacy
    image: mykplabs/kubernetes:nginx
    imagePullPolicy: IfNotPresent
    ports:
    - name: legacy
      containerPort: 9080  
  - name: ambassador
    image: haproxy:1.7
    imagePullPolicy: IfNotPresent
    volumeMounts:
    - name: config
      mountPath: /usr/local/etc/haproxy
    ports:
    - name: ambassador
      containerPort: 80
  volumes:
  - name: config
    configMap:
      name: kplabs-ambassador-config
EOF
```
- 
```
cat <<EOF | k apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: kplabs-busybox-curl
spec:
  containers:
  - name: curl-container
    image: yauritux/busybox-curl
    command: ['sh', '-c', 'while true; do sleep 3600; done']
EOF
```
- k exec -it kplabs-busybox-curl -- curl -m 2 $(k get pods kplabs-ambassador-pod --template '{{.status.podIP}}')

### Question 3: Adapter Pattern
- 
```
cat <<EOF > fluentd.conf
<source>
  type tail
  format none
  path /var/log/1.log
  pos_file /var/log/1.log.pos
  tag PHP
</source>

<source>
  type tail
  format none
  path /var/log/2.log
  pos_file /var/log/2.log.pos
  tag JAVA
</source>

<match **>
  @type file
  path /var/log/fluent/access
</match>
EOF
```
- k create cm fluentd-config --from-file=fluentd.conf
- 
```
cat <<EOF | k apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: kplabs-adapter-logging
spec:
  containers:
  - name: busybox
    image: busybox
    args:
    - /bin/sh
    - -c
    - >
      i=0;
      while true;
      do
        echo "$i: $(date)" >> /var/log/1.log;
        echo "$(date) INFO $i" >> /var/log/2.log;
        i=$((i+1));
        sleep 1;
      done
    volumeMounts:
    - name: log
      mountPath: /var/log
  - name: fluentd
    image: registry.k8s.io/fluentd-gcp:1.30
    env:
    - name: FLUENTD_ARGS
      value: "-c /etc/fluentd-config/fluentd.conf"    
    volumeMounts:
    - name: log
      mountPath: /var/log 
    - name: fluentd-config
      mountPath: /etc/fluentd-config   
  volumes:
  - name: log
    emptyDir: {}
  - name: fluentd-config
    configMap:
      name: fluentd-config
EOF
```
- k exec -it kplabs-adapter-logging -c fluentd -- bash -c "cat /var/log/fluent/access*"