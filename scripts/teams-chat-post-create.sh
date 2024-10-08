app_name=$(terraform output -json | jq '.app_name'.value)
app_name=${app_name//\"/\\\"}

account_name=$(terraform output -json | jq '.account'.value)
account_name=${account_name//\"/\\\"}

curl -H "Content-Type: application/json" INSERT_WEBHOOK_URL_HERE \
 -d "{\"text\": \"terraform apply executed against $app_name. New resource created in $account_name!\"}"