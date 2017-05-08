%Program to plot a low temperature simplified psychrometric chart
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
hold on;
%% Section to plot the SHF protractor
% x0=-54; %positions at which the SHF protractor is drawn from 
% y0=2.25e-3;
% for shf=0.9:-0.1:0.2 %left half portion of shf
%     delta_t=4.0; %assuming temp. diff.
%     delta_w=(1.0216*delta_t/2501)*(1/shf-1); %calc. sp. humidity diff.
%     x1=x0-5.0*(5.0-delta_t); %end points of the shf line
%     y1=y0-delta_w;
%     figure(6);
%     plot([x0 x1],[y0 y1],'k-'); %plotting the shf line
%     hold on;
% end
% for shf=1.1:0.1:4.0 %right half portion of shf
%     delta_t=4.0; 
%     delta_w=(1.0216*delta_t/2501)*(1/shf-1);   
%     x2=x0+5.0*(5.0-delta_t); 
%     y2=y0+delta_w;
%     figure(6);
%     plot([x2 x0],[y2 y0],'k-');
%     hold on;
% end
annotation(figure(6),'ellipse',...
    [0.212566617862372 0.767034774436087 0.102953147877013 0.143092105263156],...
    'LineWidth',2,...
    'Color',[0.235294118523598 0.235294118523598 0.235294118523598]);
annotation(figure(6),'line',[0.213762811127379 0.315519765739385],...
    [0.844888529167162 0.845888529167162]);
annotation(figure(6),'line',[0.262811127379209 0.218887262079063],...
    [0.841105263157894 0.805921052631579]);
annotation(figure(6),'line',[0.262811127379209 0.232064421669107],...
    [0.84375 0.779605263157895]);
annotation(figure(6),'line',[0.264275256222548 0.243045387994143],...
    [0.841105263157894 0.773026315789473]);
annotation(figure(6),'line',[0.262811127379209 0.248901903367496],...
    [0.841105263157894 0.766447368421052]);
annotation(figure(6),'line',[0.262811127379209 0.253294289897511],...
    [0.837815789473684 0.763157894736842]);
annotation(figure(6),'line',[0.262811127379209 0.256954612005857],...
    [0.841105263157894 0.761513157894737]);
annotation(figure(6),'line',[0.263543191800879 0.311127379209371],...
    [0.84275 0.810855263157895]);
annotation(figure(6),'line',[0.265007320644217 0.304538799414348],...
    [0.839460526315789 0.791118421052631]);
annotation(figure(6),'line',[0.262811127379209 0.293557833089312],...
    [0.842105263157895 0.776315789473684]);
annotation(figure(6),'line',[0.264275256222548 0.288433382137628],...
    [0.839460526315789 0.769736842105263]);
annotation(figure(6),'line',[0.263543191800879 0.281844802342606],...
    [0.839460526315789 0.766447368421052]);
annotation(figure(6),'line',[0.263543191800879 0.275988286969253],...
    [0.837815789473684 0.768092105263157]);
annotation(figure(6),'line',[0.264275256222548 0.27086383601757],...
    [0.834526315789473 0.766881757158132]);
text(-56.5,2.35e-3,'SHF Scale','FontWeight','bold');
annotation(figure(6),'textbox',...
    [0.189888888888889 0.832592592592592 0.0241851851851852 0.032592592592592],...
    'String',{'1.0'},...
    'FontSize',9,...
    'FontName','Times New Roman',...
    'FitBoxToText','off',...
    'LineStyle','none');
annotation(figure(6),'textbox',...
    [0.318777777777777 0.831851851851851 0.0241851851851852 0.032592592592592],...
    'String',{'1.0'},...
    'FontSize',9,...
    'FontName','Times New Roman',...
    'FitBoxToText','off',...
    'LineStyle','none');
annotation(figure(6),'textbox',...
    [0.198777777777778 0.775555555555554 0.0241851851851852 0.032592592592592],...
    'String',{'0.9'},...
    'FontSize',9,...
    'FontName','Times New Roman',...
    'FitBoxToText','off',...
    'LineStyle','none');
annotation(figure(6),'textbox',...
    [0.310485385825064 0.794116790870982 0.0241851851851852 0.0365781710914427],...
    'String',{'1.1'},...
    'FontSize',9,...
    'FontName','Times New Roman',...
    'FitBoxToText','off',...
    'LineStyle','none');
annotation(figure(6),'textbox',...
    [0.213618621549807 0.758498852835134 0.0241851851851852 0.032592592592592],...
    'String',{'0.8'},...
    'FontSize',9,...
    'FontName','Times New Roman',...
    'FitBoxToText','off',...
    'LineStyle','none');
annotation(figure(6),'textbox',...
    [0.302666937801638 0.760842454587797 0.0241851851851852 0.0365781710914427],...
    'String',{'1.2'},...
    'FontSize',9,...
    'FontName','Times New Roman',...
    'FitBoxToText','off',...
    'LineStyle','none');
annotation(figure(6),'textbox',...
    [0.281671330188168 0.737552980903586 0.0241851851851852 0.0365781710914427],...
    'String',{'1.6'},...
    'FontSize',9,...
    'FontName','Times New Roman',...
    'FitBoxToText','off',...
    'LineStyle','none');
annotation(figure(6),'textbox',...
    [0.259943658153029 0.730710875640427 0.0241851851851852 0.0365781710914427],...
    'String',{'-4.0'},...
    'FontSize',9,...
    'FontName','Times New Roman',...
    'FitBoxToText','off',...
    'LineStyle','none');
annotation(figure(6),'textbox',...
    [0.233618621549807 0.738498852835134 0.0241851851851852 0.032592592592592],...
    'String',{'0.6'},...
    'FontSize',9,...
    'FontName','Times New Roman',...
    'FitBoxToText','off',...
    'LineStyle','none');
annotation(figure(6),'textbox',...
    [0.247762106176454 0.734946221256186 0.0241851851851852 0.032592592592592],...
    'String',{'0.2'},...
    'FontSize',9,...
    'FontName','Times New Roman',...
    'FitBoxToText','off',...
    'LineStyle','none');
print(figure(6),'Psychrometric Chart','-djpeg','-r300');