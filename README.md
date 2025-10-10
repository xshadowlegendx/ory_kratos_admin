# OryKratosAdmin

<p>
  <img src="https://coveralls.io/repos/github/xshadowlegendx/ory_kratos_admin/badge.svg?branch=main"/>
  <img src="https://github.com/xshadowlegendx/ory_kratos_admin/actions/workflows/ci.yml/badge.svg"/>
</p>

Ory Kratos admin server alternative

## Kubernetes deployment with Kustomization
```yaml
---
# this is usually generated
# ./ory-kratos-config.yml
apiVersion: v1
kind: Secret
metadata:
  name: ory-kratos-pg
  namespace: default
data:
  username: cG9zdGdyZXM= # postgres
  password: Y2hhbmdlbWU= # changeme
```

```yaml
---
# your kustomization.yml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization

namespace: default

images:
- name: ory-kratos-admin
  newName: ghcr.io/xshadowlegendx/ory_kratos_admin
  newTag: 0.1.1

resources:
# ory kratos admin expected database config
# ensure it is properly provided via secret
- ./ory-kratos-config.yml
# install the ory kratos admin
- https://github.com/xshadowlegendx/ory_kratos_admin.git//k8s?ref=0.1.1

configMapGenerator:
# config used by ory kratos admin
# you can also change the config using
# kustomize patches
# for available config can check .env.example
- name: ory-kratos-admin
  behavior: merge
  literals:
  - DATABASE_NAME=ory_kratos
  - DATABASE_HOST=ory-kratos-pg.default.svc.cluster.local

secretGenerator:
- name: ory-kratos-admin
  literals:
  - SECRET_KEY_BASE=9I9azA5xd1rIlVtS5FGpI+H9D1kni8sWe2KCglmcnq2HKfpavXMkC/720aK33laq
```
