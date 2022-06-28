classdef triangle
    % This class contains all data needed to draw a triangle
    
    properties
        point1 % = [x1 y1 z1]
        point2 % = [x2 y2 z2]
        point3 % = [x3 y3 z3]
        color  % = [R G B] each between 1 and 0
    end
    
    methods
        function obj = triangle(p1, p2, p3, givenColor)
            % constructor that takes given values
            if nargin == 4
                % all 4 variables are given
                obj.point1 = p1;
                obj.point2 = p2;
                obj.point3 = p3;
                obj.color = givenColor;
            end
            % in all other cases create an empty class
           
        end
    end
    
end

