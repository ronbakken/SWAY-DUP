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

5. Create the MariaDB instance. This is configured for 4Gi storage.

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

