from minizinc import Instance, Model, Solver
from datetime import timedelta
import random

solver = Solver.lookup("coin-bc")
sev_segments = Model("./../7-segments_Alex_Della_Schiava.mzn")
single = []
timings = []


for n in [4,5,6,7,8,9,10,11,12,13]:
	for j in range(10):
		print("Sto facendo: " + str(n) + " - " + str(j))
		instance = Instance(solver, sev_segments)
		u = random.randint(n-3,n)
		c = random.randint(n-3,n)
		d = random.randint(n-3,n)
		l = random.randint(n-3,n)
		instance['n'] = n
		instance['u'] = u
		instance['c'] = c
		instance['d'] = d
		instance['l'] = l

		result = instance.solve(intermediate_solutions=False, timeout = timedelta(minutes = 5))
		print(result.statistics)
		timings.append([n, u, c, d, l, result.statistics['time'].microseconds])
		print(result.statistics['time'].seconds)

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