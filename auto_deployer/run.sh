#!/usr/bin/expect -f
source /home/longhengyu/.bashrc
gae_user="YOUR NAME"
gae_pass="YOUR PASSWORD"
work_dir="/home/longhengyu/project/AUTODEPLOY/pkg-new-police-story"
deploy_dir="newpolice.web"
cd $work_dir
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
	mvn gae:deploy
	expect "Email: "
	send "${gae_user}\r"
	expect "Password for $gae_user: "
	send "${gae_pass}\r"
fi
