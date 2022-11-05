- k set sa deploy nginx-sa sach4p01
```
deployment.apps/nginx-sa serviceaccount updated
```
- k get deploy nginx-sa  -o yaml | grep 'service'
- k get pod nginx-sa-5688cb6c7c-chxrs -o yaml | grep 'sach4p01'