### Vehicle-Dynamics-Toolkit
Some advanced tools for race car design - Steady state and transient dynamics, Tyre Data synthesis
This toolkit isn't centralized like the premium Vehicle Dynamics softwares, but has the flexibility and model transperancy. The user can easily add/remove hyper-parameters from the models as per the complexity they would like to work with. For now there are 3 modules:
1. Steady State Sim
2. Transient Response Sim
3. Tyre Data Processing

## 1. Steady State
# NONLIN_52.M
This is a GUI that simulates the **ISO 4138** Constant Radius Test on a 3 DoF vehicle model. The 3 DoF(s) at the vehicle's center of gravity as per SAE Convention being:
1. Along Y axis - Side-slip
2. About Z axis - Yaw
3. About X axis - Roll

This is 4 wheel model with 3 DoF(s) also applying to each tyre. It runs on Pacejka's 5.2 Tyre model (hence the '52'). Please note that the user will have to fit their own 5.2 model of the tyre they wish to use, the fitting can be done in `tire_data_52` folder. The instructions, code and a sample FSAE TTC tyre data is available there^^.

![Constant Radius Test Customizable GUI](Nonlin52.png)



^^I don't own the FSAE TTC Tyre test data. The tests were conducted by Calspan in collaboration with TTC and all the data is available for free on http://fsaettc.org
