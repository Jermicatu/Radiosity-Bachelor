clear
clc

t1 = triangle;
t2 = triangle;

t1.point1 = [1 1 1];
t1.point2 = [1 2 1];
t1.point3 = [0 0 0];
t1.color = [1 0 0];

t2.point1 = [1 1 1];
t2.point2 = [1 2 1];
t2.point3 = [1 0 3];
t2.color = [1 1 0];

s = scene;
s.border = [3 3 3];

s.triangleList = [t1 t2];



s.plotScene()