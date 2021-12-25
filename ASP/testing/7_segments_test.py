import subprocess
import random
test = subprocess.Popen(["clingo","7-segments_Alex_Della_Schiava.lp", "-c", "n=6", "-c", "u=5", "-c", "c=3", "-c", "d=0", "-c", "l=0"], stdout=subprocess.PIPE, universal_newlines=True)

timings = []

#process = subprocess.run([["clingo","7-segments_Alex_Della_Schiava.lp", "-c", "n=6", "-c", "u=5", "-c", "c=3", "-c", "d=0", "-c", "l=0"], check=True, stdout=subprocess.PIPE, universal_newlines=True)

for n in [4,5,6,7]:
	for j in range(25):
		print("Sto facendo " + str(n) + " - " + str(j))
		u = random.randint(n-4,n)
		c = random.randint(n-4,n)
		d = random.randint(n-4,n)
		l = random.randint(n-4,n)
		test = subprocess.Popen(["clingo","7-segments_Alex_Della_Schiava.lp", "-c", "n="+str(n), "-c", "u="+str(u), "-c", "c="+str(c), "-c", "d="+str(d), "-c", "l="+str(l)], stdout=subprocess.PIPE, universal_newlines=True)
		
		output = test.communicate()[0]
		aux1 = output.splitlines()
		aux2 = aux1[len(aux1)-2].split(':')
		aux3 = aux2[1].split(' ')
		time = aux3[1].strip('s')
		timings.append([n,u,c,d,l,float(time)])


for x in timings:
	print(x)

s=0
average = []
for i in range(4):
	for j in range(25):
		s += timings[i*25 + j][5]
		print(timings[i*25 +j][5])
	avg = s/25
	average.append(avg)
	s = 0

print(average)
