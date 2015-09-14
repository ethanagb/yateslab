import pandas as pd
import numpy as np
from scipy import stats

in_data = pd.read_csv(r"/Users/Ethan/Documents/code/yateslab/2.3 Cell 1 7a.txt",sep='\t')
df = pd.DataFrame(in_data)
#in_data = None
def peakfind(a,b,c):
	starts = []
	starts.append(int(a))
	starts.append(int(b))
	starts.append(int(c))

	headers = list(df.columns.values) #We seem to have a problem with not having consistent data names.
	data_name = headers[1] #This method should always get the name of the data (since it's always col2)
	headers = None

	baseline = np.mean(base[0:51][data_name])  #Calculation of baseline and thresholds
	up_thresh = 1.20*baseline
	down_thresh = 0.8*baseline

	for i in starts:
		n=i #start of ear down movement
		pos_epeaks1 = []
		pos_ipeaks1 = []

		while n <= n+301: #this is because python has exclusive upper bounds. Only looking at movement to ear down
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

#Now you want to do this all over again 2 more times for t=8(n=800) to n=1101, and 1400-1701. 
#Then compare size of peaks (???)
