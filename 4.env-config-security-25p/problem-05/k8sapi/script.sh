#!/bin/sh
# Point to the internal API server hostname
env
echo "QUERY_PATH = $QUERY_PATH"

APISERVER=https://kubernetes.default.svc

# Path to ServiceAccount token
SERVICEACCOUNT=/var/run/secrets/kubernetes.io/serviceaccount

# Read this Pod's namespace
POD_NAMESPACE=$(cat ${SERVICEACCOUNT}/namespace)

# Read the ServiceAccount bearer token
TOKEN=$(cat ${SERVICEACCOUNT}/token)

# Reference the internal certificate authority (CA)
CACERT=${SERVICEACCOUNT}/ca.crt


API_QUERY_PATH=${APISERVER}/${QUERY_PATH}
echo "API_QUERY_PATH = $API_QUERY_PATH"
# Explore the API with TOKEN
while true
do
   curl -m 2 --cacert ${CACERT} --header "Authorization: Bearer ${TOKEN}" -X GET ${API_QUERY_PATH}
   sleep 10;
done


