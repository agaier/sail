function [fitness, dragF] = veloCd(drag, p)

%------------- BEGIN CODE --------------
% % Assumes solution is valid
% %if express(x) % Validity check
%     pred = gpDrag(x);
%     fitness = pred(1) + pred(2)*UCB;    
% %else
%     fitness = nan;
% %end
fitness = -(drag(:,1)*p.muCoef - drag(:,2)*p.varCoef); % better fitness is higher fitness  
dragF = drag(:,1);