addpath([pwd '/Scripts_Data']);
addpath([pwd '/Images']);
addpath([pwd '/CAD_Geometry']);
TNO_Vehicle_PARAM


TNOtbx6p2_pth=GetTNODelftTyrePath;
if(exist(TNOtbx6p2_pth)==7)
    addpath(TNOtbx6p2_pth)
    disp('TNO Delft-Tyre MATLAB Toolbox added to MATLAB path:');
    disp(TNOtbx6p2_pth);
    
	addpath(strrep(TNOtbx6p2_pth,'\MATLAB\Toolbox','\Road data files'))
	addpath(strrep(TNOtbx6p2_pth,'\MATLAB\Toolbox','\Tyre property files'))
    Extr_Data_RDF

    open_system('Vehicle_Dynamics_Tests.slx');
else
    open_system('Vehicle_Dynamics_Tests_NoDelftTyre.slx');
end

% Copyright 2014 The MathWorks, Inc.

