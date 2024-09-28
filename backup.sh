#!/bin/bash

source /home/bitwarden/.bash_profile
TIMESTAMP=$(date "+%Y%m%d")
EXPORT_PATH="/home/bitwarden/backups"
EXPORT_PLAIN_FILE=bw_$TIMESTAMP.json
EXPORT_ENCRYPTED_FILE=bw_enc_$TIMESTAMP.json
EXPORT_OPENSSL_FILE=bw_$TIMESTAMP.enc
EXPORT_ORG_PLAIN_FILE=bw_org_$TIMESTAMP.json
EXPORT_ORG_ENCRYPTED_FILE=bw_org_enc_$TIMESTAMP.json
EXPORT_ORG_OPENSSL_FILE=bw_org_$TIMESTAMP.enc

bw login --apikey
BW_SESSION=$(bw unlock --passwordenv BW_PASSWORD --raw)

# Unencrypted export (not recommended)
#bw --raw --session $BW_SESSION export --format json --output $EXPORT_PATH/$EXPORT_PLAIN_FILE

# Encrypted export using encrypted_json from bitwarden
# echo "Export encrypted json using bitwarden format..."
# bw --raw --session $BW_SESSION export --format encrypted_json --password $BW_PASSWORD --output $EXPORT_PATH/$EXPORT_ENCRYPTED_FILE
# chmod 644 $EXPORT_PATH/$EXPORT_ENCRYPTED_FILE

# Encrypted export using openssl
echo "Export encrypted json using openssl..."
bw --raw --session $BW_SESSION export --format json | openssl enc -aes-256-cbc -pbkdf2 -iter 600000 -k $OPENSSL_ENC_PASS -out $EXPORT_PATH/$EXPORT_OPENSSL_FILE

# ORGANIZATION
if [[ ! -z "$BW_ORG_ID" ]]
then
    # Unencrypted export (not recommended)
    #bw --raw --session $BW_SESSION export --organizationid $BW_ORG_ID --format json --output $EXPORT_PATH/$EXPORT_ORG_PLAIN_FILE

    # Encrypted export using encrypted_json from bitwarden
    # echo "Export encrypted json using bitwarden format..."
    # bw --raw --session $BW_SESSION export --organizationid $BW_ORG_ID --format encrypted_json --password $BW_PASSWORD --output $EXPORT_PATH/$EXPORT_ORG_ENCRYPTED_FILE
    # chmod 644 $EXPORT_PATH/$EXPORT_ORG_ENCRYPTED_FILE
    
    # Encrypted export using openssl
    echo "Export encrypted json using openssl..."
    bw --raw --session $BW_SESSION export --organizationid $BW_ORG_ID --format json | openssl enc -aes-256-cbc -pbkdf2 -iter 600000 -k $OPENSSL_ENC_PASS -out $EXPORT_PATH/$EXPORT_ORG_OPENSSL_FILE
else
    echo
    echo "No organizational vault defined."
fi

# Cleanup old files.
# Adjust the number of files to keep and days
# depending on your use case.
NUM_FILES=$(find "$EXPORT_PATH" -type f | wc -l)
if [ "$NUM_FILES" -gt 10 ]; then
  find "$EXPORT_PATH" -type f -mtime +5 -exec rm {} \;
fi

echo "Export completed!"
bw logout
