#!/bin/bash

set -xe -o pipefail

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

echo "scratch_root: ${scratch_root:=/scratch/savchenk/oda-runner/}"
echo "log_root: ${log_root:=/hpcstorage/savchenk/oda-runner/}"

export scratch_root
export log_root

pip install --upgrade oda-node

export LOGSTASH_ENTRYPOINT=cdcihn.isdc.unige.ch:5001

while true; do 
    python -m dqueue.cli runner start-executor -m 30 -t 10 -n -5 \
           -d 'd='${log_root}/'logs/{dt.year}-{dt.month:02d}/{dt.day:02d}/{dt.hour:02d}-{dt.minute:02d}/; 
               mkdir -pv $d
               sbatch --export=scratch_root --exclude=node075 -o $d/log-{hostname}-{pid}-{age:06d}.txt '$DIR'/runner-slurm.sh' \
           -l 'squeue -u savchenk | grep -v JOBID  || true'; 
done 
