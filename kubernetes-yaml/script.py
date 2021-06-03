import os
import subprocess
import json

config = {"APP_NAME": "test1", "POSTGRES_VERSION": "13.3-alpine",
          "DB_NAME": "postgres", "DB_USER": "postgres", "DB_PASS": "postgres", "k8sTemplatesPath": "yaml-templates"}


subprocess.run(["sh", "create-k8s-artifacts.sh", env=config])
