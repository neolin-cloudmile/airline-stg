# airline-stg
Including, GKE, Cloud Memorystore for Redis, Cloud SQL

## Version
Terraform v0.12.2<br />
+ provider.google v2.11.0<br />

## Deployment
Step.1 Enable "API & Services": Kubernetes Engine API, Cloud DNS API, Cloud Endpoints, Cloud Memorystore for Redis API,Service Networking API<br />

Step.2 Create VPC, secondary IP of subnet for Pod, Services, Firewall Rules<br />

Step.3 Create Bastionhost<br />

Step.4 Create GKE cluster<br />

Setting up a private cluster<br />
https://cloud.google.com/kubernetes-engine/docs/how-to/private-clusters<br />
Createing a VPC-native cluster<br />
https://cloud.google.com/kubernetes-engine/docs/how-to/alias-ips<br />

Step.5 Create Memorystore for Redis<br />

Creating and managing Redis instances<br />
https://cloud.google.com/memorystore/docs/redis/creating-managing-instances<br />

Step.6 Connecting a Redis instances from a Kubernetes Engine Closuter<br />

https://cloud.google.com/memorystore/docs/redis/connect-redis-instance-gke<br />

Step7.Create Cloud SQL for MySQL<br />

Cloud SQL - Doc - MySQL - Configuring private IP connectivity<br />
https://cloud.google.com/sql/docs/mysql/configure-private-ip<br />
Cloud SQL - Doc - MySQL - Overview of backups<br />
https://cloud.google.com/sql/docs/mysql/backup-recovery/backups<br />
Cloud SQL - Doc - MySQL - Configuring external replicas<br />
https://cloud.google.com/sql/docs/mysql/replication/configure-external-replica<br />

Step8. Connecting from Google Kubernetes Engine<br />

Cloud SQL - Doc - MySQL - Connecting from Google Kubernetes Enginer<br />
https://cloud.google.com/sql/docs/mysql/connect-kubernetes-engine

Step9.Quickstart for using the proxy for local testing<br />

Cloud SQL - Doc - MySQL - Quickstart for using the proxy for local testing<br />
https://cloud.google.com/sql/docs/mysql/quickstart-proxy-test<br />

