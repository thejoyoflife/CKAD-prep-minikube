- k label pod pod-calc id=pod-calc
- k apply -f rs.yaml
- The existing pod will face no downtime and joined by the replicaset seamlessly. Though the pods have different names, the ReplicaSet doesn't care about the name of the pods - it deals with just the labels of the pods and selectors.