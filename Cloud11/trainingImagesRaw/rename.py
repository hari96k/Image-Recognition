import sys
import os


files = sys.argv
i = 0
extension = ".jpg"
sys.argv[1] = sys.argv[1].capitalize()
if(sys.argv[1] == "Semi"):
	sys.argv[1] = "Semi Circle"
elif(sys.argv[1] == "Quarter"):
	sys.argv[1] = "Quarter Circle"
elif(sys.argv[1] == "Nas"):
	sys.argv[1] = "NaS"

for file in os.listdir(files[1]):
	if file.endswith(extension):
		os.rename(sys.argv[1] + "/" + file, sys.argv[1] + "/" + sys.argv[1] + " " + str(i)+ extension)
		i = i + 1

