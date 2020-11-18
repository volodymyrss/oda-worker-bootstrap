#!/bin/bash

# trace!

export PYTHONUNBUFFERED=1
ODA_WORKER_ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )"/.. >/dev/null 2>&1 && pwd )"

export ODAHUB=https://dqueue.staging-1-3.odahub.io@queue-osa11

pip install --user data-analysis oda-node --upgrade

dqueue version

export scratch_root=${scratch_root:-/hpcstorage/savchenk/oda-runner/tmp-runner/}

echo -e "\033[33mscratch root ${scratch_root}\033[0m"

d=${scratch_root}/odawtmp$$-$RANDOM

export EXIT_WITHOUT_INTEGRAL_ARCHIVE=yes

mkdir -pv $d


for n in $(seq 1 5); do

    (
        export OSA=11.0
        cd $d
        echo -e "\033[32mworker for $OSA in $PWD\033[0m"

    cat -> worker-knowledge.yaml <<HERE
- any-of:
  - key: ['object_identity', 'modules']
    value: ['git', 'ddosa11/staging-1-3', 'None']
  - key: ['object_identity', 'modules']
    value: ['git', 'ddosa11', 'git://ddosa11/staging-1-3']
HERE
        source ~/init-osa.sh

        worker_name=${HOSTNAME}-${OSA}-${SLURM_JOBID:-notajob}
        python -m dataanalysis.caches.queue $ODAHUB -B 1 -k  worker-knowledge.yaml -n $worker_name   --json-log-file=log.json

    )
    
    (
        cd $d
        export OSA=10.2
        echo -e "\033[32mworker for $OSA in $PWD\033[0m"

    cat -> worker-knowledge.yaml <<HERE
- none-of:
  - key: ['object_identity', 'modules']
    value: ['git', 'ddosa11/staging-1-3', 'None']
  - key: ['object_identity', 'modules']
    value: ['git', 'ddosa11', 'git://ddosa11/staging-1-3']
- any-of:
  - key: ['object_identity', 'modules']
    value: ['git', 'ddosa/staging-1-3', 'None']
  - key: ['object_identity', 'modules']
    value: ['git', 'ddosa', 'git://ddosa/staging-1-3']
HERE

        source ~/init-osa.sh

        python -m dataanalysis.caches.queue $ODAHUB -B 1 -k  worker-knowledge.yaml -n ${HOSTNAME}-${OSA}-${SLURM_JOBID:-notajob}  --json-log-file=log.json

    )
done

rm -rfv $d
