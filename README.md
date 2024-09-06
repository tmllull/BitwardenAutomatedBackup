## Install unzip

`sudo apt install unzip`

## Download last bw_cli version

```
curl -L -o bw.zip "https://vault.bitwarden.com/download/?platform=linux&app=cli"
unzip bw.zip
sudo mv ./bw /usr/local/bin
rm bw.zip
```

## Create bitwarden user

```bash
sudo adduser \
   --system \
   --shell /bin/bash \
   --group \
   --disabled-password \
   --home /home/bitwarden \
   bitwarden
```

## Access as bitwarden user

`sudo su bitwarden`

## Create .bash_profile for bitwarden user:

Add the following variables to the `/home/bitwarden/.bash_profile`:

```
export BW_CLIENTID="<your_client_id>"
export BW_CLIENTSECRET="<your_client_secret>"
export BW_PASSWORD="<your_vault_password>"
export OPENSSL_ENC_PASS="<your_openssl_encryption_pass>"
export BW_ORG_ID="<your_org_id>" # Optional
```

## Download backup.sh file

Download or copy the content from `backup.sh` file from this repo, and place it where you want.


## Add crontab

Configure crontab to run the script when you want, and not forget to add the PATH=... line.

```bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin
* * * * * /home/bitwarden/backup.sh >> /home/bitwarden/backup.log 2>&1
```


## Decrypt

`openssl enc -aes-256-cbc -pbkdf2 -iter 600000 -d -nopad -in bw_20240906090244.enc -out bw_export.json`


## Sources

- https://bitwarden.com/help/cli/

-  https://bitwarden.com/blog/how-to-back-up-and-encrypt-your-bitwarden-vault-from-the-command-line/

- https://binarypatrick.dev/posts/bitwarden-automated-backup/