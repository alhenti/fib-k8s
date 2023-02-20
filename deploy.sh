#!/bin/bash
 
docker build -t talhenti/fib-client-prod:latest -t talhenti/fib-client-prod:$SHA -f ./client/Dockerfile ./client
docker build -t talhenti/fib-server-prod:latest -t talhenti/fib-server-prod:$SHA -f ./server/Dockerfile ./server
docker build -t talhenti/fib-worker-prod:latest -t talhenti/fib-worker-prod:$SHA -f ./worker/Dockerfile ./worker

docker push talhenti/fib-client-prod:latest
docker push talhenti/fib-client-prod:$SHA

docker push talhenti/fib-server-prod:latest
docker push talhenti/fib-server-prod:$SHA

docker push talhenti/fib-worker-prod:latest
docker push talhenti/fib-worker-prod:$SHA

kubectl apply -f k8s
kubectl set image deployments/server-deployment server=talhenti/fib-server-prod:$SHA
kubectl set image deployments/client-deployment client=talhenti/fib-client-prod:$SHA
kubectl set image deployments/worker-deployment worker=talhenti/fib-worker-prod:$SHA