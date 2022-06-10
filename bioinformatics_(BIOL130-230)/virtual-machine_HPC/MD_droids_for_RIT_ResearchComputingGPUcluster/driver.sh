#!/bin/sh
input_1="deltaV_batR"
input_2="deltaV_humanR"
num_runs=100
job_array=$(( $num_runs - 1 ))

id_1=`sbatch --job-name=${input_1}_min_heat --parsable min_heat.sh $input_1`
id_2=`sbatch --job-name=${input_1}_eq --parsable --dependency=afterok:$id_1 eq.sh $input_1` 
id_4=`sbatch --job-name=${input_1}_rand_prod --parsable --dependency=afterok:$id_2 --array=0-${job_array} rand_prod.sh $input_1`

id_a=`sbatch --job-name=${input_2}_min_heat --parsable min_heat.sh $input_2`
id_b=`sbatch --job-name=${input_2}_eq --parsable --dependency=afterok:$id_a eq.sh $input_2`
id_d=`sbatch --job-name=${input_2}_rand_prod --parsable --dependency=afterok:$id_b --array=0-${job_array} rand_prod.sh $input_2`

id_3=`sbatch --job-name=${input_1}info_flux --parsable --dependency=afterok:$id_d:$id_4 --array=0-${job_array} info_flux.sh $input_1 $input_2`
