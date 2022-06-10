#!/bin/bash -l

##SBATCH --job-name=test_2
#SBATCH --mail-user=mr8236@rit.edu
#SBATCH --mail-type=FAIL,END
#SBATCH --output=%x_%j.out
#SBATCH --error=%x_%j.err
#SBATCH --time=3-0:00:00
#SBATCH --account silico
#SBATCH --partition tier3
#SBATCH --gres=gpu:a100:1 #amber20
#SBATCH --mem=10G

spack unload --all
spack load amber@20 /6r7gnm4

protein="${1}REDUCED" #name of the REDUCED pdb filed


# minimization run
echo "Start minimization run (${SLURM_JOB_ID}) for ${protein}"
start_time=$SECONDS
pmemd.cuda -O -i ${protein}_min.in -o min_${protein}.out -p wat_${protein}.prmtop -c wat_${protein}.inpcrd -r min_${protein}.rst -inf min_${protein}.mdinfo
end_time=$SECONDS
elapsed=$(( end_time - start_time ))
eval "echo Minimization run elapsed time: $(date -ud "@$elapsed" +'$((%s/3600/24)) days %H hr %M min %S sec')"
echo " "

# heating run
start_time=$SECONDS
echo "Start heating run (${SLURM_JOB_ID}) for ${protein}"
pmemd.cuda -O -i ${protein}_heat.in -o heat_${protein}.out -p wat_${protein}.prmtop -c min_${protein}.rst -r heat_${protein}.rst -x heat_${protein}.nc -inf heat_${protein}.mdinfo
end_time=$SECONDS
elapsed=$(( end_time - start_time ))
eval "echo Heating run elapsed time: $(date -ud "@$elapsed" +'$((%s/3600/24)) days %H hr %M min %S sec')"
echo " "
