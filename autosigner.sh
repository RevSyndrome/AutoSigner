#!/bin/bash

# Colors
lg='\e[92m'
lr='\e[91m'
lc='\e[96m'
w1='\e[0m'

# Arguments
keystore_name=$1
target_apk=$2

# Argument checker
if [ -z "$1" ];then
   echo "Usage: ./autosigner.sh [ANY_KEYSTORE_NAME] [TARGET_APK]"
   exit 1
fi

# Signing APK
echo -en "${lc}[${lr}+${lc}]$w1 AutoSigner starts...\n--------------------\n"
keytool -genkey -v -keystore ${keystore_name}.keystore -alias myStore -keyalg RSA -keysize 2048 -validity 10000
jarsigner -verbose -sigalg SHA1withRSA -digestalg SHA1 -keystore ${keystore_name}.keystore ${target_apk} myStore
echo -en "\n--------------------\n${lc}[${lr}+${lc}]$w1 Verifying target APK...\n--------------------\n"
jarsigner -verify -verbose -certs ${target_apk}
echo -en "\n--------------------\n${lc}[${lr}+${lc}]$w1 Aligning APK...\n--------------------\n"
zipalign -v 4 ${target_apk} patched-and-aligned.apk
echo -en "\n${lc}[${lr}+${lc}]$w1 File saved as: ${lg}patched-and-aligned.apk${w1}."

# Removing junks
if [ -e "${keystore_name}.keystore" ];then
   rm -rf ${keystore_name}.keystore
fi
