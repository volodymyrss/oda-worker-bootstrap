#!/bin/bash

source /usr/share/lmod/lmod/init/bash

module load proxy

set -xe -o pipefail

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

echo "scratch_root: ${scratch_root:=/dev/shm/savchenk/oda-runner}"
#echo "scratch_root: ${scratch_root:=/scratch/savchenk/oda-runner/}"
echo "log_root: ${log_root:=/hpcstorage/savchenk/oda-runner/}"

export scratch_root
export log_root

pip install --upgrade oda-node

export LOGSTASH_ENTRYPOINT=cdcihn.isdc.unige.ch:5001
export ODAHUB=http://crux-private.internal.odahub.io@default


while true; do 
    python -m dqueue.cli runner start-executor -m 200 -t 10 -n 0 \
           -d 'd='${log_root}/'logs/{dt.year}-{dt.month:02d}/{dt.day:02d}/{dt.hour:02d}-{dt.minute:02d}/; 
               mkdir -pv $d
               for i in $(seq 1 1); do sbatch --mem 8Gb -p p4,p5 --export=scratch_root -o $d/log-{hostname}-{pid}-{age:06d}-$i.txt '$DIR'/runner-slurm.sh; done' \
           -l 'squeue -u savchenk | grep -v JOBID  || true'; 
done 
