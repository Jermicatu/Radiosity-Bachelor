clear
clc 
 
s = scene([3 3 2], 4);

s.addCeilingLight(2, 2, 2, 1, 1, [1 1 1])

s.addCuboid(2, 0, 1, 1, 1, 1, [1 0 0])
s.addCuboid(1, 1, 1, 1, 1, 1, [0 1 0])
s.addCuboid(0, 2, 1, 1, 1, 1, [0 0 1])

% functions to add Walls and floor
s.addFloor()
%s.addWallY()
%s.addWallX()

% false = no grid
% potency in geometric term is 3
s.plotScene(false, 4)