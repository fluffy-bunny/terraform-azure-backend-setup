die () {
    echo >&2 "$@"
    echo "$ ./setup.sh [APP_FRIENDLY_NAME] [LOCATION]"
    exit 1
}
REQUIRED_ARGS=2
[ "$#" -eq $REQUIRED_ARGS ] || die "$REQUIRED_ARGS argument required, $# provided"

random-string() {
        cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w ${1:-12} | head -n 1
}
echo "Positional Parameters"
echo '$0 = '$0
echo '$1 = '$1
APP_FRIENDLY_NAME=$1
LOCATION=$2
RANDOM_STRING=$(random-string)
RESOURCE_GROUP_NAME="rg-terraform-$APP_FRIENDLY_NAME"
CONTAINER_NAME="tstate"
STORAGE_ACCOUNT_NAME="stterraform$RANDOM_STRING"
KV_NAME="kv-tf-$APP_FRIENDLY_NAME"

echo 'APP_FRIENDLY_NAME:    '$APP_FRIENDLY_NAME
echo 'LOCATION:             '$LOCATION
echo 'RESOURCE_GROUP_NAME:  '$RESOURCE_GROUP_NAME
echo 'CONTAINER_NAME:       '$CONTAINER_NAME
echo 'STORAGE_ACCOUNT_NAME: '$STORAGE_ACCOUNT_NAME
echo 'KV_NAME:              '$KV_NAME



az account show

SUBSCRIPTION_ID="$(az account show --query id -o tsv)"
echo 'SUBSCRIPTION_ID: '$SUBSCRIPTION_ID

echo "==== Creating Resource Group: $RESOURCE_GROUP_NAME in Location: $LOCATION"
az group create \
    --name $RESOURCE_GROUP_NAME \
    --location $LOCATION

 
echo "====== Creating KEY VAULT:  $KV_NAME ================="
az keyvault create \
    --location $LOCATION \
    --name $KV_NAME \
    --resource-group $RESOURCE_GROUP_NAME

# Create storage account
az storage account create \
    --resource-group $RESOURCE_GROUP_NAME \
    --name $STORAGE_ACCOUNT_NAME \
    --sku Standard_LRS \
    --encryption-services blob

# Get storage account key
ACCOUNT_KEY=$(az storage account keys list --resource-group $RESOURCE_GROUP_NAME --account-name $STORAGE_ACCOUNT_NAME --query [0].value -o tsv)
 
# Create blob container
az storage container create \
    --name $CONTAINER_NAME \
    --account-name $STORAGE_ACCOUNT_NAME \
    --account-key $ACCOUNT_KEY

echo "storage_account_name: $STORAGE_ACCOUNT_NAME"
echo "container_name: $CONTAINER_NAME"

SECRET_NAME="terraform-backend-key"
VALUE=$ACCOUNT_KEY
az keyvault secret set \
    -n $SECRET_NAME \
    --vault-name $KV_NAME \
    --value "$VALUE"

echo 'export ARM_ACCESS_KEY=$(az keyvault secret show --name '$SECRET_NAME' --vault-name '$KV_NAME' --query value -o tsv)'