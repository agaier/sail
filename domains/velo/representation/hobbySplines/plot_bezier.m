
function plot_bezier(P1,P2,P3,P4,linestyle)

N = 50;
t = linspace(0,1,N)';

c1 = 3*(P2 - P1);
c2 = 3*(P1 - 2*P2 + P3);
c3 = -P1 + 3*(P2-P3) + P4;

Q = t.^3*c3 + t.^2*c2 + t*c1 + repmat(P1,[N 1]);

plot3(Q(:,1),Q(:,2),Q(:,3),linestyle{:});

end