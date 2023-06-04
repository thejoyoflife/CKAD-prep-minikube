# CKAD-minikube
CKAD is comparatively an expensive exam and it requires hands-on problem solving very fast within a `Remote Desktop` environment, and hence, solving practice problems are key to success in this exam. 

The content I used to prepare for the CKAD exam using minikube(`minikube version`).
```
minikube version: v1.30.1
commit: 08896fd1dc362c097c925146c4a0d0dac715ace0
```

## Syllabus
[CKAD Syllabus](https://training.linuxfoundation.org/certification/certified-kubernetes-application-developer-ckad/)


# Practice Material:
- https://github.com/dgkanatsios/CKAD-exercises
- https://github.com/bmuschko/ckad-crash-course/tree/master/exercises
- https://github.com/bmuschko/ckad-prep
- https://medium.com/bb-tutorials-and-thoughts/practice-enough-with-these-questions-for-the-ckad-exam-2f42d1228552
- https://codeburst.io/kubernetes-ckad-weekly-challenges-overview-and-tips-7282b36a2681

**I am ever grateful to the authors of these contents who have done tremendous job to provide insighful practice problems for doing hands-on to prepare for the CKAD exam. In this repo, I have borrowed ideas from all those practice problems.**

**Some of the practice problems might seem redundant, so that it it reinforeces your learing, makes you fluent with using the commnads and documentation before the exam.**

# Study plan
This study plan is only applicable if you are an absolute k8s begineer like me.
## Courses:
- `https://www.udemy.com/course/learn-kubernetes/` - I started with this because I was an absolute begineer. TechWithNana youtube channel also helped me grasping some of the concepts
- https://www.udemy.com/course/certified-kubernetes-application-developer/ `exam specific preperation`
- https://acloudguru.com/course/certified-kubernetes-application-developer-ckad `exam specific preparation`

## Practice
Here I am sharing a 7 days practice program that I followed.
- `Day 1 - 2` Do all these hands ons in this repository. **DO NOT USE TWO MONITORS TO PRACTICE THESE PROBLEMS, USE JUST THE FIREFOX BROWSER AND A SHELL**
-  `Day 3 - 5`Take the mock exam at `https://killer.sh` - `A must used resource for the exam`
- `Day 6` https://killer.sh/faq .Read the documentation that comes with the mock exam. Consolidation, review your works from day 1 - 5.
- Sit on the real exam. Better to take it on Monday morning localtime. Weekends are a bit rush. 

# Setup
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
    - `minikube delete --all`
    - `minikube start --nodes 2 --cni "calico" --container-runtime "cri-o" --embed-certs true`
        - `embed-certs` is a convenient option that will enable `kubectl` from a Windows WSL2 distribution to access the Windows Minikube cluster in a smooth manner, otherwise issues can occur because of hard-coded paths to the certificate files are being embedded inside of the KUBECONFIG file (~/.kube/.config). This option essentially emebeds the certificates directly into the KUBECONFIG file.
        - https://projectcalico.docs.tigera.io/getting-started/kubernetes/minikube
        - make sure they are in running state and there is no abnormality in restart count , run command `kubectl get pods -l k8s-app=calico-node -o wide -A -w`
    - `minikube addons enable metrics-server`
        - Verify that 'metrics-server' addon is enabled `minikube addons list | grep metrics-server`
        -  Verify that 'metrics-server' pod is running `kubectl get pods --namespace kube-system | grep metrics-server `
    - `minikube addons enable ingress`
    - `minikube addons enable ingress-dns`
    - `minikube tunnel` - this essentially allows services (clusterip,nodeport,loadbalancer) to be accessible through their ClusterIPs from the host machine. 
        - keep this running in the terminal.
    - For Windows, to access minikube nodes from WSL2 distribution, we need to enable IPv4 packet forwarding. Run the below command fron powershell:
        - `Get-NetIPInterface | where {$_.InterfaceAlias -eq 'vEthernet (WSL)' -or $_.InterfaceAlias -eq 'vEthernet (Default Switch)'} | Set-NetIPInterface -Forwarding Enabled`
    - To access minikube nodes over ssh from Windows powershell:
        - `minikube ssh -n <node_name> --native-ssh=false` => without `native-ssh=false` option, the terminal doesn't work smoothly (e.g. shell command history can not be traversed via up/down arrow key).
# Tips:
- In doubt use -h flag while using kubectl
- https://kubernetes.io/docs/reference/kubectl/cheatsheet/ - use the `kn` alias to work with namespaces during exam.