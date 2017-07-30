%% Just a little trick to save layouts from one machine to another
% Running this script saves all your IDE layouts and loads all of the saved
% layouts into matlab.
%
% Author: Adam Gaier
% Bonn-Rhein-Sieg University of Applied Sciences (HBRS)
% email: adam.gaier@h-brs.de
% May 2016; Last revision: 16-Ma-2016
%
%------------- BEGIN CODE --------------


% One you have created some IDE layout you like you can save it into this
% folder with:

sourceLayout =  [prefdir '/*Layout.xml'];
layoutFolder =  '';
system(['cp ' sourceLayout ' ' layoutFolder]);

% Then when you start using a new machine you can load all of your layouts
% by running this line.

system(['cp ' layoutFolder '*Layout.xml ' prefdir]);

% Next time you restart Matlab all of your IDE layouts will be available