function unFrozenDims = freeDims(nUnFrozenDims)
%freeDims- Outputs index of unfrozen dimensions
%       9   % 'Z_{Te}'
%       10  % 'dZ_{Te}' 
%       12  % 'b_{Te}'  --- 10 dims
%       11  % 'a_{Te}'  ---  9 dims
%       5   % 'rLe_{Lo}'---  8 dims
%       1   % 'rLe_{Up}'---  7 dims
%       6   % 'X_{Lo}'  ---  6 dims
%       2   % 'X_{up}'  ---  5 dims
%       8   % 'Z_{XXlo}'
%       4   % 'Z_{XXup}'
%       7   % 'Z_{lo}'
%       3   % 'Z_{up}'	

% Author: Adam Gaier
% Bonn-Rhein-Sieg University of Applied Sciences (HBRS)
% email: adam.gaier@h-brs.de
% May 2016; Last revision: 27-May-2016

%------------- BEGIN CODE --------------

if nUnFrozenDims > 12
    nUnFrozenDims = 0;
    warning('Only 12 degrees of freedom supported, setting unfrozen dimensions to 12.');
end

freezeOrder = [ ...
        9   % 'Z_{Te}'
	    10  % 'dZ_{Te}' 
	    12  % 'b_{Te}'  --- 10 dims
	    11  % 'a_{Te}'  ---  9 dims
	    5   % 'rLe_{Lo}'---  8 dims
        1   % 'rLe_{Up}'---  7 dims
	    6   % 'X_{Lo}'  ---  6 dims
	    2   % 'X_{up}'  ---  5 dims
	    8   % 'Z_{XXlo}'
        4   % 'Z_{XXup}'
	    7   % 'Z_{lo}'
	    3   % 'Z_{up}'	
        ];
unFrozenDims = freezeOrder(1+(12-nUnFrozenDims):end);

%------------- END OF CODE --------------