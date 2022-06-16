clc
clear
format

t = triangle

testTriangle1 = [1 1 1;    % first point  (x1, y1, z1)
                1 2 1;    % second point (x2, y2, z2)
                0 0 0];   % third point  (x3, y3, z3)
% a coordinate x, y or z is represented by a column in the matrix
testTriangle2 = [1 1 1;
                1 2 1;
                1 0 3];

allTrianglesCell = {};


allTrianglesCell = addCuboid(allTrianglesCell, 1, 1, 1, 3, 1, 1, 10);
allTrianglesCell = addCuboid(allTrianglesCell, 0, 0, 0, 1, 1, 1, 10);

plotAllTriangles(allTrianglesCell);

function [triangle] = plotTriangle(triangle)
    % triangle ariable should be a 3x3 matrix representing the 3 points
    % neeeded to form a triangle
    
    % plot3([triangle(:,1); triangle(1,1)], [triangle(:,2); triangle(1,2)], [triangle(:,3); triangle(1,3)], 'k');
    fill3([triangle(:,1); triangle(1,1)], [triangle(:,2); triangle(1,2)], [triangle(:,3); triangle(1,3)], 'b');
    % plot uses columns of the matrix to take the x, y or z coordinates
    % first point is added at the end to close the triangle
end

function triangleList = plotAllTriangles(triangleList)
    % triangleList should be a Cell-Array of 3x3 Matrices which each
    % symbolise a triangle
    hold on
    xlabel('x');
    ylabel('y');
    zlabel('z');
    title('Radiosity');
    for i = 1:length(triangleList)
        triangle = triangleList{i}; % take triangle number i
        plotTriangle(triangle);     % and plot it
    end
    hold off
end

function triangleList = addCuboid(triangleList, positionX, positionY, positionZ, width, depth, hight, refinement)
    % triangleList is an exsisting cell array of triangles
    % position of the cuboid in the form of [positionX positionY positionZ]
    % width measures the cuboid in x direction
    % depth measures the cuboid in y direction
    % hight measures the cuboid in z direction
    % refinement is an integer which specifies the 
        % amount vertices in a 1 m line (Unit of the grid is m)
        
        
    % create 2 sides of the cuboid (floor and ceiling)
    for i = positionX:1/refinement:positionX+width-1/refinement
        for j = positionY:1/refinement:positionY+depth-1/refinement
            triangleList{end + 1} = [i j positionZ;
                                    i+1/refinement j positionZ
                                    i j+1/refinement positionZ];
                                
            triangleList{end + 1} = [i+1/refinement j+1/refinement positionZ;
                                    i+1/refinement j positionZ
                                    i j+1/refinement positionZ];
                                
            triangleList{end + 1} = [i j positionZ+hight;
                                    i+1/refinement j positionZ+hight
                                    i j+1/refinement positionZ+hight];
                                
            triangleList{end + 1} = [i+1/refinement j+1/refinement positionZ+hight;
                                    i+1/refinement j positionZ+hight
                                    i j+1/refinement positionZ+hight];
        end
    end
    
    % create 2 sides of the cuboid (front and back)
    for i = positionX:1/refinement:positionX+width-1/refinement
        for j = positionZ:1/refinement:positionZ+hight-1/refinement
            triangleList{end + 1} = [i positionY j;
                                    i+1/refinement positionY j
                                    i positionY j+1/refinement];
                                
            triangleList{end + 1} = [i+1/refinement positionY j+1/refinement;
                                    i+1/refinement positionY j
                                    i positionY j+1/refinement];
                                
            triangleList{end + 1} = [i positionY+depth j;
                                    i+1/refinement positionY+depth j
                                    i positionY+depth j+1/refinement];
                                
            triangleList{end + 1} = [i+1/refinement positionY+depth j+1/refinement;
                                    i+1/refinement positionY+depth j
                                    i positionY+depth j+1/refinement];
        end
    end
    
    % create 2 sides of the cuboid (front and back)
    for i = positionY:1/refinement:positionY+depth-1/refinement
        for j = positionZ:1/refinement:positionZ+hight-1/refinement
            triangleList{end + 1} = [positionX i j;
                                    positionX i+1/refinement j
                                    positionX i j+1/refinement];
                                
            triangleList{end + 1} = [positionX i+1/refinement j+1/refinement;
                                    positionX i+1/refinement j
                                    positionX i j+1/refinement];
                                
            triangleList{end + 1} = [positionX+width i j;
                                    positionX+width i+1/refinement j
                                    positionX+width i j+1/refinement];
                                
            triangleList{end + 1} = [positionX+width i+1/refinement j+1/refinement;
                                    positionX+width i+1/refinement j
                                    positionX+width i j+1/refinement];
        end
    end
end