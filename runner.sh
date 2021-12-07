ODA_WORKER_ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )"/.. >/dev/null 2>&1 && pwd )"

source env.d/env.sh

export PYTHONPATH=$PWD/data-analysis:$PYTHONPATH
export PYTHONPATH=$PWD/dqueue:$PYTHONPATH
export ODAHUB=http://crux-private.internal.odahub.io@default

dqueue version

mkdir runner-$OSA
cd runner-$OSA

#pyinstrument -o myLog.profile -m dataanalysis.caches.queue $ODAHUB -B 1 -k  ../worker-knowledge-osa${OSA}.yaml
pyinstrument -o myLog.profile -m dataanalysis.caches.queue $ODAHUB -B 1000 -k  ../worker-knowledge-osa${OSA}.yaml

