%MATLAB Program to plot a low temperature simplified psychrometric chart
%% Section to plot the saturation line of 100% RH
clc;
clear all;
format long
prop=xlsread('Thermodynamic prop.xlsx'); %reading thermodynamic properties from excel file
t_a=prop(:,1); %dry bulb temperature (deg C)
p_s=prop(:,2); %saturated vapour pressure (kN/m^2)
v_sp=prop(:,3); %specific volume of moist air (m^3/kg)
h_f=prop(:,4); %enthalpy of saturated water (kJ/kg)
w_s=(0.62198*p_s*1000)/(101325-(1000*p_s)); %saturated specific humidity
w_s=w_s(:,1);
figure(1);
plot(t_a,w_s,'Color',[0 0.5 0],'LineWidth',2); %plotting saturation line of 100% RH - Green
grid on;
grid minor;
axis([-60 0 0 2.5e-3]);
xlabel('Dry bulb temperature (deg C)','FontSize',12,'FontName','Times New Roman','FontWeight','bold');
ylabel('Specific Humidity (kg/kg)','FontSize',12,'FontName','Times New Roman','FontWeight','bold');
set(gca,'yaxislocation','right');
title('Plot of saturation line','FontSize',15,'FontName','Times New Roman','FontWeight','bold');
print(figure(1),'Saturation_Line','-djpeg','-r300');
figure(6);
fullfig(figure(6));
plot(t_a,w_s,'Color',[0 0.5 0],'LineWidth',2); %plotting saturation line of 100% RH - Green
hold on; %holds the figure for plotting next portions
grid on; %plotting grid lines
grid minor;
xlabel('Dry bulb temperature (deg C)','FontSize',12,'FontName','Times New Roman','FontWeight','bold');
ylabel('Specific Humidity (kg/kg)','FontSize',12,'FontName','Times New Roman','FontWeight','bold');
set(gca,'yaxislocation','right');
title('Psychrometric chart','FontSize',15,'FontName','Times New Roman','FontWeight','bold');
axis([-65 0 0 2.5e-3]); %limits of x- and y-axis

%%  Section to plot constant RH lines 
for rh=0.1:0.1:0.9 %varying rh from 10% to 90%
    p_v=rh*p_s; %vapour pressure
    w=(0.62198*p_v*1000)/(101325-(1000*p_v)); %specific humidity at a constant RH
    figure(2);
    plot(t_a,w,'g-','Color',[0 0.5 0],'LineWidth',2); %plotting constant RH lines from 10% to 90% RH - Green
    grid on;
    grid minor;
    axis([-60 0 0 2.5e-3]);
    xlabel('Dry bulb temperature (deg C)','FontSize',12,'FontName','Times New Roman','FontWeight','bold');
    ylabel('Specific Humidity (kg/kg)','FontSize',12,'FontName','Times New Roman','FontWeight','bold');
    set(gca,'yaxislocation','right');
    title('Plot of Constant RH lines','FontSize',15,'FontName','Times New Roman','FontWeight','bold');
    hold on;
    figure(6);
    plot(t_a,w,'g-','Color',[0 0.5 0]); %plotting constant RH lines from 10% to 90% RH - Green
    grid on;
    grid minor;
    hold on;
