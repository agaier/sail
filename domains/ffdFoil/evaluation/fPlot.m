function h = fPlot(coords, varargin)

if ~isempty(varargin)
   h = plot(coords(1,:), coords(2,:),varargin{:});
else
   h = plot(coords(1,:), coords(2,:));
end
grid on; axis([0 1 -0.2 0.2]);