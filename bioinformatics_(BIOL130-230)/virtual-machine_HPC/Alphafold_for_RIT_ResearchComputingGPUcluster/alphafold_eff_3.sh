#!/bin/bash -l
#SBATCH --job-name=test_6
#SBATCH --output=%x_%j.out
#SBATCH --error=%x_%j.err 
#SBATCH --mail-user=mr8236@rit.edu
#SBATCH --mail-type=ALL
# 5 days is the run time MAX, anything over will be KILLED unless you talk with RC
# Time limit days-hrs:min:sec
#SBATCH -N 1            # number of nodes
#SBATCH -c 8            # number of cores
#SBATCH --mem=32000     
#SBATCH --time=0-11:0:0
#SBATCH --account=silico 
#SBATCH --partition=tier3
#SBATCH --gres=gpu:a100:1
###################################################################################CHANGE MODEL PRESET ACCORDINGLY
echo "(${HOSTNAME}) lets start"
. /shared/rc/tools/spack-ng-test/share/spack/setup-env.sh

spack load py-alphafold
run_alphafold.py --data_dir=/shared/rc/pub/alphafold/ --fasta_paths=/.autofs/scratch/mr8236/test.fasta --output_dir=/.autofs/scratch/mr8236/test_1 --uniref90_database_path=/shared/rc/pub/alphafold/uniref90/uniref90.fasta --mgnify_database_path=/shared/rc/pub/alphafold/mgnify/mgy_clusters_2018_12.fa --template_mmcif_dir=/shared/rc/pub/alphafold/pdb_mmcif/mmcif_files --max_template_date=2020-05-14 --obsolete_pdbs_path=/shared/rc/pub/alphafold/pdb_mmcif/obsolete.dat --bfd_database_path=/shared/rc/pub/alphafold/bfd/bfd_metaclust_clu_complete_id30_c90_final_seq.sorted_opt --uniclust30_database_path=/shared/rc/pub/alphafold/uniclust30/uniclust30_2018_08/uniclust30_2018_08 --pdb70_database_path=/shared/rc/pub/alphafold/pdb70/pdb70

echo "(${HOSTNAME}) I finished"
