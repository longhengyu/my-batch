#!/bin/sh
source /home/longhengyu/.bashrc
work_dir="/home/longhengyu/project/AUTODEPLOY/pkg-new-police-story"
deploy_dir="newpolice.web"
cd $work_dir
safe_version=$(git log | head -n1 | { read first last; echo $last; })
receiver=$(cat receiver.mail)
echo "safe version : " $safe_version
count=$(git pull | grep "Already up-to-date." | wc -l)
if [[ $count -eq 1 ]]
then
	echo "nothing new to deploy."
	date
	exit 1;
fi
new_version=$"$(git log | head -n6)"
echo "new version pulled, ready to deploy"
count=$(mvn install | grep "BUILD SUCCESSFUL" | wc -l)
if [[ $count -eq 1 ]]
then
	echo "build successful"	
	cd $deploy_dir 
	expect ${work_dir}/gae-user-pass.sh > ${work_dir}/deploy.log 2>&1
	count=$(grep "new version is ready to start serving." $work_dir/deploy.log | wc -l)
	if [[ $count -eq 1 ]]
	then
		echo "deploy successful"
		# send Email to nofity the deployment
		title="[PKGPLAN CI] A new version of application has been deployed - "$(date)
		deploy_log=$"$(cat $work_dir/deploy.log)"
		content=$'--- The following commit has been deployed.\n\n'"${new_version}"$'\n\n\n--- the deploy note is as follow.\n\n'"${deploy_log}"
		echo "$content" | mail -s "${title}" "${receiver}"
	else
		echo "deploy failed."
		count=$(grep "appcfg rollback" $work_dir/deploy.log | wc -l)
		if [[ $count -eq 1 ]]
		then
			mvn gae:rollback >> ${work_dir}/deploy.log 2>&1
		fi
		# send Email to nofity the failure
		title="[PKGPLAN CI] Deploy fails: please check google app engine - "$(date)
		deploy_log=$"$(cat $work_dir/deploy.log)"
		content=$'--- The following commit fails to deploy.\n\n'"${new_version}"$'\n\n\n--- the deploy note is as follow.\n\n'"${deploy_log}"
		echo "$content" | mail -s "${title}" "${receiver}"
	fi
else
	# rollback git
	echo "a bad commit, try to revert."
	git reset --hard $safe_version	# revert to a safe version
	# revert remote master
	expect rollback-git.sh
	last_version=$"$(git log | head -n6)"
	title="[PKGPLAN CI] The last commit on master was broken - "$(date)
	content=$'--- The following commit fails compiling.\n\n'"${new_version}"$'\n\n\n--- Git has rolled back to the following commit.\n\n'"${last_version}"
	echo "$content" | mail -s "${title}" "${receiver}"
fi

