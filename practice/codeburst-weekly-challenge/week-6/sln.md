- k exec -it deploy/nginx-deployment -- bash
  1. nc -zv -w 2 google.com 80
  2. nc -zv -w 2 api-service 3333
- k exec -it deploy/api-deployment -- sh
  1. wget -qSO /dev/null www.google.com -T 2
  2. nc -zv -w 2 api-service 3333
- k apply -f netpol1.yaml -f netpol2.yaml
- Verify the policies:
  1. k exec -it deploy/nginx-deployment -- bash
     1. nc -zv -w 2 api-service 3333 - `it should succeed`
     2. nc -zv -w 2 google.com 443 - `it should timed out even though the DNS resolutions should succeed.`
  2. k exec -it deploy/api-deployment -- sh
     1. nc -zv -w 2 api-service 3333 - `it should be timed out, but DNS resolution should succeed.`
     2. nc -zv -w 2 google.com 443 - `it should succeed completely`
     3. nc -zv -w 2 google.com 80 - `it should be timed out, but DNS resolution should succeed.`
     4. nc -zv -w 2 facebook.com 443 - `it should be timed out, but DNS resolution should succeed.`