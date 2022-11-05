- Run the command `k apply -f env.yml`

A web application requires a specific version of redis to be used as a cache. 

## Part 01
Create a pod with the following characteristics, and leave it running when complete: 
- The pod must run in the `ch1p00` namespace. The namespace has already been created.
- The name of the pod should be `cache`
- Use the official `redis` image with the `7.0.5` tag 
- Expose port `6379`
