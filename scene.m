classdef scene
    % The main class used to create a scene
    
    properties
        triangleList % an array [...] of all triangles in the scene
                     % the triangle are objects of triangle.m
        border % [hight width depth] = [x y z] x,y,z > 0
               % this variable defines the size of the scene
    end
    
    methods
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
        
        
        function addCuboid(obj, positionX, positionY, positionZ, width, depth, hight, refinement)
                        
            % position of the cuboid in the form of [positionX positionY positionZ]
            % width measures the cuboid in x direction
            % depth measures the cuboid in y direction
            % hight measures the cuboid in z direction
            % refinement is an integer which specifies the 
                % amount vertices in a 1 m line (Unit of the grid is m)


            % create 2 sides of the cuboid (floor and ceiling)
            for i = positionX:1/refinement:positionX+width-1/refinement
                for j = positionY:1/refinement:positionY+depth-1/refinement
                    % TODO
                end
            end

            % create 2 sides of the cuboid (front and back)
            for i = positionX:1/refinement:positionX+width-1/refinement
                for j = positionZ:1/refinement:positionZ+hight-1/refinement
                    % TODO
                end
            end

            % create 2 sides of the cuboid (front and back)
            for i = positionY:1/refinement:positionY+depth-1/refinement
                for j = positionZ:1/refinement:positionZ+hight-1/refinement
                    % TODO
                end
            end
            
        end
    end
end

