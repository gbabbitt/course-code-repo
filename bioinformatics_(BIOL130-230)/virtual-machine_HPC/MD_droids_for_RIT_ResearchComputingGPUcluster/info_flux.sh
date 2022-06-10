#!/bin/bash -l

#SBATCH --job-name=info_flux
#SBATCH --mail-user=mr8236@rit.edu
#SBATCH --mail-type=FAIL,END
#SBATCH --output=%x_%j.out
#SBATCH --error=%x_%j.err
#SBATCH --time=0-05:00:00
#SBATCH --account silico
#SBATCH --partition tier3
#SBATCH --mem=10G
#SBATCH --array=0-99
spack unload --all

spack load amber@20 /6r7gnm4


fileIDq=${1}
fileIDr=${2}
runsID=100
cpptraj -i atominfo_${fileIDq}_0.ctl | tee cpptraj_atominfo_${fileIDq}.txt
cpptraj -i atominfo_${fileIDr}_0.ctl | tee cpptraj_atominfo_${fileIDr}.txt


echo "Starting ${SLURM_ARRAY_TASK_ID}"
cpptraj -i atomflux_${fileIDq}_${SLURM_ARRAY_TASK_ID}.ctl | tee cpptraj_atomflux_${fileIDq}.txt
cpptraj -i atomflux_${fileIDr}_${SLURM_ARRAY_TASK_ID}.ctl | tee cpptraj_atomflux_${fileIDr}.txt

echo "Finished ${SLURM_ARRAY_TASK_ID}"
