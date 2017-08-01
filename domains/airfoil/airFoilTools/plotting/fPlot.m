function h = fPlot(coords, varargin)

if ~isempty(varargin)
   h = plot(coords(1,:), coords(2,:),varargin{1});
else
   h = plot(coords(1,:), coords(2,:));
end
