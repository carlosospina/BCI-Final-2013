% Test set, Train set, test results, train results
function[train_datx, train_daty, test_datx, test_daty] = Folding(x,y)

x_size = size(x);
y_size = size(y);
%display(['x size = ',num2str(x_size)]);
%display(['y size = ',num2str(y_size)]);

x_var = floor(x_size(1) * 0.7);
y_var = floor(y_size(1) * 0.7);
%display(['x var = ',num2str(x_var)]);
%display(['y var = ',num2str(y_var)]);

train_datx = x(1:x_var,1:62);
train_daty = y(1:y_var,1:5);

test_datx = x(x_var:x_size,1:62);
test_daty = y(y_var:y_size,1:5);

%save('train_datx.mat','train_datx');
%save('train_daty.mat','train_daty');
%save('test_datx.mat','test_datx');
%save('test_daty.mat','test_daty');



