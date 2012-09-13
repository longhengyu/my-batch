#!/bin/sh

function scandir() {
	local cur_dir parent_dir workdir
	filetype=$1
	workdir=$2
	echo "*** Info: checking directory $workdir"
	outputdir=$3
	nowtimemilsec=$4
	if [[ "$workdir" = "${outputdir}_$nowtimemilsec" ]]
	then
		echo "*** Info: ignore output dir"
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
			scandir $filetype ${cur_dir}/${dirlist} $output $nowtimemilsec
			cd ..
		else
			# do something with the file here.
			filename=${cur_dir}/${dirlist}
			extension=`echo $dirlist|awk -F . '{print $NF}'`
			if [[ "$extension" = "$filetype" ]]
			then
				basename=`basename $filename .$extension`
				escapedfilepath=`echo ${cur_dir} | sed -e "s/\//_/g"`
				cp $filename ${output}_$nowtimemilsec/${basename}${escapedfilepath}.${extension}
				echo "*** Info: Copying file $filename"
			fi
		fi	
	done
}
filetype=$1
if [ ! -n "$filetype" ]
then
	echo "*** Error: Please Specify a file type."
	echo "***        Example: ./run jpg <working_dir> <output_dir>"
	exit 1;
fi
folder=$2
output=$3
if [ ! -n "$folder" ]
then
	echo "*** Info: No working directory specified, work in current directory."
	folder=$(pwd)
fi	
if [ ! -n "$output" ]
then
	nowtimemilsec=`date +%s`
	output=`echo $(pwd)/output`
	echo "*** Info: No output directory specified, output to ${output}_$nowtimemilsec"
	mkdir ${output}_$nowtimemilsec
fi
if test -d $folder
	then
	scandir $filetype $folder $output $nowtimemilsec
elif test -f $folder
then
	echo "*** Info: You input a file but not a directory,pls reinput and try again"
	exit 1
else
	echo "*** Info: The Directory isn't exist which you input,pls input a new one!!"
	exit 1
fi
