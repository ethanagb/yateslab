%Leg Automation
%Last Update: 10/2/15

function [y,peak_end2,base_mean,response_avg] = newleg(n)
%FOR TESTING ONLY:
%n=200; %195-305, 495-605, 795-905, 1095-1205, 1395-1505, 1695-1805
%%%%%%%%%%%%
filename = '/Users/Ethan/Downloads/2.3 Cell 1 7a.txt';
df = importdata(filename, '\t', 1);
baseline = df.data(51:200,2);
base_mean = mean(baseline);
thresh_up = 1.2*base_mean;
thresh_down = 0.8*base_mean;

pos_epeaks1 = [];
pos_ipeaks1 = [];
maxcount=n+300;
n=n-2;
starting_n = n;
while n+5 <= maxcount
  avg = df.data(n:n+5,2);
  [p,~,~] = ranksum(avg,baseline);
  if p <= 0.05
      if mean(avg) >= thresh_up
          %disp('!')
          pos_epeaks1 = [pos_epeaks1 n];
          
      elseif mean(avg) <= thresh_down
        % disp(strcat(num2str(n),' Sig and True'))
        pos_ipeaks1 = [pos_ipeaks1 n];
      else
          disp(strcat(num2str(n),' Sig and False'))
      end 
  end
  n = n+1;
end
Epeakt = 0;
Epeak = 0 ;
Eabs_dif = 0;
Ipeakt = 0;
Ipeak = 0 ;
Iabs_dif = 0;
for i = pos_epeaks1
   avg =  mean(df.data(i:i+5,2));
   %disp(i)
  %disp(avg)
   if avg > Epeak
        Epeak = avg;
		Epeakt = i;
        end
   
end 
if numel(pos_ipeaks1) > 0
    for i = pos_ipeaks1
       avg =  mean(df.data(i:i+5,2));
       disp(i)
       disp(avg)
       if avg > Ipeak
            Ipeak = avg;
            Ipeakt = i;
       end
    end
else
    Ipeak=0;
    Ipeakt=0;
end 
peaktimes=[];
peakmags=[];
disp(base_mean)
disp('baseline')
if abs(base_mean-Epeak) > abs(base_mean-Ipeak)
		peaktype = 'Excitation';
      	peaktime = Epeakt;
        peakmag = abs(base_mean-Epeak);
		peaktimes = [peaktimes peaktime];
		peakmags = [peakmags peakmag];
		clearvars peakmag peaktype peaktime
end

if abs(base_mean-Epeak) < abs(base_mean-Ipeak)
		peaktype = 'Inhibtion';
		peaktime = Ipeakt;
		peakmag = abs(base_mean-Ipeak);
		peaktimes = [peaktimes peaktime];
		peakmags = [peakmags peakmag];
		clearvars peakmag peaktype peaktime
end
disp(peaktimes)

n=5;
p=0;
movingmean=3*base_mean;
%disp('HERE')
%disp(movingmean)
while movingmean > 1.2*base_mean && n < cast(peaktimes,'int64')
    peak_end = cast(peaktimes,'int64');
    peak_start = cast(peak_end,'int64')-n;
    peak_end2 = peak_start + 5;
    window = df.data(peak_start:peak_end2);
    movingmean = mean(window);
     n=n+1;
disp(peak_start)
y = peak_start;
movingmean=3*base_mean;
while movingmean > 1.2*base_mean && n < cast(peaktimes,'int64')
    peak_end = cast(peaktimes,'int64');
    peak_start = cast(peak_end,'int64')+n;
    peak_end2 = peak_start + 5;
    window = df.data(peak_start:peak_end2);
    movingmean = mean(window);
    n=n+1;
end 
disp(peak_end2);
end
%if less/greater than response, set to max/min of region
%there are max ranges, if threshold is exceeded for a range beyond this.
%set a limit. 
if y < starting_n
    y=starting_n;
end
disp('n=')
disp(starting_n)
if peak_end2 > starting_n+300
    peak_end2 = starting_n+300;
end
disp('Response start:')
disp(y)
disp('Response end:')
disp(peak_end2)
response_avg = mean(df.data(y:peak_end2,2));
end




