cp $k8sTemplatesPath/postgres-secret.yaml .
cp $k8sTemplatesPath/postgres-setup.yaml .

cp $k8sTemplatesPath/efs-pv-provisioner.yaml .
cp $k8sTemplatesPath/efs-pv-configmap.yaml .
cp $k8sTemplatesPath/efs-storageclass.yaml .
cp $k8sTemplatesPath/efs-pv-rbac.yaml .

echo "Namespace: $NAMESPACE"
export KUBECONFIG="/home/ec2-user/.kube/config"
kubectl create ns $NAMESPACE
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
echo "Installing KubeGres Operator"
kubectl apply -f https://raw.githubusercontent.com/reactive-tech/kubegres/v1.6/kubegres.yaml

echo "Creating postgres secret"
sed -i "s/###NAMESPACE###/$NAMESPACE/g" postgres-secret.yaml
sed -i "s/###DB_USER###/$DB_USER/g" postgres-secret.yaml
sed -i "s/###DB_PASS###/$DB_PASS/g" postgres-secret.yaml
sed -i "s/###APP_NAME###/$APP_NAME/g" postgres-secret.yaml

kubectl apply -f postgres-secret.yaml

echo "Setting up postgres"
sed -i "s/###NAMESPACE###/$NAMESPACE/g" postgres-setup.yaml
sed -i "s/###APP_NAME###/$APP_NAME/g" postgres-setup.yaml
sed -i "s/###POSTGRES_VERSION###/$POSTGRES_VERSION/g" postgres-setup.yaml

kubectl apply -f postgres-setup.yaml