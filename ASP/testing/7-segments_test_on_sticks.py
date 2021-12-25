import random
import subprocess

timings = []

for s in [4,5,6,7]:
	for j in range(8):
		print("Sto facendo " + str(s) + " - " + str(j))
		n = 7
		
		u = random.randint(s-3,s)
		c = random.randint(s-3,s)
		d = random.randint(s-3,s)
		l = random.randint(s-3,s)
		test = subprocess.Popen(["clingo","7-segments_Alex_Della_Schiava.lp", "-c", "n="+str(n), "-c", "u="+str(u), "-c", "c="+str(c), "-c", "d="+str(d), "-c", "l="+str(l)], stdout=subprocess.PIPE, universal_newlines=True)
		
		output = test.communicate()[0]
		aux1 = output.splitlines()
		aux2 = aux1[len(aux1)-2].split(':')
		aux3 = aux2[1].split(' ')
		time = aux3[1].strip('s')
		timings.append([n,u,c,d,l,float(time)])
	
for x in timings:
	print(x)