end
figure(2);
text(-4,0.25e-3,'10%');
text(-5,0.5e-3,'20%');
text(-6,0.7e-3,'30%');
text(-9,0.9e-3,'50%');
text(-11,1.1e-3,'70%');
text(-13,1.3e-3,'90%');
print(figure(2),'Constant RH lines','-djpeg','-r300');
figure(6);
text(-4,0.25e-3,'10%','Color',[0 0.5 0]);
text(-5,0.5e-3,'20%','Color',[0 0.5 0]);
text(-6,0.7e-3,'30%','Color',[0 0.5 0]);
text(-9,0.9e-3,'50%','Color',[0 0.5 0]);
text(-11,1.1e-3,'70%','Color',[0 0.5 0]);
text(-12,1.3e-3,'90%','Color',[0 0.5 0]);
%% Section to plot constant volume lines
%adopting an iterative procedure 
for v_sq=0.61:0.01:0.77 %varying vol. from 0.61 m^3/kg to 0.77 m^3/kg
    t_s0=interp1(v_sp,t_a,v_sq); %guessed (interpolated) value of satd. temp
    diff=1.0; %assumed difference
    while diff>3e-6
        p_s0=interp1(t_a,p_s,t_s0); %value of satd. pressure at that satd. temp (interpolated)
        v_s0=(287.1*(t_s0+273.15))/(101325-(1000*p_s0)); %recalc. sp. volume
        diff=abs(v_s0-v_sq); %absolute error b/w true sp. volume and approx. one
        if diff<3e-6 
            break;
        elseif v_s0>v_sq
            t_s0=t_s0-0.001; %decrementing satd. temp
            continue;
        else
            t_s0=t_s0+0.001; %incrementing satd. temp
            continue; %continues the loop
        end
    end
    w_sp=0.62198*(1000*p_s0)/(101325-(1000*p_s0)); %satd. humidity at const. volume
    t_0=(101325*v_sq)/287.3-273.15; %temp at 0 humidity along the const. sp. volume line
    figure(3);
    plot([t_s0,t_0],[w_sp,0],'b-','LineWidth',2); %plotting constant volume lines
    grid on;
    grid minor;
    axis([-60 0 0 3.5e-3]);
    xlabel('Dry bulb temperature (deg C)','FontSize',12,'FontName','Times New Roman','FontWeight','bold');
    ylabel('Specific Humidity (kg/kg)','FontSize',12,'FontName','Times New Roman','FontWeight','bold');
    set(gca,'yaxislocation','right');
    title('Plot of Constant specific volume lines','FontSize',15,'FontName','Times New Roman','FontWeight','bold');
    hold on;
    figure(6);
    plot([t_s0,t_0],[w_sp,0],'b-','LineWidth',2); %plotting constant volume lines
    hold on;
    grid on;
    grid minor;
end
figure(3);
text(-6,3.1e-3,'0.77 m^3/kg');
text(-7,2.5e-3,'0.76 m^3/kg');
text(-11,2e-3,'0.75 m^3/kg');
text(-14,1.4e-3,'0.74 m^3/kg');
text(-18,1e-3,'0.73 m^3/kg');
text(-25,0.5e-3,'0.71 m^3/kg');
text(-32,0.4e-3,'0.69 m^3/kg');
text(-40,0.2e-3,'0.67 m^3/kg');
text(-46,0.1e-3,'0.65 m^3/kg');
text(-58,0.08e-3,'0.61 m^3/kg');
print(figure(3),'Constant specific volume lines','-djpeg','-r300');
figure(6);
text(-3,2e-3,'0.77 m^3/kg','rotation',90,'Color',[0 0 1],'FontWeight','bold');
text(-6,1.25e-3,'0.76','rotation',90,'Color',[0 0 1],'FontWeight','bold');
text(-10,1.25e-3,'0.75','rotation',90,'Color',[0 0 1],'FontWeight','bold');
text(-13,1e-3,'0.74','rotation',90,'Color',[0 0 1],'FontWeight','bold');
text(-17,0.675e-3,'0.73','rotation',90,'Color',[0 0 1],'FontWeight','bold');
text(-24,0.3e-3,'0.71','rotation',90,'Color',[0 0 1],'FontWeight','bold');
text(-31,0.05e-3,'0.69','rotation',90,'Color',[0 0 1],'FontWeight','bold');
%% Section to plot constant WBT lines
for t_s0=-60:0 %varying satd. dbt from -60 to 0
    h_fs=interp1(t_a,h_f,t_s0); %interpolated enthalpy of satd. water from tables
    p_s0=interp1(t_a,p_s,t_s0); %interpolated satd. vap pressure
    w_s0=0.62198*(1000*p_s0)/(101325-(1000*p_s0)); %satd. humidity
    h_s0=(1.006+1.805*w_s0)*t_s0+(2501*w_s0); %satd. humidity along constant WBT line
    sigma_fn=h_s0-(w_s0*h_fs); %calc. sigma heat function
    t_0=sigma_fn/1.006; %temp at 0 humidity along constant WBT line
    figure(4);
    plot([t_s0,t_0],[w_s0,0],'r-','LineWidth',2); %plot the line
    hold on;
    grid on;
    grid minor;
    axis([-60 0 0 2.5e-3]);
    xlabel('Dry bulb temperature (deg C)','FontSize',12,'FontName','Times New Roman','FontWeight','bold');
    ylabel('Specific Humidity (kg/kg)','FontSize',12,'FontName','Times New Roman','FontWeight','bold');
    set(gca,'yaxislocation','right');
    title('Plot of Constant WBT lines','FontSize',15,'FontName','Times New Roman','FontWeight','bold');
    figure(6);
    plot([t_s0,t_0],[w_s0,0],'r-'); %plot the line
    grid on;
    grid minor;
    hold on;
