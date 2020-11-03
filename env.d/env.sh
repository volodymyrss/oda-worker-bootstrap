ODA_WORKER_ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )"/.. >/dev/null 2>&1 && pwd )"

export TERM=xterm

source $ODA_WORKER_ROOT/env.d/local-pyenv.sh

ls -lotr ~/.dda-token 
chmod 600 ~/.dda-token 

export ODAHUB=https://dqueue.staging-1-3.odahub.io@queue-osa11
export DDA_QUEUE=$ODAHUB


export CURRENT_IC=/isdc/arc/rev_3/

echo "OSA: ${OSA:=10.2}"
if [ $OSA == "10.2" ]; then
    export ISDC_ENV=/unsaved/astro/savchenk/software/osa/10.2/
elif [ $OSA == "11.1" ]; then
    export ISDC_ENV=/unsaved/astro/savchenk/osa11_deployment/deployment/CentOS_7.7.1908_x86_64/osa11
fi
source $ISDC_ENV/bin/isdc_init_env.sh

export HEADAS=/unsaved/astro/savchenk/osa11_deployment/deployment/CentOS_7.7.1908_x86_64/heasoft-versions/6.25/ae75cac5-20191219-121436/x86_64-pc-linux-gnu-libc2.17/
source $HEADAS/headas-init.sh 

export ISDC_REF_CAT=/isdc/arc/rev_3/cat/hec/gnrl_refr_cat_0043.fits 
export REP_BASE_PROD=/isdc/arc/rev_3/
export REP_BASE_PROD_CONS=/isdc/arc/rev_3/
export REP_BASE_PROD_NRT=/isdc/pvphase/nrt/ops
export INTEGRAL_DDCACHE_ROOT=$PWD/data/reduced/ddcache
export INTEGRAL_DATA=$REP_BASE_PROD/
export ISGRI_RESPONSE=/unsaved/astro/savchenk/data/resources/rmf_62bands.fits 

#pip install pip --upgrade
#pip install -r requirements.txt

export PYTHONPATH=$PWD/data-analysis:$PYTHONPATH
export PYTHONPATH=$PWD/dqueue:$PYTHONPATH


export PYTHONUNBUFFERED=1

#python -m dataanalysis.caches.queue $ODAHUB
#python -m dataanalysis.caches.queue -V $ODAHUB -B 1 -t 100
