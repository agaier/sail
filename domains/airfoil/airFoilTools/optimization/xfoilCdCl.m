function [cD, cL] = xfoilCdCl(coord,AOA,RE,MACH,varargin)
%xFoilCdCl - returns Cd/Cl results of an airfoil determined by xfoil
%
% Syntax:  [output1,output2] = function_name(input1,input2,input3)
%
% Inputs:
%    coord - [NX2] x,y coordinates from top of trailing edge anti-clockwise
%    AOA   - [scalar] angle of attack in degrees
%    RE    - [scalar] Reynolds number
%    MACH  - [scalar] Speed in Mach
% varargin - [string] additional commands
%
% Outputs:
%    cD - Coefficient of Drag
%    cL - Coefficient of Lift
%
% Example:
% MACH = 0.5;
% AOA  = 2.7;
% RE = 1e6;
% [cD, cL] = xfoilCdCl(coord', AOA, RE, MACH,'pane oper iter 50');
%
%
% See also: xfoilEvaluate,  xfoil

% Author: Adam Gaier
% Bonn-Rhein-Sieg University of Applied Sciences (HBRS)
% email: adam.gaier@h-brs.de
% Jul 2016; Last revision: 25-Jul-2016

%------------- BEGIN CODE --------------

%% Move to tmp folder and set file names
wd = '/tmp/xfoil'; if ~exist(wd,'dir');system(['mkdir ' wd]); end; cd(wd);

[status, result] = system(['cd ' wd]);
if (status~=0), disp(result); disp(['no directory in: ' wd]); end

ID = [int2str(randi(100000))];
fName = ['xfoil' ID];
fNameCoord =    [fName '.foil'];
fNameCommmand = [fName '.inp'];
fNamePolar =    [fName '.dat'];
cD = nan; cL = nan;

%% Write Coordinate and Command Files
% Coordinates
fid = fopen(fNameCoord,'w');
if (fid<=0); error([mfilename ':io'],'Unable to create file %s',fNameCoord);
    unix(['rm ' fName '*']);  return;
else
    fprintf(fid,'%s\n',ID);
    fprintf(fid,'%9.5f   %9.5f\n',coord');
    fclose(fid);
end

% Commands
fid = fopen([wd '/' fNameCommmand],'w');
if (fid<=0); error([mfilename ':io'],'Unable to create file %s',fNameCommmand);
    unix(['rm ' fName '*']); 
    return;
else
    fprintf(fid,'\n\nplop\ng\n\n');         % Disable graphics
    fprintf(fid,'load %s\n',fNameCoord);    % Load Foil
    
    % Additional Commands
    for ii = 1:length(varargin)
        txt = regexprep(varargin{ii},'[ \\\/]+','\n');
        fprintf(fid,'%s\n',txt);
    end
    
    fprintf(fid,'re %g\n',RE);          % Reynolds Number  
    fprintf(fid,'mach %g\n',MACH);      % Mach Number
    fprintf(fid,'visc\n');              % Viscous Mode
    fprintf(fid,'pacc\n\n\n');          % Polar accumulation mode    
    fprintf(fid,'alfa %g\n',AOA);       % Angle of Attack
    fprintf(fid,'dump.dat %s\n',fName); % Dump files
    fprintf(fid,'cpwr.dat %s\n',fName);          
    fprintf(fid,'pwrt \n');         
    fprintf(fid,[fNamePolar '\n']);     % Polar file output name
    fprintf(fid,'plis\n');              % Show stored polar
    fprintf(fid,'\nquit\n');            % Quit
    fclose(fid);
end

%% Run XFoil
[status, result] =system(['xfoil < xfoil' ID '.inp > xfoil' ID '.out']);
if (status~=0)
    %disp(result); disp('Xfoil execution failed!');
    unix(['rm ' fName '*']);  return;
end

%% Read Values from File
[status, result] = unix(['tail -1 ' fNamePolar]);
if (status~=0)
    %disp(result); disp('Polar reading failed!');
    unix(['rm ' fName '*']); 
    return;
end
values = sscanf(result,'%f');
if isempty(values)
    %disp(result); disp('No values in polar!');
    unix(['rm ' fName '*']); 
    return;
else
    cD = values(3); cL = values(2);
    unix(['rm ' fName '*']); 
    return;
end

end

%------------- END OF CODE --------------