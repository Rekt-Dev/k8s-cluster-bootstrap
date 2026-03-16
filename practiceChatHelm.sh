set -e

# 1️⃣ Create namespace
kubectl create ns immutable-practice --dry-run=client -o yaml | kubectl apply -f -

# 2️⃣ Switch context to the namespace
kubectl config set-context --current --namespace=immutable-practice

# 3️⃣ Create immutable Secret
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Secret
metadata:
  name: db-secret
immutable: true
type: Opaque
data:
  username: YWRtaW4=
  password: czNjcmV0
EOF

# 4️⃣ Create a minimal Helm chart
CHART_DIR="./dbapp"
helm create $CHART_DIR

# 5️⃣ Inject a sidecar container via values.yaml
cat <<EOF > $CHART_DIR/values.yaml
image:
  repository: nginx
  tag: stable

extraContainers:
  - name: sidecar
    image: busybox
    command: ["sh", "-c", "echo Sidecar running && sleep 3600"]
EOF

# 6️⃣ Patch deployment template to mount Secret (env only)
cat <<'EOF' > $CHART_DIR/templates/secret-env.yaml
env:
  - name: DB_USERNAME
    valueFrom:
      secretKeyRef:
        name: db-secret
        key: username
  - name: DB_PASSWORD
    valueFrom:
      secretKeyRef:
        name: db-secret
        key: password
EOF

# 7️⃣ Install Helm release
helm install mydbapp $CHART_DIR -n immutable-practice

# 8️⃣ Show pods
kubectl get pods -n immutable-practice

echo "✅ Environment ready. Practice immutable Secret + Helm upgrades now!"

