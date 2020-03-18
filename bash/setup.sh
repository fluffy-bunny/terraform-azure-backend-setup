SUBSCRIPTION_ID="$(az account show -s $SUBSCRIPTION_NAME --query id -o tsv)"
echo 'SUBSCRIPTION_ID = '$SUBSCRIPTION_ID
