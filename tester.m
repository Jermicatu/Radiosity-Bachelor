clear
clc

t1 = triangle([1 1 1], [1 2 1], [0 0 0], [1 1 0]);
t2 = triangle([1 1 1], [1 2 1], [1 0 3], [1 1 0]);

s = scene([5 5 5], [t1]);

s.addCuboid(1, 1, 1, 2.33, 1.1111, 2, 10, [1 0 0])

s.plotScene()
