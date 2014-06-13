#!/bin/bash

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

current_user=1;
for user_pid in "${pid_users[@]}"
do
        child_pid=$(ps --ppid ${user_pid} -o pid| sed -n 2p)

        check_if_pid_is_still_alive=$(ps | grep $child_pid | grep -v grep)

        iteration=1;
        killed=false;
        MAX_ITERATIONS=20;
        while [ "$check_if_pid_is_still_alive" ] && [ "$iteration" -le "$MAX_ITERATIONS" ]
        do
                echo "The tests of the user $current_user are still running in the iteration $iteration"
                last_output=$(tail -n 1 ${TEST_RESULTS_DIR}/user${current_user}_${FILE_NAME_OUTPUT})
                if [ "$last_output" == "When ready, press Enter to begin testing." ]
                then
                	echo "The user ${current_user} can't connect to the browser: $last_output, so is going to be killed"
                	kill ${child_pid}
                	killed=true;
                fi
                sleep 1
                iteration=$((iteration + 1))
                check_if_pid_is_still_alive=$(ps | grep $child_pid | grep -v grep)
        done

        if [ $killed = false ] && [ "$iteration" -le "$MAX_ITERATIONS" ]
        then
                echo "The user ${current_user} can connect to the browser"
        else
                echo "The user ${current_user} cant connect to the browser"
        fi
        current_user=$((current_user + 1))
done

. restart_yeti.sh
