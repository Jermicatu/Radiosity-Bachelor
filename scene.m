classdef scene < handle
    % The main class used to create a scene
    
    properties
        triangleList % an array [...] of all triangles in the scene
                     % the triangle are objects of triangle.m
        border % [hight width depth] = [x y z] x,y,z > 0
               % this variable defines the size of the scene
        refinement % refinement is an integer which specifies the 
                   % amount vertices in a 1m line (Unit of the grid is m)
    end
    
    methods
        function obj = scene(givenBorder, givenRefinement, givenTriangleList)
            % constructor that takes given values
            
            if nargin == 3 % 3 inputs
                obj.border = givenBorder;
                obj.refinement = givenRefinement;
                obj.triangleList = givenTriangleList;
            end
            if nargin == 2 % 2 inputs - no givenTriangleList
                obj.border = givenBorder;
                obj.refinement = givenRefinement;
                obj.triangleList = triangle.empty;
            end
            
            width = givenBorder(1);
            depth = givenBorder(2);
            hight = givenBorder(3);
            
            % the reflection of the wall of the room is white by default
            reflection = [1 1 1];
            
            w = floor(width*givenRefinement); % Number of vertices in x (width) direction
            d = floor(depth*givenRefinement); % Number of vertices in y (depth) direction
            h = floor(hight*givenRefinement); % Number of vertices in z (hight) direction
            
%            % create floor of the room
%            normal = [0 0 1]; % normal for the following triangles
%            for i = 0:width/w:width-width/w
%                for j = 0:depth/d:0+depth-depth/d
%                    obj.triangleList(end + 1) = triangle([i j 0], [i+width/w j 0], [i j+depth/d 0], normal, reflection);
%                    obj.triangleList(end + 1) = triangle([i+width/w j 0], [i j+depth/d 0], [i+width/w j+depth/d 0], normal, reflection);
%                end
%            end
%
            % create left wall of the room
            normal = [0 1 0]; % normal for the following triangles
            for i = 0:width/w:+width-width/w
                for j = 0:hight/h:+hight-hight/h
                    obj.triangleList(end + 1) = triangle([i 0 j], [i+width/w 0 j], [i 0 j+hight/h], normal, reflection);
                    obj.triangleList(end + 1) = triangle([i+width/w 0 j+hight/h], [i+width/w 0 j], [i 0 j+hight/h], normal, reflection);
                end
            end
