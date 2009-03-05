#!/bin/sh

pwd=`pwd`
# LSST_POLICY_DIR=${pwd}/policy
# export LSST_POLICY_DIR
# echo LSST_POLICY_DIR ${LSST_POLICY_DIR} 

# Command line arguments 
echo $@  echo $#
if [ "$#" != 5 ]; then
   echo "---------------------------------------------------------------------"
   echo "Usage:  $0 <policy-file-name> <runId> <nodelist-file>" \
        "<node-count> <proc-count>"
   echo "---------------------------------------------------------------------"
   exit 0
fi

pipelinePolicyName=${1}
runId=${2}
nodelist=${3}
nodes=${4}
usize=${5}

localnode=`hostname | sed -e 's/\..*$//'`
localncpus=`grep $localnode $nodelist | sed -e 's/^.*://'`

# Subtract 1 to the number of slices to get the universe size 
nslices=$(( $usize - 1 ))

echo "nodes ${nodes}"
echo "nslices ${nslices}"
echo "usize ${usize}"
echo "ncpus ${localncpus}"

# MPI commands will be in PATH if mpich2 is in build
echo "Running mpdboot"

echo mpdboot --totalnum=${nodes} --file=$nodelist --ncpus=$localncpus --verbose
mpdboot --totalnum=${nodes} --file=$nodelist --ncpus=$localncpus --verbose

sleep 3s
echo "Running mpdtrace"
echo mpdtrace -l
mpdtrace -l
sleep 2s

echo "Running mpiexec"

echo mpiexec -usize ${usize} -machinefile nodelist.scr -np 1 -envall runPipeline.py ${pipelinePolicyName} ${runId}
mpiexec -usize ${usize}  -machinefile nodelist.scr -np 1 -envall runPipeline.py ${pipelinePolicyName} ${runId}

sleep 1s

echo "Running mpdallexit"
echo mpdallexit
mpdallexit

