%Spline Interpolation
% Inputs: 
%1.x -> step size of the original matrix  50ms , 400,000/ 8000
%2.Y -> Predicted values of the finger Coordinates one row at a time
%3.xx - > new step size, --> 1ms constant to get back to the original freq.

%
function feature_interpolated = CalcSpline( data, )
