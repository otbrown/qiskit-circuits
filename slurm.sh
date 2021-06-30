#!/bin/bash

# Slurm job options (name, compute nodes, job time)
#SBATCH --job-name=qiskit_32q1n
#SBATCH --time=00:30:00
#SBATCH --exclusive
#SBATCH --ntasks=1
#SBATCH --tasks-per-node=1
#SBATCH --cpus-per-task=36

# Replace [budget code] below with your project code (e.g. t01)
#SBATCH --account=[budget code]
# We use the "standard" partition as we are running on CPU nodes
#SBATCH --partition=standard
# We use the "standard" QoS as our runtime is less than 4 days
#SBATCH --qos=standard

# Set up environment
module load gcc/8.2.0
module load intel-20.4/cmkl
module load mpt
export LD_LIBRARY_PATH=/lustre/sw/intel/compilers_and_libraries_2020.4.304/linux/compiler/lib/intel64:$LD_LIBRARY_PATH

# Python environment
eval "$($HOME/miniconda3/bin/conda shell.bash hook)"
conda activate qiskit

# Change to the submission directory
cd $SLURM_SUBMIT_DIR

# Set the number of threads 
export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK

# Run parameters
NUM_QUBITS=32
echo "QISKIT QFT ON $NUM_QUBITS QUBITS"
echo "SLURM_JOB_NUM_NODES=$SLURM_JOB_NUM_NODES"
echo "SLURM_TASKS_PER_NODE=$SLURM_TASKS_PER_NODE"
echo "SLURM_CPUS_PER_TASK=$SLURM_CPUS_PER_TASK"

# Launch the parallel job
srun --cpu-bind=cores python qft.py $NUM_QUBITS

echo ""
echo "ROUGH WALLTIME: (mm:ss)"
squeue -h -j $SLURM_JOBID -o "%M"
