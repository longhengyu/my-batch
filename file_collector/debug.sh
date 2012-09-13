#!/bin/sh

function scandir() {
	local cur_dir parent_dir workdir
	workdir=$1
	echo "*** Info: checking directory $workdir"
	outputdir=$2
	#echo "*** Info: output dir is $outputdir"
	if [ $workdir == $outputdir ]
	then
		return
	fi
	cd ${workdir}
	if [ ${workdir} = "/" ]
	then
		cur_dir=""
	else
		cur_dir=$(pwd)
	fi
	for dirlist in $(ls ${cur_dir})
	do
		if test -d ${dirlist};then
			cd ${dirlist}
			scandir ${cur_dir}/${dirlist} $output
			cd ..
		else
			# do something with the file here.
			filename=${cur_dir}/${dirlist}
			extension=`echo $dirlist|awk -F . '{print $NF}'`
			#echo "extension="$extension
			if [[ "$extension" == "txt" ]]
			then
				basename=`basename $filename .$extension`
				#echo "basename="$basename
				escapedfilepath=`echo ${cur_dir} | sed -e "s/\//_/g"`
				#echo "escapedfilepath="$escapedfilepath
				#echo "origin file=$filename"
				#echo "destination_file_name=${basename}${escapedfilepath}.${extension}"
				#echo 'output folder='$output
				cp $filename $output/${basename}${escapedfilepath}.${extension}
				echo "*** Info: Copying file $filename"
			fi
		fi	
	done
}
folder=$1
output=$2
if [ ! -n "$1" ]
then
	echo "*** Info: No working directory specified, work in current directory."
	folder=$(pwd)
fi	
if [ ! -n "$2" ]
then
	output=`echo $(pwd)/output`
	echo "*** Info: No output directory specified, output to $output"
	mkdir $output
fi
if test -d $folder
	then
	scandir $folder $output
elif test -f $folder
then
	echo "*** Info: You input a file but not a directory,pls reinput and try again"
	exit 1
else
	echo "*** Info: The Directory isn't exist which you input,pls input a new one!!"
	exit 1
fi
