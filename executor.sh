echo "scratch_root: ${scratch_root:=/hpcstorage/savchenk/oda-runner/}"
echo "log_root: ${log_root:=/hpcstorage/savchenk/oda-runner/}"

export scratch_root
export log_root

pip install --upgrade oda-node

while true; do 
    python -m dqueue.cli runner start-executor -m 30 -t 10 -n -5 \
        -d 'd='${log_root}/'logs/{dt.year}-{dt.month:02d}/{dt.day:02d}/{dt.hour:02d}-{dt.minute:02d}/; mkdir -pv $d; sbatch --export=scratch_root --exclude=node075 -o $d/log-{hostname}-{pid}-{age:06d}.txt runner-slurm.sh' \
        -l 'squeue -u savchenk | grep -v JOBID  || true'; 
done 
