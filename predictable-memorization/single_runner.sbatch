#!/bin/bash
#SBATCH -n 1
#SBATCH -N 1
#SBATCH -t 48:00:00
#SBATCH --hint=nomultithread        
#SBATCH --mem=24G
#SBATCH --output=logs/%j.out  # Set this dir where you want slurm outs to go
#SBATCH --error=logs/%j.out # Set this dir where you want slurm outs to go
#SBATCH --gres=gpu:a100:1
##SBATCH --gres=gpu:GEFORCEGTX1080TI:1
#SBATCH -p normal

TRAIN_PATH=/om/user/sunnyd/workspace/pythia/predictable-memorization
source activate pythia

export MODEL=1b-v0
export JOB_ID=$2
export CHECKPOINT=$1
export NUM_BLOCKS=16
#export MODEL_PATH=/om/user/abiyer/llm_pruning/sparsegpt/pythia/1b/dataset=wikitext/sparsity=0.6/tokens299.8927B
#export SUFFIX=_sparse-0_6

TRANSFORMERS_CACHE=/om/user/sunnyd/transformers_cache python $TRAIN_PATH/eval_memorization.py

wait
