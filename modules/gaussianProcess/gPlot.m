%function [lh, fh] = gPlot(m,s2,z)
function [lh, fh] = gPlot(varargin)

if nargin == 1
    input = sortrows(varargin{1},3);
    m = input(:,1);
    s2 = input(:,2);
    z = input(:,3);
elseif nargin == 2
    m  = varargin{1}(:,1)';
    s2 = varargin{1}(:,2)';
    z  = varargin{2};
else
    m  = varargin{1};
    s2 = varargin{2};
    z  = varargin{3};
end
    

f = [m+2*sqrt(s2); flipdim(m-2*sqrt(s2),1)]; 
fh = fill([z; flipdim(z,1)], f, [7 7 7]/8,'FaceAlpha',0.25);
lh = plot(z,m);

end