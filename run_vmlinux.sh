#!/usr/bin/env bash

N=16
SCRIPT_VMLINUX="../vmlinux.py"
SCRIPT_VERIFIER="./compare_kallsyms.py"

for i in $(seq 0 $N)
do
	${SCRIPT_VMLINUX} vmlinux${i} -m > ./out/kallsyms${i}.txt &
	pids[${i}]=$!
done

# wait for all pids
for pid in ${pids[*]}; do
	wait $pid
done

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
