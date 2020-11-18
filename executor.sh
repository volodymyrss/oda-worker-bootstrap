export ODAHUB=https://dqueue.staging-1-3.odahub.io@queue-osa11

echo "scratch_root: ${scratch_root:?}"
echo "log_root: ${log_root:?}"

while true; do 
    python -m dqueue.cli runner start-executor -m 30 -t 10 -n -10 \
        'd='${log_root}/'logs/{dt.year}-{dt.month:02d}/{dt.day:02d}/{dt.hour:02d}-{dt.minute:02d}/; mkdir -pv $d; sbatch --export=scratch_root --exclude=node075 -o $d/log-{hostname}-{pid}-{age:06d}.txt runner-slurm.sh' \
        'squeue -u savchenk | grep -v JOBID  || true'; 
done 
