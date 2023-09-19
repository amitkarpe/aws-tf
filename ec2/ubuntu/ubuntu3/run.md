# Run

* Run following commands to verify the installation 

```sh
IP=$(terraform output -json | jq -r .ip.value); echo $IP
ssh ubuntu@$IP -i ~/.ssh/privatekey.pem 
nvm version; node -v; npm version
```



