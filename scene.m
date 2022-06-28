classdef scene < handle
    % The main class used to create a scene
    
    properties
        triangleList % an array [...] of all triangles in the scene
                     % the triangle are objects of triangle.m
        border % [hight width depth] = [x y z] x,y,z > 0
               % this variable defines the size of the scene
    end
    
    methods
        function obj = scene(givenBorder, givenTriangleList)
            % constructor that takes given values
            if nargin == 1
                % just the border is given
                obj.border = givenBorder;
                obj.triangleList = [];
            end
            if nargin == 2
                % all variables are given
                obj.border = givenBorder;
                obj.triangleList = givenTriangleList;
            end
        end
        
        
        function plotScene(obj)
            % plots the entire Scene by plotting each individual triangle
            
            hold on 
            % this is needed so that we dont just create a plot for the last triangle
            
            % setting the labels for the plot
            xlabel('x');
            ylabel('y');
            zlabel('z');
            title('Radiosity');
            
            % setting linits for the plot
            xlim([0 obj.border(1)]);
            ylim([0 obj.border(2)]);
            zlim([0 obj.border(3)]);
            
            % ploting each triangle individually
            for t = obj.triangleList
                fill3([t.point1(1) t.point2(1) t.point3(1)], [t.point1(2) t.point2(2) t.point3(2)], [t.point1(3) t.point2(3) t.point3(3)], t.color);
            end
            
            % hold needs to end
            hold off
        end
        
        
        function addCuboid(obj, positionX, positionY, positionZ, width, depth, hight, refinement, color)
                        
            % position of the cuboid in the form of [positionX positionY positionZ]
            % width measures the cuboid in x direction
            % depth measures the cuboid in y direction
            % hight measures the cuboid in z direction
            % refinement is an integer which specifies the 
                % amount vertices in a 1 m line (Unit of the grid is m)
            
            
            w = floor(width*refinement); % Number of vertices in x (width) direction
            d = floor(depth*refinement); % Number of vertices in y (depth) direction
            h = floor(hight*refinement); % Number of vertices in z (hight) direction
            
            2*w*d*h;
            
            % create 2 sides of the cuboid (floor and ceiling)
            for i = positionX:width/w:positionX+width-width/w
                for j = positionY:depth/d:positionY+depth-depth/d
                    obj.triangleList(end + 1) = triangle([i j positionZ], [i+width/w j positionZ], [i j+depth/d positionZ], color);
                    obj.triangleList(end + 1) = triangle([i+width/w j positionZ], [i j+depth/d positionZ], [i+width/w j+depth/d positionZ], color);
                    
                    obj.triangleList(end + 1) = triangle([i j positionZ+hight], [i+width/w j positionZ+hight], [i j+depth/d positionZ+hight], color);
                    obj.triangleList(end + 1) = triangle([i+width/w j positionZ+hight], [i j+depth/d positionZ+hight], [i+width/w j+depth/d positionZ+hight], color);
                
                end
            end

            % create 2 sides of the cuboid (front and back)
            for i = positionX:width/w:positionX+width-width/w
                for j = positionZ:hight/h:positionZ+hight-hight/h
                    
                    obj.triangleList(end + 1) = triangle([i positionY j], [i+width/w positionY j], [i positionY j+hight/h], color);
                    obj.triangleList(end + 1) = triangle([i+width/w positionY j+hight/h], [i+width/w positionY j], [i positionY j+hight/h], color);
                    
                    obj.triangleList(end + 1) = triangle([i positionY+depth j], [i+width/w positionY+depth j], [i positionY+depth j+hight/h], color);
                    obj.triangleList(end + 1) = triangle([i+width/w positionY+depth j+hight/h], [i+width/w positionY+depth j], [i positionY+depth j+hight/h], color);
                    
                end
            end

            % create 2 sides of the cuboid (front and back)
            for i = positionY:depth/d:positionY+depth-depth/d
                for j = positionZ:hight/h:positionZ+hight-hight/h
                    
                    obj.triangleList(end + 1) = triangle([positionX i j], [positionX i+depth/d j], [positionX i j+hight/h], color);
                    obj.triangleList(end + 1) = triangle([positionX i+depth/d j+hight/h], [positionX i+depth/d j], [positionX i j+hight/h], color);
                    
                    obj.triangleList(end + 1) = triangle([positionX+width i j], [positionX+width i+depth/d j], [positionX+width i j+hight/h], color);
                    obj.triangleList(end + 1) = triangle([positionX+width i+depth/d j+hight/h], [positionX+width i+depth/d j], [positionX+width i j+hight/h], color);
                    
                end
            end
            
        end
    end
end
