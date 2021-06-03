cp $k8sTemplatesPath/postgres-pv.yaml .
cp $k8sTemplatesPath/postgres-pvclaim.yaml .
cp $k8sTemplatesPath/postgres-configmap.yaml .
cp $k8sTemplatesPath/postgres-sset.yaml .
cp $k8sTemplatesPath/postgres-service.yaml .
: '
echo "Creating persistent volume"
kubectl apply -f postgres-pv.yaml
echo "Creating persistent volume claim"
kubectl apply -f postgres-pvclaim.yaml
'
echo "Creating config map"
sed -i "s/###DB_NAME###/$DB_NAME/g" postgres-configmap.yaml
sed -i "s/###DB_USER###/$DB_USER/g" postgres-configmap.yaml
sed -i "s/###DB_PASS###/$DB_PASS/g" postgres-configmap.yaml
sed -i "s/###APP_NAME###/$APP_NAME/g" postgres-configmap.yaml

kubectl apply -f postgres-config.yaml

echo "Creating statefulset"
sed -i "s/###APP_NAME###/$APP_NAME/g" postgres-sset.yaml
sed -i "s/###POSTGRES_VERSION###/$POSTGRES_VERSION/g" postgres-sset.yaml

kubectl apply -f postgres-sset.yaml


echo "Creating service"
sed -i "s/###APP_NAME###/$APP_NAME/g" postgres-service.yaml

kubectl apply -f postgres-service.yaml

