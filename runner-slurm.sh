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

echo "worker enabled features: ${DDA_WORKER_ENABLE:=OSA10.2,OSA11.0}"

for n in $(seq 1 ${DDA_WORKER_LIFETIME:-3}); do

    if echo $DDA_WORKER_ENABLE | grep OSA11.0; then
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

        export DDA_WORKER_METADATA_ISDC_ENV=$ISDC_ENV
        export DDA_WORKER_METADATA_OSA=$OSA
        export DDA_WORKER_METADATA_PLATFORM=lesta
        export DDA_WORKER_METADATA_SCRATCH_ROOT=$scratch_root

        worker_name=${HOSTNAME}-${OSA}-${SLURM_JOBID:-notajob}-lesta
        python -m dataanalysis.caches.queue $ODAHUB -B 1 -k  worker-knowledge.yaml -n $worker_name   --json-log-file=log.json

    )
    fi
    
    if echo $DDA_WORKER_ENABLE | grep OSA10.2; then
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

        export DDA_WORKER_METADATA_ISDC_ENV=$ISDC_ENV
        export DDA_WORKER_METADATA_OSA=$OSA
        export DDA_WORKER_METADATA_PLATFORM=lesta
        export DDA_WORKER_METADATA_SCRATCH_ROOT=$scratch_root

        python -m dataanalysis.caches.queue $ODAHUB -B 1 -k  worker-knowledge.yaml -n ${HOSTNAME}-${OSA}-${SLURM_JOBID:-notajob}-lesta  --json-log-file=log.json

    )
    fi
done

if [ "${DDA_CLEANUP:-yes}" == "yes" ]; then
    rm -rfv $d
else
    echo -e "\033[31mleaving intact temporary directory: $d"
fi
