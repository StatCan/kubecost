#!/bin/bash

envsubst < policy/secret.tmpl > policy/secret.txt

export KUBECOST_OIDC_CLIENT="${KUBECOST_OIDC_CLIENT:=XXXXX-XXXXX-XXXXX}"
export KUBECOST_OIDC_SECRET="${KUBECOST_OIDC_SECRET:=XXXXX-XXXXX-XXXXX}"
export KUBECOST_OIDC_DISCOVERY="${KUBECOST_OIDC_DISCOVERY:=XXXXX-XXXXX-XXXXX}"
export KUBECOST_ADMIN_POLICY_GROUP="${KUBECOST_ADMIN_POLICY_GROUP:=XXXXX-XXXXX-XXXXX}"
export KUBECOST_TENANT1_POLICY_GROUP="${KUBECOST_TENANT1_POLICY_GROUP:=XXXXX-XXXXX-XXXXX}"
export KUBECOST_TENANT1_DOMAIN_NAME="${KUBECOST_TENANT1_DOMAIN_NAME:=default.example.ca}"

for patch in policy/patch-oidc*; do
  yq w -i $patch '[0].value' ${KUBECOST_OIDC_CLIENT}
  yq w -i $patch '[2].value' ${KUBECOST_OIDC_DISCOVERY}
done

for patch in policy/patch-policy*; do
  yq w -i $patch '[0].value' "https://${KUBECOST_TENANT1_DOMAIN_NAME}"
  yq w -i $patch '[1].value' ${KUBECOST_ADMIN_POLICY_GROUP}
  yq w -i $patch '[2].value' ${KUBECOST_TENANT1_POLICY_GROUP}
done
