while true; do 
    python -m dqueue.cli runner start-executor -m 30 -t 10 -n -10 \
        'd=logs/{dt.year}-{dt.month:02d}/{dt.day:02d}/{dt.hour:02d}-{dt.minute:02d}/; mkdir -pv $d; sbatch --exclude=node075 -o $d/log-{hostname}-{pid}-{age:06d}.txt runner-slurm.sh' \
        'squeue -u savchenk | grep -v JOBID  || true'; 
done > log 2>&1
