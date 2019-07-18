#!/usr/bin/env bash

. job_pool.sh

CORES=`cat /proc/cpuinfo | awk '/^processor/{print $3}' | wc -l`
N=16
SCRIPT_VMLINUX="../vmlinux.py"
SCRIPT_VERIFIER="./compare_kallsyms.py"

parsekernel() {
	echo "Parsing kernel $1"
	${SCRIPT_VMLINUX} -m vmlinux${1} > ./out/kallsyms${1}.txt
}

job_pool_init $CORES 0

for i in $(seq 0 $N)
do
	job_pool_run parsekernel $i
done

job_pool_wait
job_pool_shutdown

for i in $(seq 0 $N)
do
	echo $i
	${SCRIPT_VERIFIER} ./out/kallsyms${i}.txt ./ref/kallsyms${i}.txt > /dev/null
	comp_value=$?

	if [ $comp_value -eq 1 ]
	then
		echo "!!!TEST ${i} FAILED!!!"
	else
		echo "###TEST ${i} PASSED###"
	fi
done
