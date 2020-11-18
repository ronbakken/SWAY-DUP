# Kubernetes Development configuration

This folder contains the configuration files required to quickly set up a development or testing environment on Kubernetes.

You will need `kubectl` installed. See https://kubernetes.io/docs/tasks/tools/install-kubectl/#install-kubectl

## Follow these steps

1. Create a new Kubernetes cluster on DigitalOcean. 3 nodes of $20 each should be fine.
2. Download the configuration file. Store it somewhere safe.
3. Set the configuration file as current.

```
set KUBECONFIG=X:\projects_work_2018\inf\laevatein-kubeconfig.yaml
kubectl get nodes
```
```
export KUBECONFIG=/home/kaetemi/k8s/laevatein-kubeconfig.yaml
kubectl get nodes
```

4. Set secret values for the database connection. These will need to match what's in the server config.

```
kubectl create secret generic inf-mariadb-root-pass --from-literal=password=04KWKM2u6bXUj9N9
kubectl create secret generic inf-mariadb-user-pass --from-literal=password=veJxEkenwr7mmC2o
```

5. Create the MariaDB instance. This is configured for 4 GiB storage.

```
kubectl apply -f mariadb.yaml
kubectl get pods
kubectl get services
```

This should start running eventually.

```
NAME                           READY   STATUS    RESTARTS   AGE
inf-mariadb-85d98bd689-84z2d   1/1     Running   0          41s
```

6. Install a phpMyAdmin instance.

```
kubectl apply -f phpmyadmin.yaml
kubectl get pods
kubectl port-forward deployment/inf-phpmyadmin 8080:80
```

7. Head over to http://localhost:8080, select the inf database, and import inf.sql. Then Ctrl+C close the fowarding.
8. Launch an Elasticsearch cluster. The configuration launches two nodes, with 20 GiB storage each. They may take a while to launch.

```
kubectl apply -f elasticsearch.yaml
kubectl get pods
kubectl logs inf-elasticsearch-0
```
```
NAME                              READY   STATUS    RESTARTS   AGE
inf-elasticsearch-0               1/1     Running   0          3m5s
inf-elasticsearch-1               1/1     Running   0          108s
inf-mariadb-85d98bd689-84z2d      1/1     Running   0          25m
inf-phpmyadmin-5f4999db4d-2t5gr   1/1     Running   0          20m
```

9. Add a Kibana instance to manage the Elasticsearch cluster.

```
kubectl apply -f kibana.yaml
kubectl get pods
kubectl port-forward deployment/inf-kibana 5601:5601
```

10. Hop on to http://localhost:5601/, and under Dev Tools enter the `PUT ... "mappings" ...` queries from `inf_common/protobuf/data_elasticsearch_.....txt` to configure the search indices. Close the forwarding using Ctrl+C in the command line.
11. Add the read-only credentials for the private Docker repositories to the Kubernetes cluster.

```
kubectl create secret docker-registry inf-registrykey \
  --docker-server=https://index.docker.io/v1/ \
  --docker-username=infbot \
  --docker-password=WajPqob24eItmmCK \
  --docker-email=infmarketplaceapp@gmail.com
```

12. Add the API service.

```
kubectl apply -f inf_server_api.yaml
kubectl get pods
kubectl describe pod inf-server-api-6c5bc746b7-x5hkq
kubectl logs inf-server-api-6c5bc746b7-x5hkq
```

13. Add a loadbalancer to allow incoming traffic.

```
kubectl apply -f loadbalancer.yaml
```

14. Further configure the load balancer on DigitalOcean manually to use a domain name and use Let's Encrypt certificates automatically. Don't mind the target port in the web interface, it's weird.