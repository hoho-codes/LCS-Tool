
%% Function that returns velocity values of the Double Gyre stream function taking
%% the parameters eps,w,A as inputs along with the time 't' (scalar) and position 'x' (2D vector)

function dxdt = DoubleGyreDerivative(t,x,eps,w,A)

  f = @(t,z) (eps*sin(w*t)*z*z+(1-2*eps*sin(w*t))*z);
  dfdx = @(t,a) (2*eps*a*sin(w*t)+(1-2*eps*sin(w*t)));

  dxdt = [-pi*A*sin(pi*f(t,x(1)))*cos(pi*x(2));pi*A*sin(pi*x(2))*cos(pi*f(t,x(1)))*dfdx(t,x(1))];

end
