# Low-Temperature-Simplified-Psychrometric-Chart

The current study attempts to construct a low temperature psychrometric chart whose dry bulb temperature varies from -60 °C to 0 °C at 
constant atmospheric pressure. This purpose has been accomplished through the numerical code developed in MATLAB, with the thermodynamic 
ASHRAE data imported from a file. 

**Program 1: Contruction_Psychor_chart_MATLAB** -
This is the main code necessary for plotting the psychrometric chart

**fullfig** -
A function called by the **Contruction_Psychor_chart_MATLAB** for obtaining the full view of the psychrometric chart. Available in 
MATLAB file exchange [1] 
- After running the code (**Contruction_Psychor_chart_MATLAB.m**), wait till all the necessary figures and plots are generated (6 figures). 
- For your reference, the same generated figures from this code are exported as .jpg files in the folder after the 
code runs, which can be seen for a clear view. 

**Program 2: Saturation_press_deviations** -
This code is required to calculate the saturation vapour pressure of water from ASHRAE table and an empirical correlation. The deviation
between these values is also calculated to establish the reliance of correlations in future works.
After running this code, the saturation vapour pressure deviations in the range of DBT -60 C to 0 C is exported to Saturation Pressure Deviations.dat for the detailed values and comparisons. 

**Validation of the developed code**
- Validation of the specific volume lines and enthalpy lines with reference chart [2]. Percentage deviations of these values were found to lie in the absolute range of 0.555 % to 2.4555 %. 

**_To be worked upon/Improved_**
A reliable method of plotting the SHF lines/protractor is necessary. In the current work, a guess strategy (inaccurate) has been used. 

**References**
1. https://in.mathworks.com/matlabcentral/fileexchange/48071-fullfig
2. -50 °C Industrial Chart by Akton Psychrometrics available at www.aktonassoc.com
