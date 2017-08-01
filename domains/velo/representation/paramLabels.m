function labels = paramLabels(varargin)
%% %---------------------------------%
%  1    'Top: Leading Edge Radius'
%  2    'Top: Pos of Tallest Point'
%  3    'Top: Tallest Point'
%  4    'Top: Curvature'
%  5    'Mid: Leading Edge Radius'
%  6    'Mid: Pos of Tallest Point'
%  7    'Mid: Tallest Point'
%  8    'Mid: Curvature'
%  9    'Ridge: Leading Edge Radius'
%  10   'Ridge: Pos of Tallest Point'
%  11   'Ridge: Relative Height'
%  12   'Rib: Leading Edge Radius'
%  13   'Rib: Pos of Tallest Point'
%  14   'Rib: Tallest Point'
%  15   'Rib: Curvature'
%  16   'Rib: TE Alpha'
%% %---------------------------------%

allLabels = {	'Top: Leading Edge Radius'
			 	'Top: Pos of Tallest Point'
			 	'Top: Tallest Point'
			 	'Top: Curvature'
    	     	'Mid: Leading Edge Radius'
    		 	'Mid: Pos of Tallest Point'
    		 	'Mid: Tallest Point'
    			'Mid: Curvature'
			    'Ridge: Leading Edge Radius'
    			'Ridge: Pos of Tallest Point'
                'Ridge: Relative Height'
     			'Rib: Leading Edge Radius'
    			'Rib: Pos of Tallest Point'
    			'Rib: Tallest Point'
    			'Rib: Curvature'
    			'Rib: TE Alpha'};

if isempty(varargin)
    labels = allLabels;
else
    labels = allLabels(varargin{1});
end

