#!/bin/sh
source /home/longhengyu/.bashrc
gae_user="USERNAME"
gae_pass="PASSWORD"
work_dir="/home/longhengyu/project/AUTODEPLOY/pkg-new-police-story"
deploy_dir="newpolice.web"
cd $work_dir
safe_version=$(git log | head -n1 | { read first last; echo $last; })
echo "safe version : " $safe_version
count=$(git pull | grep "Already up-to-date." | wc -l)
if [[ $count -eq 1 ]]
then
	echo "nothing new to deploy."
	date
	exit 1;
fi
echo "new version pulled, ready to deploy"
count=$(mvn install | grep "BUILD SUCCESSFUL" | wc -l)
if [[ $count -eq 1 ]]
then
	echo "build successful"	
	cd $deploy_dir 
	mvn gae:deploy > $work_dir/deploy.log 2>&1
	count=$(grep "new version is ready to start serving." $work_dir/deploy.log | wc -l)
	#expect "Email: "
	#send "${gae_user}\r"
	#expect "Password for $gae_user: "
	#send "${gae_pass}\r"
	if [[ $count -eq 1 ]]
	then
		echo "deploy successful"
		# send Email to nofity the deployment
	else
		echo "deploy failed."
		# send Email to nofity the failure
	fi
else
	# rollback git
	echo "a bad commit, try to revert."
	git reset --hard $safe_version	# revert to a safe version
	# revert remote master
	expect rollback-git.sh
fi

