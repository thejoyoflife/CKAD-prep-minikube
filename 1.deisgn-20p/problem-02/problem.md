1. Run the command `k apply -f env.yml`
2. Switch to `ch1p02` namespace for this lab.
3. Create a pod with labels env=staging and tier=web. Use image nginx and name it pod-ex1
4. There is a pod called podtolabel and add a label to the pod called team: finance, annotate the pod with costcenter: abc123
5. Find all the pods with label az and add a new label called cloud: aws
6. Find all the pods with label prod and annotate them with type: production
7. Find all the pods with label instance=m4large and update them with label instance=c4Large
8. Find all the pods which has a label instance and storage=gp2
9. Find all the pods which has a label storage=gp2 or io3.
10. Find all the pods which has a label instance=t3small and storage=gp2
11. Find all the pods which has a label az=ap-southeast-01, has a label called instance and has label storage=gp2 or io3 and az=ap-southeast-01
12. Find all the pods which has a label instance= c4Large,m4large or t3small AND storage=gp2 or io3
13. Delete instance label from all pods
14. Remove storage label from the pods that has label instance=t3small
15. Read all the annotations of a pod anmed `podtolabel`
16. Annotate all the pods has label storage and annotate them with costly: true
17. Delete costcenter from the pod `podtolabel`