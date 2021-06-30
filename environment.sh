module load cmake
module load gcc/8.2.0
module load intel-20.4/cmkl
module load mpt
conda activate qiskit
export LD_LIBRARY_PATH=/lustre/sw/intel/compilers_and_libraries_2020.4.304/linux/compiler/lib/intel64:$LD_LIBRARY_PATH
