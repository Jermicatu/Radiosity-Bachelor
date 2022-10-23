classdef triangle
    % This class contains all data needed to draw a triangle
    
    properties
        point1 % = [x1 y1 z1]
        point2 % = [x2 y2 z2]
        point3 % = [x3 y3 z3]
        area % area of the triagle
        middle % the middle point of the triangle
        normal % true normal vector of the surface
        color  % = [R G B] each between 1 and infinity
        emission %  = [R G B] emited light, each between 1 and infinity
        reflection % = [R G B] each between 1 and 0 
                   % tells how much of ech color gets reflected
    end
    
    methods
        function obj = triangle(p1, p2, p3, givenNormal, givenReflection, givenEmission)
            % constructor that takes given values
            if nargin == 5
                % all 4 variables are given
                obj.point1 = p1;
                obj.point2 = p2;
                obj.point3 = p3;
                obj.area = norm(cross(p2-p1, p3-p1))/2; % calculate the area
                obj.middle = (p1 +p2 + p3)/3; % calculate the middle 
                                              % point of the triangle
                obj.normal = givenNormal; % needs to be perpendicular to 
                                          % the triangle and of length 1
                obj.color = [0 0 0];   %default is black
                obj.emission = [0 0 0]; % no emission given so default to 0
                obj.reflection = givenReflection;
            end
            
            if nargin == 6
                % all 4 variables are given
                obj.point1 = p1;
                obj.point2 = p2;
                obj.point3 = p3;
                obj.area = norm(cross(p2-p1, p3-p1))/2; % calculate the area
                obj.middle = (p1 +p2 + p3)/3; % calculate the middle 
                                              % point of the triangle
                obj.normal = givenNormal; % needs to be perpendicular to 
                                          % the triangle and of length 1
                obj.color = givenEmission;   % default is given Emmission
                obj.emission = givenEmission;
                obj.reflection = givenReflection;
            end
            % in all other cases create an empty class
            
            function setColor(givenColor)
                obj.color = givenColor;
            end
           
        end
    end
    
end

