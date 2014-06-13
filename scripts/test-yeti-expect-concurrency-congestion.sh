#!/bin/bash

source ./check_if_user_can_connect_to_browser.sh

#This test execute the yeti test for 2 concurrent users

TEST_RESULTS_DIR=../test_results
FILE_NAME_TEST_RESULTS=test_results.xml
FILE_NAME_OUTPUT=output.txt
USERS=3

echo "Running concurrent tests on ${USERS} users"

rm -rf {TEST_RESULTS_DIR}
mkdir -p ${TEST_RESULTS_DIR}

#All the user are executed in background

current_user=1
while [ $current_user -le ${USERS} ]; do
        cd ../tests && yeti --hub http://yeti-2.liferay.com --junit test_delay.html > ${TEST_RESULTS_DIR}/user${current_user}_${FILE_NAME_TEST_RESULTS} 2> ${TEST_RESULTS_DIR}/user${current_user}_${FILE_NAME_OUTPUT} &
        pid_users[${current_user}]=$!
        sleep 1
        current_user=$((current_user + 1))
done

#Check if the user has been able to connect to the browser

check_if_pid_is_still_alive ${pid_users[@]}