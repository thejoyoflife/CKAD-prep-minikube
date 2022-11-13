- kubectl delete pod daybeforeexam404  default404 products tickets unmatched404
- kubectl delete svc daybeforeexam404  default404 products tickets unmatched404

- kubectl run products --image=ivplay4689/reflect --port=80 --expose
- kubectl run tickets --image=ivplay4689/reflect --port=80 --expose
- kubectl run daybeforeexam404 --image=ivplay4689/reflect:404 --port=80 --expose --env=MESSAGE="daybeforeexam404 returned 404"
- kubectl run unmatched404 --image=ivplay4689/reflect:404 --port=80 --expose --env=MESSAGE="unmatched404 returned 404"
- kubectl run default404 --image=ivplay4689/reflect:404 --port=80 --expose --env=MESSAGE="default404 returned 404"
```
curl localhost/products -H "Host: daybeforeexam.com"
{daybeforeexam.com} - {unversioned} - products service says hello from /

curl localhost/tickets -H "Host: daybeforeexam.com"
{daybeforeexam.com} - {unversioned} - tickets service says hello from /

curl localhost/nonsense -H "Host: daybeforeexam.com"
{daybeforeexam.com} - {unversioned} - [daybeforeexam404 returned 404 ==> /]

curl localhost/nonsense -H "Host: nonsense.com"
{nonsense.com} - {unversioned} - [unmatched404 returned 404 ==> /]

After disabling this
  # - http:
  #     paths:
  #     - pathType: Prefix
  #       path: /
  #       backend:
  #         service:
  #           name: unmatched404
  #           port:
  #             number: 80

curl localhost/nonsense -H "Host: nonsense.com"
{nonsense.com} - {unversioned} - [default404 returned 404 ==> /nonsense
```
- when wild card mappig is explictely declared , path mathces with unmatched404, hence the request goes there. When we disable it, no rule matches and the response is handled by default404
- AWSM, i am the king of k8s!