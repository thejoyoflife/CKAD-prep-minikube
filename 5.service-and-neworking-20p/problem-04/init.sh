kubectl delete pod daybeforeexam404  default404 products tickets unmatched404 
kubectl delete svc daybeforeexam404  default404 products tickets unmatched404

kubectl run products --image=ivplay4689/reflect --port=80 --expose --env=MESSAGE="products service says" --image-pull-policy='Always'
kubectl run tickets --image=ivplay4689/reflect --port=80 --expose --env=MESSAGE="tickets service says"  --image-pull-policy='Always'
kubectl run daybeforeexam404 --image=ivplay4689/reflect:404 --port=80 --expose --env=MESSAGE="daybeforeexam404 returned 404"  --image-pull-policy='Always'
kubectl run unmatched404 --image=ivplay4689/reflect:404 --port=80 --expose --env=MESSAGE="unmatched404 returned 404"  --image-pull-policy='Always'
kubectl run default404 --image=ivplay4689/reflect:404 --port=80 --expose --env=MESSAGE="default404 returned 404"  --image-pull-policy='Always'