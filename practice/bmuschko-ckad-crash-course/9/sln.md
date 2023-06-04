- Create the pod definition as per the requirement.
- `k apply -f rate-limiter.yaml`
- Test the rate limiting functionality:
    * `k exec rate-limiter -it -- bash` => then run a loop to hit the `business-app` service running on port `8080`. This servie internally calls the ambassador service running on `localhost:8081`. When the ambassador receives too many requests it replies with error messages - `Too many requests ...`.
        * `while sleep 1; do curl -s localhost:8080/test; done` - after few requests become successful, the requests start resulting with the error message.