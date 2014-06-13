cd ../tests && yeti --hub http://yeti-2.liferay.com --junit test_stuck.html &
sleep 20
cd ../tests && yeti --hub http://yeti-2.liferay.com --junit test_pass.html