#!/bin/bash

NS=stackradar

helm uninstall stackradar --namespace $NS

# Delete the namespace (and with it the PostgreSQL volume)
kubectl delete namespace $NS
