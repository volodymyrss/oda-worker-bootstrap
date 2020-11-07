#!/bin/bash

ODA_WORKER_ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )"/.. >/dev/null 2>&1 && pwd )"

cd /scratch/savchenk/oda-runner
source env.d/env.sh

pip install --user data-analysis oda-node --upgrade

dqueue version

d=/scratch/savchenk/odawtmp$$-$RANDOM

mkdir -pv $d

(
    cd $d

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

    export OSA=10.2
    ~/init-osa.sh

    python -m dataanalysis.caches.queue $ODAHUB -B 3 -k  worker-knowledge.yaml

)

(
    cd $d

cat -> worker-knowledge.yaml <<HERE
- any-of:
  - key: ['object_identity', 'modules']
    value: ['git', 'ddosa11/staging-1-3', 'None']
  - key: ['object_identity', 'modules']
    value: ['git', 'ddosa11', 'git://ddosa11/staging-1-3']
HERE
    export OSA=11.0
    ~/init-osa.sh

    python -m dataanalysis.caches.queue $ODAHUB -B 3 -k  worker-knowledge.yaml

)

