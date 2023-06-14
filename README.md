# CKAD-minikube
CKAD is comparatively an expensive exam and it requires hands-on problem solving very fast within a `Remote Desktop` environment, and hence, solving practice problems are key to success in this exam. 

The content I used to prepare for the CKAD exam using minikube(`minikube version`).
```
minikube version: v1.30.1
commit: 08896fd1dc362c097c925146c4a0d0dac715ace0
```
## Minikube Setup:
- `minikube delete --all` - to delete all existing clusters/profiles
- `minikube start --nodes 2 --cni "calico" --container-runtime "cri-o" --embed-certs true` - to start a local 2 nodes minikube cluster with container runtime as `cri-o` and `calico` as the `CNI` plugin. It uses the default CPU, Memory, Storage, and VM Driver.
    - `embed-certs` is a convenient option that will enable `kubectl` from a Windows WSL2 distribution to access the Windows Minikube cluster in a smooth manner, otherwise issues can occur because of hard-coded paths to the certificate files are being embedded inside of the KUBECONFIG file (~/.kube/.config). This option essentially emebeds the certificates directly into the KUBECONFIG file.
    - https://projectcalico.docs.tigera.io/getting-started/kubernetes/minikube
    - make sure they are in running state and there is no abnormality in restart count , run command `kubectl get pods -l k8s-app=calico-node -o wide -A -w`
- `minikube addons enable metrics-server` - to enable `metrics-server` add-on - without it "`k top`" / `HorizontalPodAutoscaler` feature won't work.
    - Verify that `metrics-server` addon is enabled `minikube addons list | grep metrics-server`
    -  Verify that `metrics-server` pod is running `kubectl get pods -n kube-system | grep -i metrics-server `
- `minikube addons enable ingress` - to enable ingress addon
- `minikube addons enable ingress-dns` - to easily access services in the cluster via ingress objects.
    - After enabling the `ingress` and `ingress-dns` addons, and adding a "nameserver" entry to host's `/etc/resolv.conf` file with the IP of the minikube primary control plane's IP (`minikube ip`), the services in the kubernetes cluster can be accessed directly by the hostname used in the corresponding ingress object - "`curl hello-world.test`" can be used from host to access the configured service in the cluster.
- In Windows, to access minikube nodes from a WSL2 distribution, we need to enable IPv4 packet forwarding in the network switch the WSL2 VM is connected to. Run the below command fron powershell:
    - `Get-NetIPInterface | where {$_.InterfaceAlias -eq 'vEthernet (WSL)' -or $_.InterfaceAlias -eq 'vEthernet (Default Switch)'} | Set-NetIPInterface -Forwarding Enabled`
- To access minikube nodes over ssh from Windows powershell:
    - `minikube ssh -n <node_name> --native-ssh=false` => without `native-ssh=false` option, the Windows Terminal doesn't seem to work smoothly (e.g. shell command history could not be traversed via up/down arrow key).
### Important Minikube commands
- `minikube start` - to start a minikube cluster
- `minikube stop` - to stop a minikube cluster
- `minikube delete` - to delete  a minikube cluster
- `minikube node list` - to list out the node names and their IPs.
- `minikube profile list` - to list the minikube profiles (VM Driver, CRI Runtime, Primary Control Plane IP/Port, Kuberentes Verison, Cluster Status, Number of Nodes, Current active profile etc.).
- `minikube logs` - to view logs to debug a cluster
- `minikube service list` - to display all `NodePort` (/`LoadBalancer`) type of services and their node URLs. "`minikube service <service_name> --url`" option can be used to only show node URL of a specific service without opening the URL in the default browser.
- `minikube tunnel` - essentially routes traffic to services running in the cluster from the host machine by using the `Cluster IP` of the services itself. E.g. `curl <cluster_ip_of_a_service>` will allow to access the service from the host machine where the `minikube tunnel` is being run.
- `minikube image build` - to build an image from a `Dockerfile` in any of the minikube nodes. 
- `minikube image tag` - to tag an existing image similar to how "`docker tag`" command works.

## Syllabus
[CKAD Syllabus](https://training.linuxfoundation.org/certification/certified-kubernetes-application-developer-ckad/)


## Practice Material:
- https://github.com/dgkanatsios/CKAD-exercises
- https://github.com/bmuschko/ckad-crash-course/tree/master/exercises
- https://github.com/bmuschko/ckad-prep
- https://medium.com/bb-tutorials-and-thoughts/practice-enough-with-these-questions-for-the-ckad-exam-2f42d1228552
- https://codeburst.io/kubernetes-ckad-weekly-challenges-overview-and-tips-7282b36a2681

## Study plan
This study plan is only applicable if you are an absolute k8s begineer like me.
### Courses:
- `https://www.udemy.com/course/learn-kubernetes/` - I started with this because I was an absolute begineer. TechWithNana youtube channel also helped me grasping some of the concepts
- https://www.udemy.com/course/certified-kubernetes-application-developer/ `exam specific preperation`
- https://acloudguru.com/course/certified-kubernetes-application-developer-ckad `exam specific preparation`

### Practice
Here I am sharing a 7 days practice program that I followed.
- `Day 1 - 2` Do all these hands ons in this repository. **DO NOT USE TWO MONITORS TO PRACTICE THESE PROBLEMS, USE JUST THE FIREFOX BROWSER AND A SHELL**
-  `Day 3 - 5`Take the mock exam at `https://killer.sh` - `A must used resource for the exam`
- `Day 6` https://killer.sh/faq .Read the documentation that comes with the mock exam. Consolidation, review your works from day 1 - 5.
- Sit on the real exam. Better to take it on Monday morning localtime. Weekends are a bit rush. 

## Setup
- Setting up the vim. I have practiced these commands daily to memorize them and typing them fast during the exam.
```
syntax enable
set clipboard=unnamed
filetype plugin indent on
set autoindent smartindent
set expandtab
set tabstop=2 softtabstop=2 shiftwidth=2
set number
set hidden
```
- Setting up shortcuts, this is helpful in case if you close the terminal accidentally. Spaces are very important, treat them with caution when typing. The `alias kn` can be found here `https://kubernetes.io/docs/reference/kubectl/cheatsheet/`. Search with keyword `cheat` in the k8s official doc to land on this page.
```bash
# Huge timesaver
alias k=kubectl
# Output of a command in yaml format
export do="--dry-run=client -o yaml"
# To change namespace (or, view the current one) within the current context
alias kn='f() { [[ $1 ]] && kubectl config set-context --current --namespace "$1" || kubectl config view --minify | grep -i namespace | cut -d" " -f6 ; } ; f'
# To change the current context
alias kx='f() { [[ $1 ]] && k config use-context "$1" || k config current-context; } ;f'
# To run a temporary pod using a default/given image, and land into the container's `sh` shell
tmp() {
    local podname="tmp" imagename="busybox";
    if [[ $# = 2 ]]; then
        podname="$1"; imagename="$2";
    elif [[ $# = 1 ]]; then
        imagename="$1";
    fi
    k run "$podname" --image "$imagename" --restart Never --image-pull-policy IfNotPresent --rm -it -- sh;    
}
```
- Here is how you can setup the minikube. 
    
## Tips:
- In doubt use -h flag while using kubectl
- https://kubernetes.io/docs/reference/kubectl/cheatsheet/ - use the `kn` alias to work with namespaces during exam.