%195-305, 495-605, 795-905, 1095-1205, 1395-1505, 1695-1805
[start, stop, baseline,response_mean] = newleg(195);
A = [start, stop, baseline,response_mean];
[start, stop, baseline,response_mean] = newleg(495);
B = [start, stop, baseline,response_mean];
[start, stop, baseline,response_mean] = newleg(795);
C = [start, stop, baseline,response_mean];
[start, stop, baseline,response_mean] = newleg(1095);
D = [start, stop, baseline,response_mean];
[start, stop, baseline,response_mean] = newleg(1395);
E = [start, stop, baseline,response_mean];
[start, stop, baseline,response_mean] = newleg(1695);
F = [start, stop, baseline,response_mean];

df = vertcat(A,B,C,D,E,F);
clearvars start stop baseline response_mean A B C D E F

xlswrite(filename, df);