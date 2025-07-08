# postgres-cluster

This is my personal Helm chart for deploying PostgreSQL clusters via the CrunchyData PostgreSQL Operator.

It is, for now, drastically simplified for my personal use case, which consists of:

- Scheduling simple PostgreSQL clusters on one or multiple nodes
- Creating simple backups to S3

It is not suited for production-grade setups (yet).