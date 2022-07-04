clear
clc

t1 = triangle([1 1 1], [1 2 1], [0 0 0], [0 0 0]);
t2 = triangle([1 1 1], [1 2 1], [1 0 3], [1 1 1]);

s = scene([5 5 5], [t1], 5);

s.addCuboid(1, 1, 1, 1, 1, 1, [1 0 0])
s.addCuboid(1, 1, 2, 1, 1, 1, [1 1 0])
s.addCuboid(1, 1, 3, 1, 1, 1, [0 1 0])

s.addCuboid(4, 1, 1, 0.2, 1, 1, [0 1 1])
s.addCuboid(1, 4, 1, 1, 0.2, 1, [0 1 1])

s.plotScene()
