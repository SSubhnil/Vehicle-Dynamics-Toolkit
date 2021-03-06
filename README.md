## Vehicle-Dynamics-Toolkit
Some advanced tools for race car design - Steady state and transient dynamics, Tyre Data synthesis
This toolkit isn't centralized like the premium Vehicle Dynamics softwares, but has the flexibility and model transperancy. The user can easily add/remove hyper-parameters from the models as per the complexity they would like to work with. For now there are 3 modules:
1. Steady State Sim
2. Transient Response Sim
3. Tyre Data Processing

### 1. Steady State
#### NONLIN_52.M
This is a GUI that simulates the **ISO 4138** Constant Radius Test on a 3 DoF vehicle model. The 3 DoF(s) at the vehicle's center of gravity as per SAE Convention being:
1. Along Y axis - Side-slip
2. About Z axis - Yaw
3. About X axis - Roll

This is 4 wheel model with 3 DoF(s) also applying to each tyre. It runs on Pacejka's Magic Formula 5.2 Tyre model (hence the '52'). Please note that the user will have to fit their own MF 5.2 model of the tyre they wish to use, the fitting can be done in `tire_data_52` folder. The instructions, code and a sample FSAE TTC tyre data is available there^^.

![Constant Radius Test Customizable GUI](Nonlin52.PNG)

This GUI is based off of Bill Cobb's work^ on VD and the original `nonlin.m` which is a simple bicycle model. See Race Car Vehicle Dynamics for the equations. 
 
#### Constant Velocity Sim
Will be adding this soon.

### 2. Transient Response
#### VHSIM.m
Based off of Bill Cobb's `VHSIM.m`. This is a 2 DoF model. An updated version with the *Roll* DoF will be available soon.

![Transient Response GUI](VHsim_1.PNG)


^^I don't own the FSAE TTC Tyre test data. The tests were conducted by Calspan in collaboration with TTC and all the data is available for free on http://fsaettc.org
^The link for Bill's work isn't directly available. Interested people can look it up in FSAE Forums. Must be a Google Drive link provided on Bill's discretion. 
