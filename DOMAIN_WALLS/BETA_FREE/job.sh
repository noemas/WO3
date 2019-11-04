#!/bin/bash
#SBATCH --job-name=BB_110_CORRECT
#SBATCH --partition=normal
#SBATCH --constraint=gpu
#SBATCH --account=s889
#SBATCH --time=24:00:00
#SBATCH --nodes=32
#SBATCH --ntasks-per-node=1
#SBATCH --ntasks-per-core=1
#SBATCH --cpus-per-task=12
#SBATCH --output=out.%j
#SBATCH --error=err.%j
#SBATCH --exclusive

srun vasp_gpu &> log
