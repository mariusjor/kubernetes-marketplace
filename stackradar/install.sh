#!/bin/bash

set -eu

STACK="stackradar"
CHART="oci://ghcr.io/lockdep/helm-charts/stackradar"
CHART_VERSION="0.2.2"
NAMESPACE="stackradar"

# The chart ships public fixture values for its secrets and never generates
# any. Generate them here, once per cluster; a release that already exists
# keeps the values it was installed with. The cluster id is the Civo cluster
# id (a UUID), substituted by the marketplace.
random_hex() {
  head -c 32 /dev/urandom | od -An -tx1 | tr -d ' \n'
}

if helm status "$STACK" --namespace "$NAMESPACE" > /dev/null 2>&1; then
  extra=(--reuse-values)
else
  extra=(
    --set "secrets.internalServiceKey=$(random_hex)"
    --set "secrets.apiKeyEncryptionKey=$(random_hex)"
    --set "secrets.authSecret=$(random_hex)"
    --set "scanner.stackradar.clusterId=${CLUSTER_ID}"
    --set "scanner.stackradar.apiKey=$(random_hex)"
    --set "postgresql.auth.password=$(random_hex)"
  )
fi

# --atomic: a failed first install is rolled back and removed, so a retry
# generates fresh values instead of upgrading a release that never deployed.
helm upgrade "$STACK" "$CHART" \
  --install \
  --atomic \
  --create-namespace \
  --namespace "$NAMESPACE" \
  --version "$CHART_VERSION" \
  --wait \
  --timeout 15m0s \
  "${extra[@]}"
