import pandas as pd
import numpy as np
from scipy import stats

in_data = pd.read_csv(r"/Users/Ethan/Documents/code/yateslab/2.3 Cell 1 7a.txt",sep='\t')
df = pd.DataFrame(in_data)
#in_data = None
base = df.loc[0:199] #first two second baseline
MED = df.loc[200:299] #midline to ear up/down
ED = df.loc[300:499] #ear down
EDM = df.loc[500:599] #ear down to midline
MID = df.loc[600:799] #second midline segment
ME  = df.loc[800:899] #Midline to leg extension
EX = df.loc[900:1099] #Leg Extension
EM = df.loc[1100:1199] #Leg return to midline
MID2 = df.loc[1200:1399] #third midline
ELM = df.loc[1400:1499] #ear and leg movement
EL = df.loc[1500:1699] #ear down and leg extension
FIN = df.loc[1700:1799] #final return to midline

headers = list(df.columns.values) #We seem to have a problem with not having consistent data names.
data_name = headers[1] #This method should always get the name of the data (since it's always col2)
headers = None

baseline = np.mean(base[0:51][data_name])  #Calculation of baseline and thresholds
up_thresh = 1.20*baseline
down_thresh = 0.8*baseline

n=200 #start of ear down movement
pos_epeaks1 = []
pos_ipeaks1 = []

while n <= 501: #this is because python has exclusive upper bounds. Only looking at movement to ear down
	ma = df[n:n+5][data_name]
	u, p = stats.mannwhitneyu(ma,base[0:51][data_name]) #MannWhitney Test...only proceed if sig
	if p <= 0.05:
		if np.mean(ma) >= up_thresh:
			#print("Potential Excitation Peak at t=" + str(n/100.0) + " U=" + str(u))
			pos_epeaks1.append(n)
		elif np.mean(ma) <= down_thresh:
			#print("Potential Inhibition Peak at t=" + str(n/100.0)+ " U=" + str(u))
			pos_ipeaks1.append(n)
		else:
			print("Significant, but not over 20% threshold")
	#else:
	#	print("Not significant")
	n += 1
Epeakt = 0
Epeak = 0 
Eabs_dif = 0

for x in pos_epeaks1:
	mean =  np.mean(df[x:x+5][data_name])
	#print(x,mean,np.absolute(baseline-mean))
	if mean > Epeak: 
		Epeak = mean 
		Epeakt = x
Eabs_dif=None
Ipeakt = 0
Ipeak = 0 
Iabs_dif = 0
for x in pos_ipeaks1:
	mean =  np.mean(df[x:x+5][data_name])
	if mean < Ipeak:
		Ipeak = mean 
		Ipeakt = x
peaktype=""
peaktime = 0
if np.absolute(baseline-Epeak) > np.absolute(baseline-Ipeak):
	peaktype = "Excitation"
	peaktime = Epeakt
	print(peaktype, peaktime)
if np.absolute(baseline-Epeak) < np.absolute(baseline-Ipeak):
	peaktype = "Inhibition"
	peaktime = Ipeakt
	print(peaktype, peaktime)


