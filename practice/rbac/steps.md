- Create a certificate signing request for the user and the group - user is represented by "CN" (Common Name) field of the certificate and the group is represented by "O" (Organization) field.
   * `openssl req -new -newkey rsa:4096 -nodes -keyout shimul.key -out shimul.csr -subj "/CN=shimul/O=rnd"`
- Base64 encode the CSR file (`shimul.csr`) generated above to include it in a CertificateSigningRequest (CSR) kubernetes object.
   * `cat shimul.csr | base64 | tr -d '\n'`
   * Copy the encoded csr.    
- Create a `CertificateSigningRequest` (CSR) k8s object named `shimul-csr` and put the previously copied csr content in the `request` field of the object.
- `k apply -f shimul-csr.yaml` => `k get csr` => the CSR object will be in `Pending` state. Someone needs to approve it.
- `k certificate approve shimul-csr` => Now, the csr object will be approved and a certificate is also issued behind the scene. The certificate is being put into the csr object in base64 encoded format. We need to retrieve the certificate from the csr object's `status.certificate` field.
- `k get csr shimul-csr -o jsonpath='{.status.certificate}' | base64 --decode > shimul.crt`
- The certificate generation process for the user is over by now. We need to retrieve the cluster CA certificate. We can do that from the existing KUBECONFIG file.
- `k config view -o jsonpath='{.clusters[0].cluster.certificate-authority-data}' --raw | base64 --decode > kube-root-ca.crt`
- Now, we need to create a kubecontext file for the user.
- `k config set-cluster $(k config view -o jsonpath='{.clusters[0].name}') --server $(k config view -o jsonpath='{.clusters[0].cluster.server}') --certificate-authority=kube-root-ca.crt --embed-certs=true --kubeconfig shimul-kubeconfig`
- `k config set-credentials shimul --client-certificate=shimul.crt --client-key=shimul.key --embed-certs=true --kubeconfig shimul-kubeconfig`
- `k config set-context shimul --cluster=$(k config view -o jsonpath='{.clusters[0].name}') --user=shimul --namespace=rnd --kubeconfig shimul-kubeconfig`
- Now, the kubecontext file `shimul-kubeconfig` has been prepared and ready to be used.
- `k config use-context shimul --kubeconfig shimul-kubeconfig`
- Now time for testing.
- `k get pods --kubeconfig shimul-kubeconfig` => Error is thrown as because the user/group doesn't have any permission to list the pods in the namespace. But, this still shows that the authentication with the API server is successful.
- Lets create the namespace now. `k create ns rnd`.
- Create a `Role` object specifying all the permissions that should be granted to the `rnd` group.   
- `k apply -f rnd-role.yaml`
- Create a corresponding `RoleBinding` boject for the above role in `rnd` namespace.
- `k apply -f rnd-rolebiding.yaml`
- Now, the `k get pods --kubeconfig shimul-kubeconfig` should successfully execute. Since there is no resource in the `rnd` namespace, nothing is shown.
- Lets create some resources.
- `k create deploy nginx --image nginx --replicas 2 --kubeconfig shimul-kubeconfig`
- `k get pods --kubeconfig shimul-kubeconfig` => this should show the pods for the above created deployment.
- `k get nodes --kubeconfig shimul-kubeconfig` => throw "forbidden" error, as permission to list nodes was not assigned to the group the current user belongs to.