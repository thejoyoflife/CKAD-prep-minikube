- Create the test environment by using `k apply -f env.yml`

- Create a ingress to route traffic . Use `ch5p02subtask1` namespace for your resources.
    - /phone : should go to service phone
        - k create deploy phone --image=ivplay4689/reflect --port=80
        - k expose deploy phone
        - k $rc 10.108.11.96
    - /tablet : goes to service tablet
        - k create deploy tablet --image=ivplay4689/reflect --port=80
        - k expose deploy tablet
    - the hostname name does not matter in this case.
    - k apply -f ch5p02subtask1.yml
    - k get ingress `192.168.49.2` is the IP
    - k get nodes -o wide `192.168.49.2 is the minikube nodes internal ip`
    - minikube tunnel
    - curl localhost/phone
    - curl localhost/tablet

- Create a ingress to route traffic . Use `ch5p02subtask2` namespace for your resources.
    - onlinestore.com/books should go to bookstore service
    - onlinestore.com/pens should go to penstore service
    - inventory.com/books should go to bookinventory service
    - onlinestore.com/pens should go to peninventory service

- The routes socialmedia.com and ecommerceprofile.com is expected to do routing by this rule - 
    - picture.socialmedia.com/coverphoto should go to service scoverphoto (predix /aaa/bb	/aaa/bbb	No)
    - picture.socialmedia.com/profilepicture should go to service sprofilepicture (predix /aaa/bb	/aaa/bbb	No)
    - socialmedia.com should go to service socialmediahome
    - any other traffic from the domain or subdomain of socialmedia.com should go to service socialmedia404.
    - picture.ecommerceprofile.com/coverphoto should go to service ecoverphoto (predix /aaa/bb	/aaa/bbb	No)
    - any other traffic from the domain or subdomain of ecommerceprofile.com should go to service socialmedia404.
However, the routing is not working using the ingress rule created in the `ch5p02subtask3` namespace. The ingress rules are defined in the file `ch5p02subtask3.yml`, fix the file and re-deploy.

- There site bigbangtheory.com routing is expected to work by this rule. The ingress is created in the `ch5p02subtask4` namespace.
    - /penny : should goes to service penny
    - /sheldon : shouldgoes to service sheldon
    However the configuration is not working as expected and you need to troubleshoot and fix. The ingress rules are defined in the file `ch5p02subtask4.yml`, fix the file and re-deploy.

 