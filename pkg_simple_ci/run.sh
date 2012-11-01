#!/bin/sh
source /home/longhengyu/.bashrc
project_url="https://github.com/longhengyu/newpolice"
work_dir="/home/longhengyu/project/CI/newpolice"
project_dir="new-police"
cd "${work_dir}/${project_dir}"
safe_version=$(git log | head -n1 | { read first last; echo $last; })
receiver=$(cat receiver.mail)
echo "safe version : " $safe_version
count=$(git pull | grep "Already up-to-date." | wc -l)
new_version=$(git log | head -n1 | { read first last; echo $last; })
echo "new version : " $new_version
if [[ $count -eq 1 || $new_version == $safe_version ]]
then
	echo "nothing new to deploy."
	date
	exit 1;
fi
new_version_message=$"$(git log | head -n6)"
echo "new version pulled, run test"
count=$(grails test-app -unit | grep "Tests PASSED" | wc -l)
if [[ $count -eq 1 ]]
then
	echo "test successful"	
	# send Email to nofity the deployment
	title="[PKGPLAN CI] A new version has been pushed - "$(date)
	content=$'--- The following commit has been pushed.\n\n'"${new_version_message}"$'\n\n'$"See Diff: ${project_url}/compare/${safe_version:0:7}...${new_version:0:7}"
	echo "$content" | mail -s "${title}" "${receiver}"
else
	# rollback git
	echo "a bad commit, try to revert."
	git reset --hard $safe_version	# revert to a safe version
	# revert remote master
	expect rollback-git.sh
	last_version_message=$"$(git log | head -n6)"
	title="[PKGPLAN CI] The last commit on master was broken - "$(date)
	content=$'--- The following commit fails testing.\n\n'"${new_version_message}"$'\n\n'"See this commit: ${project_url}/commit/${new_version:0:7}"$'\n\n\n--- Git has rolled back to the following commit.\n\n'"${last_version_message}"$'\n\n'"See this commit: ${project_url}/tree/${safe_version:0:7}"
	echo "$content" | mail -s "${title}" "${receiver}"
fi

