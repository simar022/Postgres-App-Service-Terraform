#!/bin/bash

APP_NAME="lightspec-webapp"
RG_NAME="lightspec-rg"

echo "Step 1: Installing dependencies locally for Node 24..."
cd ../webapp
npm install --production 

echo "Step 2: Zipping application code INCLUDING node_modules..."
zip -r ../deploy-dev.zip . -x "*.git*"

echo "Step 3: Deploying to Development Slot..."
az webapp deployment source config-zip \
    --resource-group $RG_NAME \
    --name $APP_NAME \
    --slot dev \
    --src ../deploy-dev.zip

echo "Step 4: Cleaning up..."
rm ../deploy-dev.zip

echo "✅ Deployment to Development Complete!"
echo "Visit: https://$APP_NAME-dev.azurewebsites.net"

