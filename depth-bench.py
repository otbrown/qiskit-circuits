import argparse as ap
import timeit as ti
import qiskit as qk
from qiskit.providers import aer
from mpi4py import MPI

run_start = ti.default_timer()

# handle arguments
parser = ap.ArgumentParser(description='Read in number of qubits and number of repetitions.')
parser.add_argument('N_QUBITS',
  type=int,
  help='The number of qubits to be simulated. Must in range 0<N_QUBITS<34.',
  choices=range(1,34)
)
parser.add_argument('N_REPS',
  type=int,
  help='The number of repetitions, should be greater than 0.'
)

args = parser.parse_args()

# build quantum circuit
circ = qk.QuantumCircuit(args.N_QUBITS)
for rep in range(0, args.N_REPS):
  for qubit_id in range(0, args.N_QUBITS):
    circ.h(qubit_id)

circ.measure_all()

N_GATES = args.N_REPS * circ.size()

comm = MPI.COMM_WORLD
rank = comm.Get_rank()

if rank == 0:
    print("Running Hadamard benchmark")
    print("  Number of qubits: ", circ.num_qubits)
    print("  Number of repetitions: ", args.N_REPS)
    print("  1 Hadamard gate per qubit")
    print("Total number of gates: ", N_GATES)
    print()

sim = aer.StatevectorSimulator()

circuit_start = ti.default_timer()
result = qk.execute(circ, sim).result()
circuit_stop = ti.default_timer()

result_dict=result.to_dict()

print("Result metadata:")
print(result_dict['metadata'])
print()

run_stop = ti.default_timer()

if rank == 0:
    print("Results:")
    print('  Run time = {:g} s'.format(run_stop - run_start))
    print('  Circuit time = {:g} s'.format(circuit_stop - circuit_start))
    print('  Time per gate = {:g} s'.format((circuit_stop - circuit_start)/N_GATES))