%
%            % create front of room
%            normal = [1 0 0]; % normal for the following triangles
%            for i = 0:depth/d:depth-depth/d
%                for j = 0:hight/h:hight-hight/h
%                    obj.triangleList(end + 1) = triangle([0 i j], [0 i+depth/d j], [0 i j+hight/h], normal, reflection);
%                    obj.triangleList(end + 1) = triangle([0 i+depth/d j+hight/h], [0 i+depth/d j], [0 i j+hight/h], normal, reflection);
%                end
%            end
            
            
        end
        
        function visTerm = checkVisible (obj, i, j)
            % checks if there is a triangle between x_i and x_j obstructing
            % the vision between them
            
            % define ray from x_i to x_j as function
            line = @(x) x*(obj.triangleList(j).normal - obj.triangleList(i).normal);
            
            % check where the ray intersects with each triangle till 
            % there is one in the way or all have been checked
            n = length(obj.triangleList);
            syms x y z
            k = 1;
            while k  < n+1
                if k == i
                    % to make sure there is no issue
                    k = k+1;
                else
                    % define triangle as function
                    area = @(y, z) obj.triangleList(k).point1 + y*obj.triangleList(k).point2 + z*obj.triangleList(k).point3;
                    S = solve(line(x) == area(y, z), [x, y, z]);
                    if 0 < S.x & (S.y + S.z) < 1  & S.x  <= 1
                        visTerm = 1;
                        k = n+2; % set k above breakpoint for loop
                    else
                        k = k+1; % move k one step ahead
                    end
                end
            end
            if k == n+1
                visTerm = 0;
            end
        end
        
        function geoTerm = calcGeoTerm(obj, i, j)
            % calculates the geometrical term G(x_i,x_j)
            
            % get the variables
            normal1 = obj.triangleList(i).normal;
            middle1 = obj.triangleList(i).middle;
            normal2 = obj.triangleList(j).normal;
            middle2 = obj.triangleList(j).middle;
            
            % calculate cos(theta1) and cos(theta2) as in the paper
            cos1 = normal1*transpose(middle2 - middle1);
            cos2 = normal2*transpose(middle1 - middle2);
            
            if cos1 <= 0 || cos2 <= 0
                % light would have to go through
                % the object therefore we get
                geoTerm = 0;
            elseif obj.checkVisible(i,j) == 0
                % visibility check tells us that                 
                % a triangle is blocking the light
                % therefore we get
                geoTerm = 0;
            else
                % if none of the above is true then there is a direct
                % unobscured line between x_i and x_j
                % we calculate G(x_i,x_j)
                geoTerm = cos1*cos2/norm(middle1 - middle2);
            end
        end
        
        function calcColor(obj)
            % calculates the color of all triangles in the scene
            
            % get the size of the matrices and vectors 
            n = length(obj.triangleList);
            
            % predefine the matrices and vectors for each color 
            gRed = sparse(n,n); % geometrical matrix for red others analog
            eRed = sparse(n,1); % vector of emmited light red others analog
            gGreen = sparse(n,n);
            eGreen = sparse(n,1);
            gBlue = sparse(n,n);
            eBlue = sparse(n,1);
            
            for i = 1:1:n
                % set values of the light emission vectors
                eRed(i) = obj.triangleList(i).emission(1);
                eGreen(i) = obj.triangleList(i).emission(2);
                eBlue(i) = obj.triangleList(i).emission(3);
                for j = 1:1:n
                    % calculate geometrical Term
                    geoTerm = obj.calcGeoTerm(i, j);
                    
                    %i
                    if geoTerm ~= 0
                        % set values of the matrices
                        gRed(i,j) = obj.triangleList(j).reflection(1)*geoTerm*obj.triangleList(j).area(1);
                        gGreen(i,j) = obj.triangleList(j).reflection(2)*geoTerm*obj.triangleList(j).area(1);
                        gBlue(i,j) = obj.triangleList(j).reflection(3)*geoTerm*obj.triangleList(j).area(1);
                    end
                end
            end
            
            % calculate lighting vectors
            bRed = gRed' * eRed;
            bGreen = gGreen' * eGreen;
            bBlue = gBlue' * eBlue;
            for i = 1:1:n
                %set values in triangles
                obj.triangleList(i).color(1) = bRed(i) + obj.triangleList(i).emission(1);
                obj.triangleList(i).color(2) = bGreen(i) + obj.triangleList(i).emission(2);
                obj.triangleList(i).color(3) = bBlue(i) + obj.triangleList(i).emission(3);
            end
        end
            
        function plotScene(obj)
            % plots the entire Scene by plotting each individual triangle
            
            % hold on 
            % this is needed so that we dont just create a plot for the last triangle
            
            % setting the labels for the plot
            
            % first run fuction to calculate lighting
            
            obj.calcColor();
            
            xlabel('x');
            ylabel('y');
            zlabel('z');
            title('Radiosity');
            
            % setting limits for the plot
            xlim([0 obj.border(1)]);
            ylim([0 obj.border(2)]);
            zlim([0 obj.border(3)]);
            
            % preallocating 3xlength(obj.triangleList) matrices
            xMatrix = zeros(3, length(obj.triangleList));
            yMatrix = zeros(3, length(obj.triangleList));
            zMatrix = zeros(3, length(obj.triangleList));
            cMatrix = zeros(1, length(obj.triangleList), 3);
            
            % Fill the matrices with the values
            for i = 1:1:length(obj.triangleList)
                xMatrix(1, i) = obj.triangleList(i).point1(1);
                xMatrix(2, i) = obj.triangleList(i).point2(1);
                xMatrix(3, i) = obj.triangleList(i).point3(1);
                
                yMatrix(1, i) = obj.triangleList(i).point1(2);
                yMatrix(2, i) = obj.triangleList(i).point2(2);
                yMatrix(3, i) = obj.triangleList(i).point3(2);
                
                zMatrix(1, i) = obj.triangleList(i).point1(3);
                zMatrix(2, i) = obj.triangleList(i).point2(3);
                zMatrix(3, i) = obj.triangleList(i).point3(3);
                
                cMatrix(1, i, :) = obj.triangleList(i).color;
            end
            
            patch(xMatrix, yMatrix, zMatrix, cMatrix) %, 'LineStyle', 'none');
            view(obj.border);
            for i = 1:1:length(obj.triangleList)
                show = obj.triangleList(i)
            end
            
            % ploting each triangle individually
            %for t = obj.triangleList
            %    fill3([t.point1(1) t.point2(1) t.point3(1)], [t.point1(2) t.point2(2) t.point3(2)], [t.point1(3) t.point2(3) t.point3(3)], t.color); % 'LineStyle','none'
            %end
            
            % hold needs to end
            % hold off
        end
        
        
        function addCuboid(obj, positionX, positionY, positionZ, width, depth, hight, reflection)
                        
            % position of the cuboid in the form of [positionX positionY positionZ]
            % width measures the cuboid in x direction
            % depth measures the cuboid in y direction
            % hight measures the cuboid in z direction
            % refinement is an integer which specifies the 
                % amount vertices in a 1 m line (Unit of the grid is m)
            
            
            w = floor(width*obj.refinement); % Number of vertices in x (width) direction
            d = floor(depth*obj.refinement); % Number of vertices in y (depth) direction
            h = floor(hight*obj.refinement); % Number of vertices in z (hight) direction
            
            % create 2 sides of the cuboid (floor and ceiling)
            normalCeiling = [0 0 1]; % normal for the following triangles; negative for the floor
            for i = positionX:width/w:positionX+width-width/w
                for j = positionY:depth/d:positionY+depth-depth/d
                    
                    obj.triangleList(end + 1) = triangle([i j positionZ], [i+width/w j positionZ], [i j+depth/d positionZ], -normalCeiling, reflection);
                    obj.triangleList(end + 1) = triangle([i+width/w j positionZ], [i j+depth/d positionZ], [i+width/w j+depth/d positionZ], -normalCeiling, reflection);
                    
                    obj.triangleList(end + 1) = triangle([i j positionZ+hight], [i+width/w j positionZ+hight], [i j+depth/d positionZ+hight], normalCeiling, reflection);
                    obj.triangleList(end + 1) = triangle([i+width/w j positionZ+hight], [i j+depth/d positionZ+hight], [i+width/w j+depth/d positionZ+hight], normalCeiling, reflection);
                
                end
            end

            % create 2 sides of the cuboid (front and back)
            normalBack = [0 1 0]; % normal for the following triangles; negative for the front
            for i = positionX:width/w:positionX+width-width/w
                for j = positionZ:hight/h:positionZ+hight-hight/h
                    
                    obj.triangleList(end + 1) = triangle([i positionY j], [i+width/w positionY j], [i positionY j+hight/h], -normalBack, reflection);
                    obj.triangleList(end + 1) = triangle([i+width/w positionY j+hight/h], [i+width/w positionY j], [i positionY j+hight/h], -normalBack, reflection);
                    
                    obj.triangleList(end + 1) = triangle([i positionY+depth j], [i+width/w positionY+depth j], [i positionY+depth j+hight/h], normalBack, reflection);
                    obj.triangleList(end + 1) = triangle([i+width/w positionY+depth j+hight/h], [i+width/w positionY+depth j], [i positionY+depth j+hight/h], normalBack, reflection);
                    
                end
            end

            % create 2 sides of the cuboid (left and right)
            normalRight = [1 0 0]; % normal for the following triangles; negative for the left side
            for i = positionY:depth/d:positionY+depth-depth/d
                for j = positionZ:hight/h:positionZ+hight-hight/h
                    
                    obj.triangleList(end + 1) = triangle([positionX i j], [positionX i+depth/d j], [positionX i j+hight/h], -normalRight, reflection);
                    obj.triangleList(end + 1) = triangle([positionX i+depth/d j+hight/h], [positionX i+depth/d j], [positionX i j+hight/h], -normalRight, reflection);
                    
                    obj.triangleList(end + 1) = triangle([positionX+width i j], [positionX+width i+depth/d j], [positionX+width i j+hight/h], normalRight, reflection);
                    obj.triangleList(end + 1) = triangle([positionX+width i+depth/d j+hight/h], [positionX+width i+depth/d j], [positionX+width i j+hight/h], normalRight, reflection);
                    
                end
            end
            
        end
    end
end

