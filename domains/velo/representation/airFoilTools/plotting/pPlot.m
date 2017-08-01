function h = pPlot(parsecParams, varargin)

if ~isempty(varargin)
   h = plot(parsecParams, varargin{:});
else
   h = plot(parsecParams,'-o');
end
axis([0.95 12.5 -0.05 1.05]); grid on;
set(gca,'Xtick',1:12)
set(gca,'XTickLabel',num2Parsec(1:12))