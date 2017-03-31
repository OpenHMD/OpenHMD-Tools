import sys
from math import *

if len(sys.argv) < 6:
	print("OpenHMD conversion for hugin -> Universal Distortion struct")
	print("Use running 'python calculatestruct.py A B C R G B")
	print("This calculation assumes calibration is done on Green channel")
	quit()

prefix_string = "priv->base.properties."
structarray = 	[	prefix_string+"universal_distortion_k[0] = ",
					prefix_string+"universal_distortion_k[1] = ",
					prefix_string+"universal_distortion_k[2] = ",
					prefix_string+"universal_distortion_k[3] = ",
					prefix_string+"universal_aberration_k[0] = ",
					prefix_string+"universal_aberration_k[1] = ",
					prefix_string+"universal_aberration_k[2] = "
				]

# ABC channel and calculated D
# d=(1-a-b-c)
structarray[0] += (sys.argv[1]+";")
structarray[1] += (sys.argv[2]+";")
structarray[2] += (sys.argv[3]+";")
structarray[3] += str(1-int(sys.argv[1])-int(sys.argv[2])-int(sys.argv[3]))+";"

# RGB channel with G as default calibration
# sin(r_hfov/2)/sin(g_hfov/2)
# sin(b_hfov/2)/sin(g_hfov/2)
structarray[4] += str(sin(int(sys.argv[4])/2)/sin(int(sys.argv[5])/2))+";"
structarray[5] += "1.000f"
structarray[6] += str(sin(int(sys.argv[6])/2)/sin(int(sys.argv[5])/2))+";"

print("Output struct for OpenHMD Universal Distotion")
print("---------------------------------------------\n")
print '\n'.join(structarray)
