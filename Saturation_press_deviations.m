%Program to find the deviations between the saturation pressures of ASHRAE
%table and correlation from Hyland and Wexler 1983 - Appendix
clc;
clear all;
format long
p_s_correlation = zeros(61,1);
perc_diff = zeros(61,1);
prop=xlsread('Thermodynamic prop.xlsx');
t_a=prop(:,1); %dry bulb temperature (deg C)
p_s=prop(:,2); %saturated vapour pressure (kN/m^2)
c1=-5.6745359e3; %empirical constants of the correlation
c2=6.3925247;
c3=-9.6778430e-03;
c4=6.2215701e-7;
c5=2.0747825e-9;
c6=-9.4840240e-13;
c7=4.1635019;
fid=fopen('Saturation Pressure Deviations.dat','w');
fprintf(fid,'Saturated DBT (C) \t Saturated Pressure from ASHRAE table(kN/m^2) \t Saturated Pressure from correlation(kN/m^2) \t Percentage Deviation between correlation and ASHRAE \n');
T_a=t_a+273.15;
for i=1:61
    p_s_correlation(i) = exp(c1/T_a(i)+c2+c3*T_a(i)+c4*T_a(i)*T_a(i)+c5*power(T_a(i),3)+c6*power(T_a(i),4)+c7*log(T_a(i)))*power(10,-3);
    perc_diff(i)=(p_s_correlation(i)-p_s(i))*100/p_s(i);
    fprintf(fid,'%f\t %f\t %f\t %f\n',t_a(i),p_s(i),p_s_correlation(i),perc_diff(i));
end
fclose(fid);
fclose('all');
max=max(abs(perc_diff));
min=min(abs(perc_diff));
fprintf('Maximum Percentage Deviation = %f\n',max);
fprintf('Minimum Percentage Deviation = %f\n',min);