end
print(figure(4),'Constant WBT lines','-djpeg','-r300');
%% Section to plot constant enthalpy lines (rather than enthalpy deviation)
for h=-60:5 %range of enthalpy variation
    t_0=h/1.006; %temp at 0 humidity along constant enthalpy line
    p=[8.1225e-5 1.12387 7.377795-h]; %polynomial(enthalpy) as a function of dbt 
    t=roots(p); %finding the roots of the above polynomial
    if(t(1)<0 && t(1)>-60) %only the temp. which lies in this range is reliable
        t1=t(1);
    else
        t1=t(2);
    end
    w1=4.5e-5*t1+2.95e-3; %enthalpy axis eqn.
    figure(5);
    if rem(h,5)==0 %solid lines for enthalpies which are multiples of 5
        plot([t_0,t1],[0,w1],'k-','LineWidth',2);
    else
        plot([t_0,t1],[0,w1],'k--'); %dashed lines 
    end
    grid on;
    grid minor;
    axis([-65 0 0 2.5e-3]);
    xlabel('Dry bulb temperature (deg C)','FontSize',12,'FontName','Times New Roman','FontWeight','bold');
    ylabel('Specific Humidity (kg/kg)','FontSize',12,'FontName','Times New Roman','FontWeight','bold');
    set(gca,'yaxislocation','right');
    title('Plot of Constant Enthalpy lines','FontSize',15,'FontName','Times New Roman','FontWeight','bold');
    hold on;
    figure(6);
    if rem(h,5)==0 %solid lines for enthalpies which are multiples of 5
        plot([t_0,t1],[0,w1],'k-','LineWidth',2);
    else
        plot([t_0,t1],[0,w1],'k--'); %dashed lines 
    end
    grid on;
    grid minor;
    hold on;
end
figure(5);
plot([-60 -10],[0.25e-3 2.5e-3],'k-','LineWidth',2); %plotting the anthalpy axis
text(-65,0.35e-3,'-60 KJ/kg');
text(-57,0.55e-3,'-55');
text(-53,0.7e-3,'-50');
text(-49,0.9e-3,'-45');
text(-45,1.1e-3,'-40');
text(-40,1.3e-3,'-35');
text(-35,1.5e-3,'-30');
text(-30,1.75e-3,'-25');
text(-26,1.95e-3,'-20');
text(-22,2.15e-3,'-15');
text(-18,2.3e-3,'-10');
print(figure(5),'Constant Enthalpy line','-djpeg','-r300');
figure(6);
plot([-60 -10],[0.25e-3 2.5e-3],'k-','LineWidth',2); %plotting the anthalpy axis
text(-62,0.35e-3,'-60 KJ/kg','FontWeight','bold','rotation',23);
text(-57,0.55e-3,'-55','FontWeight','bold','rotation',23);
text(-53,0.7e-3,'-50','FontWeight','bold','rotation',23);
text(-49,0.9e-3,'-45','FontWeight','bold','rotation',23);
text(-45,1.1e-3,'-40','FontWeight','bold','rotation',23);
text(-40,1.3e-3,'-35','FontWeight','bold','rotation',23);
text(-35,1.5e-3,'-30','FontWeight','bold','rotation',23);
text(-30,1.75e-3,'-25','FontWeight','bold','rotation',23);
text(-26,1.95e-3,'-20','FontWeight','bold','rotation',23);
text(-22,2.15e-3,'-15','FontWeight','bold','rotation',23);
text(-18,2.3e-3,'-10','FontWeight','bold','rotation',23);
text(-35,0.0018,'Enthalpy (kJ/kg) dry air','FontWeight','bold','rotation',23);
text(-26.1,0.57e-3,'Wet Bulb and Dew Point or Saturation Temperatures','FontWeight','bold','rotation',40);
print(figure(6),'Psychrometric Chart','-djpeg','-r300');