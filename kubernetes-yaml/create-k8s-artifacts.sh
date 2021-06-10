cp $k8sTemplatesPath/postgres-configmap.yaml .
cp $k8sTemplatesPath/postgres-sset.yaml .
cp $k8sTemplatesPath/postgres-service.yaml .

cp $k8sTemplatesPath/efs-pv-provisioner.yaml .
cp $k8sTemplatesPath/postgres-sset-rbac.yaml .

cp $k8sTemplatesPath/efs-pv-configmap.yaml .
cp $k8sTemplatesPath/efs-storageclass.yaml .
cp $k8sTemplatesPath/efs-pv-rbac.yaml .

echo "Namespace: $NAMESPACE"
export KUBECONFIG="/home/ec2-user/.kube/config"

echo "Creating pv config map"
sed -i "s/###NAMESPACE###/$NAMESPACE/g" efs-pv-configmap.yaml
sed -i "s/###FILE_SYSTEM_ID###/$FILE_SYSTEM_ID/g" efs-pv-configmap.yaml
sed -i "s/###AWS_REGION###/$AWS_REGION/g" efs-pv-configmap.yaml
sed -i "s/###PV_DOMAIN###/$PV_DOMAIN/g" efs-pv-configmap.yaml

kubectl apply -f efs-pv-configmap.yaml

echo "Creating pv rbac"
sed -i "s/###NAMESPACE###/$NAMESPACE/g" efs-pv-rbac.yaml

kubectl apply -f efs-pv-rbac.yaml

echo "Creating pv storage class"
sed -i "s/###APP_NAME###/$APP_NAME/g" efs-storageclass.yaml
sed -i "s/###PV_DOMAIN###/$PV_DOMAIN/g" efs-storageclass.yaml

kubectl apply -f efs-storageclass.yaml

echo "Creating pv provisioner"
sed -i "s/###APP_NAME###/$APP_NAME/g" efs-pv-provisioner.yaml
sed -i "s/###NAMESPACE###/$NAMESPACE/g" efs-pv-provisioner.yaml
sed -i "s/###NFS_SERVER###/$NFS_SERVER/g" efs-pv-provisioner.yaml

kubectl apply -f efs-pv-provisioner.yaml


: '
echo "Creating persistent volume"
kubectl apply -f postgres-pv.yaml
echo "Creating persistent volume claim"
kubectl apply -f postgres-pvclaim.yaml
'
echo "Creating config map"
sed -i "s/###NAMESPACE###/$NAMESPACE/g" postgres-configmap.yaml
sed -i "s/###DB_NAME###/$DB_NAME/g" postgres-configmap.yaml
sed -i "s/###DB_USER###/$DB_USER/g" postgres-configmap.yaml
sed -i "s/###DB_PASS###/$DB_PASS/g" postgres-configmap.yaml
sed -i "s/###APP_NAME###/$APP_NAME/g" postgres-configmap.yaml

kubectl apply -f postgres-configmap.yaml

echo "Creating statefulset"
sed -i "s/###NAMESPACE###/$NAMESPACE/g" postgres-sset.yaml
sed -i "s/###APP_NAME###/$APP_NAME/g" postgres-sset.yaml
sed -i "s/###POSTGRES_VERSION###/$POSTGRES_VERSION/g" postgres-sset.yaml

kubectl apply -f postgres-sset.yaml


echo "Creating service"
sed -i "s/###NAMESPACE###/$NAMESPACE/g" postgres-service.yaml
sed -i "s/###APP_NAME###/$APP_NAME/g" postgres-service.yaml

kubectl apply -f postgres-service.yaml

echo "Creating statefulset rbac"
sed -i "s/###NAMESPACE###/$NAMESPACE/g" postgres-sset-rbac.yaml

kubectl apply -f postgres-sset-rbac.yaml

