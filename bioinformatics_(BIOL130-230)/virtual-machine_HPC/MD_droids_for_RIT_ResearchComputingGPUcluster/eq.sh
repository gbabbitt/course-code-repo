#!/bin/bash -l

##SBATCH --job-name=test_2
#SBATCH --mail-user=mr8236@rit.edu
#SBATCH --mail-type=FAIL,END
#SBATCH --output=%x_%j.out
#SBATCH --error=%x_%j.err
#SBATCH --time=5-0:00:00
#SBATCH --account silico
#SBATCH --partition tier3
#SBATCH --gres=gpu:a100:1 #amber20
#SBATCH --mem=10G

spack unload --all
spack load amber@20 /6r7gnm4

protein="${1}REDUCED" #name of the REDUCED pdb filed

# equilibration run
start_time=$SECONDS
echo "Start equilibration run (${SLURM_JOB_ID}) for ${protein}"
pmemd.cuda -O -i ${protein}_eq.in -o eq_${protein}.out -p wat_${protein}.prmtop -c heat_${protein}.rst -r eq_${protein}.rst -x eq_${protein}.nc -inf eq_${protein}.info
end_time=$SECONDS
elapsed=$(( end_time - start_time ))
eval "echo Equilibration run elapsed time: $(date -ud "@$elapsed" +'$((%s/3600/24)) days %H hr %M min %S sec')"
echo " "