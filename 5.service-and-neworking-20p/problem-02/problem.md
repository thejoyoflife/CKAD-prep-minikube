- Create the test environment by using `k apply -f env.yml`

- Create a ingress to route traffic . Use `ch5p02subtask1` namespace for your resources.
    - /phone : should go to service phone
        - k create deploy phone --image=ivplay4689/reflect --port=80
        - k expose deploy phone
        - get svc -o wide `10.108.11.96`
        - k $rc 10.108.11.96
    - /tablet : goes to service tablet
        - k create deploy tablet --image=ivplay4689/reflect --port=80
        - k expose deploy tablet
    
    - the hostname name does not matter in this case.
    - k apply -f ch5p02subtask1.yml
    - k get ingress `192.168.49.2` is the IP
    - k get nodes -o wide `192.168.49.2 is the minikube nodes internal ip`
    - in a different terminal run `minikube tunnel` and leave that terminal open.
    - curl localhost/phone
    - curl localhost/tablet

- Create a ingress to route traffic . Use `ch5p02subtask2` namespace for your resources.
    - onlinestore.com/books should go to bookstore service
        - k create deploy bookstore --image=ivplay4689/reflect --port=80
        - k expose deploy bookstore
        - k get svc -o wide `10.97.210.210`
        - k $rc 10.97.210.210
    - onlinestore.com/pens should go to penstore service
        - k create deploy penstore --image=ivplay4689/reflect --port=80
        - k expose deploy penstore
        - k get svc -o wide `10.107.34.105`
        - k $rc 10.107.34.105
    - inventory.com/books should go to bookinventory service
        - k create deploy bookinventory --image=ivplay4689/reflect --port=80
        - k expose deploy bookinventory
        - k get svc -o wide `10.100.141.153`
        - k $rc 10.100.141.153
    - onlinestore.com/pens should go to peninventory service
        - k create deploy peninventory --image=ivplay4689/reflect --port=80
        - k expose deploy peninventory
        - k get svc -o wide `10.100.225.97`
        - k $rc 10.100.225.97
    - k apply -f ch5p02subtask2.yml
    - k get ingress
    ```
    NAME             CLASS   HOSTS                           ADDRESS        PORTS   AGE
    ch5p02subtask2   nginx   onlinestore.com,inventory.com   192.168.49.2   80      34s
    ```
    - `curl onlinestore.com/books` with a host entry ( /etc/hosts) or `curl -H "Host: onlinestore.com" 127.0.0.1/books`
    - curl -H "Host: onlinestore.com" 127.0.0.1/pens
    - curl -H "Host: inventory.com" 127.0.0.1/books
    - curl -H "Host: inventory.com" 127.0.0.1/pens

- The routes socialmedia.com and ecommerceprofile.com is expected to do routing by this rule - 
    - socialmedia.com should go to service socialmediahome
    - picture.socialmedia.com/coverphoto/user/10001 should go to service scoverphoto (prefix /cover	coverphoto/user/10001	No)
    - picture.socialmedia.com/profilepicture/10001 should go to service sprofilepicture (Exact /profilepicture , map profilepicture/10001)

    - any other traffic from the domain or subdomain of socialmedia.com should go to service socialmedia404.
    - picture.ecommerceprofile.com/coverphoto/user/10001 should go to service ecoverphoto (prefix /cover	coverphoto/user/10001	No)
    - any other traffic from the domain or subdomain of ecommerceprofile.com should go to service socialmedia404.
    - However, the routing is not working using the ingress rule created in the `ch5p02subtask3` namespace. The ingress rules are defined in the file `ch5p02subtask3.yml`, fix the file and re-deploy.

- There site bigbangtheory.com routing is expected to work by the ingress rule created in the `ch5p02subtask4` namespace using ch5p02subtask4.yml.
    - /penny : should goes to service penny
    - /sheldon : shouldgoes to service sheldon
    However the configuration is not working as expected and you need to troubleshoot and fix. The ingress rules are defined in the file `ch5p02subtask4.yml`, fix the file and re-deploy.
    
    - k apply -f ch5p02subtask4.yml
    - curl -H "Host: bigbangtheory.com" 127.0.0.1/penny
    - curl -H "Host: bigbangtheory.com" 127.0.0.1/sheldon `Something wrong with this path`
    - curl -H "Host: bigbangtheory.com" 127.0.0.1/unmapped
    - curl 127.0.0.1/unmapped
 