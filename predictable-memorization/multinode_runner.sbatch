#!/bin/bash
#SBATCH -n 4
#SBATCH -N 2
#SBATCH -t 48:00:00
#SBATCH --hint=nomultithread        
#SBATCH --cpus-per-task=6
#SBATCH --output=logs/%j.out  # Set this dir where you want slurm outs to go
#SBATCH --error=logs/%j.out # Set this dir where you want slurm outs to go
#SBATCH --comment=neox
#SBATCH --gres=gpu:a100:2
##SBATCH --gpus-per-node=1
##SBATCH -N 1
##SBATCH -p fiete
##SBATCH -p multi-gpu
##SBATCH --exclusive

module load openmpi
module load cuda/11.3

export GIT_DISCOVERY_ACROSS_FILESYSTEM=0
TRAIN_PATH=/om/user/sunnyd/workspace/pythia/predictable-memorization
source activate llm
#export NCCL_DEBUG=INFO

# # MODELS=(70m-deduped-v0 160m-deduped-v0 410m-deduped-v0 1b-deduped-v0 1.4b-deduped-v0 2.8b-deduped-v0 6.9b-deduped-v0 12b-deduped-v0 70m-v0 160m-v0 410m-v0 1b-v0 1.4b-v0 2.8b-v0 6.9b-v0 12b-v0)
# MODELS=(70m-v0 160m-v0 )
# CHECKPOINTS=(143000 123000 103000 83000 63000 43000 23000)
# # srun -n $SLURM_NPROCS /fsx/orz/memorization/bin/python3 $TRAIN_PATH/test_gpu.py
# echo $TRAIN_PATH
# for model in ${MODELS[@]}
# do
# for checkpoint in ${CHECKPOINTS[@]}
#     do
#     export MODEL=$model
#     export CHECKPOINT=$checkpoint
#     TRANSFORMERS_CACHE=/om/user/sunnyd/transformers_cache srun -n $SLURM_NPROCS python $TRAIN_PATH/eval_memorization.py
# done
# done

export MODEL=70m-v0
export CHECKPOINT="$@"
TRANSFORMERS_CACHE=/om/user/sunnyd/transformers_cache srun -n $SLURM_NPROCS python $TRAIN_PATH/eval_memorization.py

wait
