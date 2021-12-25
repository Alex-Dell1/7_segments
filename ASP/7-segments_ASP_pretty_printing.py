import subprocess, argparse, math

def printDisplays(cols, rows, isStick):
	for i in range(rows):
		for j in [0,1,3,4,6]:
			for k in range(cols):
				if(j == 0 or j == 3 or j == 6):
					if(isStick[(i * cols) + k][j]):
						print("### ", end='')
					# if not lit verify vertical below
					elif(j == 0 or j == 3):
						if(isStick[(i * cols) + k][j+1]):
							print("#.", end='')
						else:
							print("..", end='')
						if(isStick[(i * cols) + k][j+2]):
							print("# ", end='')
						else:
							print(". ", end='')
							
					# if not lit verify vertical above
					elif(j == 6 or j == 3):
						if(isStick[(i * cols) + k][j-2]):
							print("#.", end='')
						else:
							print("..", end='')
						if(isStick[(i * cols) + k][j-1]):
							print("# ", end='')
						else:
							print(". ", end='')

				
				# Vertical segments
				if(j == 1 or j == 4):
					if(isStick[(i * cols) + k][j]):
						print("#.", end='')
					else:
						print(". ", end='')
					if(isStick[(i * cols) + k][j+1]):
						print("# ", end='')
					else:
						print(". ", end='')
			print()
		print()
				
				
				
				
				
				
				
				
def main(n, u, c, d, l):	
	if(n == None or u == None or c == None or d == None or l == None): 
		print("Error: Please insert all the arguments (n,u,c,d,l).")
		return
		
	test = subprocess.Popen(["clingo","7-segments_Alex_Della_Schiava.lp", "-c",  "n="+str(n), "-c", "u="+str(u), "-c", "c="+str(c), "-c", "d="+str(d), "-c", "l="+str(l)], stdout=subprocess.PIPE, universal_newlines=True)
	output = test.communicate()[0]
	print(output)
	lines = output.splitlines()
	if(lines[len(lines) - 8] == "OPTIMUM FOUND"):
		rows = math.floor((int(n) + 1)/3)
		cols = math.ceil(int(n) / 2)
		isStick = [ [ False for i in range(7) ] for j in range(rows*cols) ]
		
		show = lines[len(lines) - 10].split(' ')
		isLit = []
		for pre in show:
			if(pre[:5] == "isLit"):
				pre = pre[6:]
				pre = pre[:3]
				pre = pre.split(',')
				isLit.append(pre)
		
		for i in isLit:
			isStick[int(i[0]) - 1][int(i[1]) - 1] = True
			
		printDisplays(cols, rows, isStick)


if __name__ == '__main__':
	import argparse

	def init():
		parser = argparse.ArgumentParser(description = "Run ASP solver with pretty printing.")
		parser.add_argument(
		    "-n",
		    metavar = "n",
		    help = "Dimension of the grid.")
		    
		parser.add_argument(
		    "-u",
		    metavar = "n",
		    help = "Number of u-shaped sticks.")    
		parser.add_argument(
		    "-c",
		    metavar = "n",
		    help = "Number of c-shaped sticks.")    
		parser.add_argument(
		    "-d",
		    metavar = "n",
		    help = "Number of d-shaped sticks.")    
		parser.add_argument(
		    "-l",
		    metavar = "l",
		    help = "Number of l-shaped sticks.")
		    
		main(
			n = parser.parse_args().n,
			u = parser.parse_args().u,
			c = parser.parse_args().c,
			d = parser.parse_args().d,
			l = parser.parse_args().l,)
	
	init()
	
def main(n, u, c, d, l):
	print(n)

        

