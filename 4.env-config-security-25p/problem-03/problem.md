- Create the test environment by using `k apply -f env.yml`
- There is already a CRD named `k get crd operators.stable.example.com` created, you can find it by the command  `k get crd operators.stable.example.com`. 

1. Create custom object from the CRD. You can use any arbitary value for the spec of the object.