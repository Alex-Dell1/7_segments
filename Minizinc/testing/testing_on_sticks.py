from minizinc import Instance, Model, Solver
from datetime import timedelta
import random

solver = Solver.lookup("coin-bc")
sev_segments = Model("./../7-segments_Alex_Della_Schiava.mzn")
single = []
timings = []

for s in [1,2,3,4,5,6,7,8,9,10]:
	for j in range(10):
		print("Sto facendo: " + str(s) + " - " + str(j))
		instance = Instance(solver, sev_segments)
		u = random.randint(s-1,s)
		c = random.randint(s-1,s)
		d = random.randint(s-1,s)
		l = random.randint(s-1,s)
		instance['n'] = 5
		instance['u'] = u
		instance['c'] = c
		instance['d'] = d
		instance['l'] = l

		result = instance.solve(intermediate_solutions=False, timeout = timedelta(minutes = 5))
		timings.append([10, u, c, d, l, result.statistics['time'].seconds])
		print(result.statistics['time'].microseconds)

for x in timings:
	print(x)

average = []
s = 0

for i in range(10):
	for j in range(10):
		s += timings[i*10 + j][5]
		print(timings[i*10 +j][5])
	avg = s/10
	average.append(avg)
	s = 0

print(average)