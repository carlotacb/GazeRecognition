close all

x = -1 + 2*rand(1000,2);
r = sqrt(x(:,1).*x(:,1)+x(:,2).*x(:,2));
y = (r > 0.5)*2-1;

figure;
h(1:2) = gscatter(x(:,1),x(:,2),y,'rb','.');
hold on

%Train the SVM Classifier
predictor = fitcsvm(x,y,'KernelFunction','rbf',...
    'BoxConstraint',Inf,'ClassNames',[-1,1]);

yp = predict(predictor,x);
errors = abs(y-yp);
sum(errors)