#!/bin/bash

APP_NAME="lightspec-webapp"
RG_NAME="lightspec-rg"

echo "Step 1: Installing dependencies locally for Node 24..."
cd webapp
npm install --production 

echo "Step 2: Zipping application code INCLUDING node_modules..."
zip -r ../deploy.zip . -x "*.git*"

echo "Step 3: Deploying to Staging Slot..."
az webapp deployment source config-zip \
    --resource-group $RG_NAME \
    --name $APP_NAME \
    --slot staging \
    --src ../deploy.zip

echo "Step 4: Cleaning up..."
rm ../deploy.zip

echo "✅ Deployment to Staging Complete!"
echo "Visit: https://$APP_NAME-staging.azurewebsites.net"
