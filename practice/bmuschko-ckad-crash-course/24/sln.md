- `k apply -f setup.yaml`
- Create pod with specific resource requirements in a single command:
    * `k run pod --image nginx --restart Never --image-pull-policy IfNotPresent $do | k set resources -f - --requests=cpu=400m --limits=cpu=1.5 --local=true -o yaml | k apply -f -`