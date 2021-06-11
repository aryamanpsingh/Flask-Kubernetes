import os
import subprocess

config = {"APP_NAME": "test4", 'NAMESPACE': "test4-ns", "POSTGRES_VERSION": "13.2",
          "DB_USER": "postgres", "DB_PASS": "postgres", "k8sTemplatesPath": "yaml-templates", "PV_DOMAIN": "migrated.kube8r.com",
          "FILE_SYSTEM_ID": "fs-bad8ce39", "NFS_SERVER": "fs-bad8ce39.efs.us-east-1.amazonaws.com", "AWS_REGION": "us-east-1"}


subprocess.run(["sh", "create-k8s-artifacts.sh"], env=config)
