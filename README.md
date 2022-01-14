# Build kubertates cluster using terraform and deploy simple web app   🌐
using GCP

## terraform resources :

  - vpc 
  - 2 private subnets managment for (VM) && restirected for (cluster)
  - private VM 
  - private cluster 
  - service account 
  - firewall to allow IAP to VM
  - NAT in managment subnet 
  #### Architecture description 
  - cluster dont have accses to egress or ingress
  - only VM can access our cluster 
  - VM access only form IAP 
  - VM cat access internet throw NAT  
  - store app images into GCR that lets cluster to access them 
# Implementation instructions
 -  1- Run terraform code to build infrastructure
 -  2- Configure VM to interact with cluster 
 -  3- Build application images and push them to GRC
 -  4- apply deployment using kubectl
 -  5- create ingress to access our app 

# Run terraform command into terraform Dir
First change project_ID and srvice account 
Then run :
```bash
$ terraform init 
$ terraform plan 
$ terraform apply -auto-approve
```

# configure VM :
1- Connect to VM using console OR from your machine using this command :

```bash
$ gcloud  compute ssh --zone "us-central1-a" "private-vm"  --tunnel-through-iap --project "PROJECT_NAME"
```
2- Copy deployment file into vm 

3- Run the following command to setup enviroment :

```bash
$ sudo apt update
$ sudo apt install kubectl
$ curl -fsSL https://test.docker.com -o test-docker.sh
$ sudo sh test-docker.sh
$ sudo usermod -aG docker ${USER}
$ gcloud auth configure-docker
#restart VM to cofigure changes 
$ gcloud auth login
```

# Build Application  images 
If you want deploy your own application it's up to you OR  [using the Dockerfile that in application dir to buid your custom image](https://github.com/Moatazxz/gcp-gke-cluster-project/tree/main/application)

if you want use this application image i built the image and push it into dockerHub
- use this command to pull application image and Redis  :

```bash
$ docker pull moatazxz/webapp:latest
$ docker pull redis
```
#### push images into GCR

```bash
$ docker pull moatazxz/webapp:latest
$ docker pull redis
$ docker tag moatazxz/webapp:latest gcr.io/PROJECT_NAME/webapp
$ docker tag redis  gcr.io/PROJECT_NAME/redis
$ docker push gcr.io/PROJECT_NAME/webapp
$ docker push gcr.io/PROJECT_NAME/redis
```
# Apply deployment 
First if you will use same deployment file dont forget to change image name in yaml file to your image name  
- connect to your cluster using this command: 
 
```bash
$ gcloud container clusters get-credentials CLUSTER_NAME --zone us-central1-a --project PROJECT_NAME
```

- deploy the application using this command 

```bash
#deploy redis deployment  
$ kubectl apply -f redis-deployment.yaml
# deploy clusterIP service 
$ kubectl apply -f clusterip-service.yaml
#deploy application deployment
$ kubectl apply -f myapp-deployment.yaml
```

# create ingress to access  application externaly
- first  create Node port
 
 
```bash
$ kubectl apply -f naodeport.yaml
```

- then create ingress 

 
```bash
$ kubectl apply -f ingress.yaml
```

- using this command to show ingress external IP 

```bash
$ kubectl get ingress
```
##### copy IP into your browser 

# congratulations your application now UP and Running 

![alt text](https://github.com/Moatazxz/gcp-gke-cluster-project/blob/main/screenshots/browser.png)

# cluster view  

![alt text](https://github.com/Moatazxz/gcp-gke-cluster-project/blob/main/screenshots/cluster2.png)


![alt text](https://github.com/Moatazxz/gcp-gke-cluster-project/blob/main/screenshots/cluster1.png)

# VM terminal view 

![alt text](https://github.com/Moatazxz/gcp-gke-cluster-project/blob/main/screenshots/VMterminal.png)



![alt text](https://github.com/Moatazxz/gcp-gke-cluster-project/blob/main/screenshots/cluster_view.png)

# Ingress view

![alt text](https://github.com/Moatazxz/gcp-gke-cluster-project/blob/main/screenshots/ingress.png)

# cluster noed and vm 

![alt text](https://github.com/Moatazxz/gcp-gke-cluster-project/blob/main/screenshots/VM's.png)

# GCR

![alt text](https://github.com/Moatazxz/gcp-gke-cluster-project/blob/main/screenshots/GCR.png)

# services 

![alt text](https://github.com/Moatazxz/gcp-gke-cluster-project/blob/main/screenshots/services.png)



