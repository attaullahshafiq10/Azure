#!/bin/bash

set -euo pipefail

# Make sure these values are correct for your environment
resourceGroup="dm-api-rls"
appName="dm-api-rls"
location="WestUS2" 

# Change this if you are using your own github repository
gitSource="https://github.com/azure-samples/azure-sql-db-secure-data-access-api"

# Make sure connection string variable is set
if [[ -z "${SQLAZURECONNSTR_RLS:-}" ]]; then
	echo "Plase export Azure SQL connection string:";
    echo "export SQLAZURECONNSTR_RLS\"your-connection-string-here\"";
	exit 1;
fi

echo "Creating Resource Group...";
az group create \
    -n $resourceGroup \
    -l $location

echo "Creating Application Service Plan...";
az appservice plan create \
    -g $resourceGroup \
    -n "linux-plan" \
    --sku B1 \
    --is-linux

echo "Creating Web Application...";
az webapp create \
    -g $resourceGroup \
    -n $appName \
    --plan "linux-plan" \
    --runtime "PYTHON|3.7" \
    --deployment-source-url $gitSource \
    --deployment-source-branch master

echo "Configuring Connection String...";
az webapp config connection-string set \
    -g $resourceGroup \
    -n $appName \
    --settings RLS="$SQLAZURECONNSTR_RLS" \
    --connection-string-type=SQLAzure

echo "Done."