#!bin/bash

YETI_VM_ARRAY=(
	"cloud-10-21-4-2"
	"cloud-10-21-4-3"
	"cloud-10-21-4-4"
	"cloud-10-21-4-5"
	"cloud-10-21-4-6"
	"cloud-10-21-4-7"
)

for YETI_VM in "${YETI_VM_ARRAY[@]}"
do
	sshpass -p password ssh -o StrictHostKeyChecking=no Administrator@${YETI_VM} "cmd /c taskkill /f /t /im iexplore.exe & taskkill /f /t /im chrome.exe & taskkill /f /t /im firefox.exe & start http://yeti-2.liferay.com"
done
