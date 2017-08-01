function label = num2Parsec(n)
% num2Parsec - returns label of parsec-12 number
%       1   % 'rLe_{Up}'---  7 dims
%       2   % 'X_{up}'  ---  5 dims
%       3   % 'Z_{up}'	
%       4   % 'Z_{XXup}'
%       5   % 'rLe_{Lo}'---  8 dims
%       6   % 'X_{Lo}'  ---  6 dims
%       7   % 'Z_{lo}'
%       8   % 'Z_{XXlo}'
%       9   % 'dZ_{Te}' 
%       10  % 'Z_{Te}'
%       11  % 'a_{Te}'  ---  9 dims
%       12  % 'b_{Te}'  --- 10 dims

key = {'rLe_{Up}', 'X_{up}' ,    'Z_{up}', 'Z_{XXup}',...
       'rLe_{Lo}', 'X_{lo}' ,    'Z_{lo}', 'Z_{XXlo}',...
       'dZ_{Te}' , 'Z_{Te}' ,    'a_{Te}', 'b_{Te}'};
   
label = key(n);

end