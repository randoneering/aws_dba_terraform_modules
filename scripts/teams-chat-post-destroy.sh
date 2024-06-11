app_name=$(terraform output -json | jq '.app_name'.value)
app_name=${app_name//\"/\\\"}

curl -H "Content-Type: application/json" INSERT_WEBHOOK_URL_HERE \
 -d "{\"text\": \"terraform destroy executed against $app_name. Resource(s) have been deleted! \"}"