%Leg Automation
%Last Update: 10/2/15

function [peaktimes,peakmags] = newleg(n)
filename = 'C:\Users\McCall Lab\Dropbox\McCall C75-76\C76 - Bertha\C76-14_Bertha_Raw-Data\C76-14_Bertha_Data_May_2015\C76-14_Bertha_05.22.2015\Int Text\0.01 bins\1.3 Cell 1 7a.txt';
df = importdata(filename, '\t', 1);
baseline = df.data(51:151,2);
base_mean = mean(baseline);
thresh_up = 1.2*base_mean;
thresh_down = 0.8*base_mean;

pos_epeaks1 = [];
pos_ipeaks1 = [];
maxcount=n+301;
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
      
  else 
       %disp(pos_ipeaks1)
       %disp(pos_epeaks1)
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
        %disp(Epeak)
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
%peaktime=0;
%something is going on with the empty ipeak array here 
%disp(abs(baseline-Ipeak))
disp(base_mean)
disp('baseline')
if abs(base_mean-Epeak) > abs(base_mean-Ipeak)
		peaktype = 'Excitation';
        %disp(peaktype)
		peaktime = Epeakt;
        %disp(peaktime)
		peakmag = abs(base_mean-Epeak);
       % disp(peakmag)
		disp([peaktype, peaktime, peakmag])
		peaktimes = [peaktimes peaktime];
		peakmags = [peakmags peakmag];
		clearvars peakmag peaktype peaktime
end

if abs(base_mean-Epeak) < abs(base_mean-Ipeak)
		peaktype = 'Inhibtion';
		peaktime = Ipeakt;
		peakmag = abs(base_mean-Ipeak);
		%disp([peaktype, peaktime, peakmag])
		peaktimes = [peaktimes peaktime];
		peakmags = [peakmags peakmag];
		clearvars peakmag peaktype peaktime
end
disp(peaktimes)
end
