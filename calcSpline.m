%Spline Interpolation
% Inputs: 
%1.x -> step size of the original matrix  50ms , 400,000/ 8000
%2.Y -> Predicted values of the finger Coordinates one row at a time
%3.xx - > new step size, --> 1ms constant to get back to the original freq.

%
function interpolatedData = calcSpline(decimationFactor, data )
numRows = size(data,1);
x = 0:numRows;
%Remove the additional data point at the end
x = x(1,1:end-1);

xx = 0:(1/decimationFactor):numRows;
%Remove the additional data point at the end
xx = xx(1,1:end-1);

% fix start and end point for the data
y=data';
y=[y(1,1) y y(1,numRows)];
interpolatedData = spline(x,y ,xx);
interpolatedData=interpolatedData';
end