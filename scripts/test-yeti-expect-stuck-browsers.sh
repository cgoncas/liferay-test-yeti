#!/bin/bash

source ./check_if_user_can_connect_to_browser.sh

TEST_RESULTS_DIR=../test_results
FILE_NAME_TEST_RESULTS=test_results.xml
FILE_NAME_OUTPUT=output.txt

rm -rf ${TEST_RESULTS_DIR}
mkdir -p ${TEST_RESULTS_DIR}

#All the user are executed in background

cd ../tests && yeti --hub http://yeti-2.liferay.com --junit test_stuck.html > ${TEST_RESULTS_DIR}/user1_${FILE_NAME_TEST_RESULTS} 2> ${TEST_RESULTS_DIR}/user1_${FILE_NAME_OUTPUT} &
pid_users[0]=$!
sleep 10
cd ../tests && yeti --hub http://yeti-2.liferay.com --junit test_pass.html > ${TEST_RESULTS_DIR}/user2_${FILE_NAME_TEST_RESULTS} 2> ${TEST_RESULTS_DIR}/user2_${FILE_NAME_OUTPUT} &
pid_users[1]=$!

#Check if the user has been able to connect to the browser

check_if_pid_is_still_alive ${pid_users[@]}

. restart_yeti.sh