classdef QuadratureRules < handle
% QuadratureRules - provide finite element quadrature rules
%
%  Syntax: qr = QuadratureRules(elementType, integrationOrder);
% 
%  properties:
%      weights: list of weights
%       points: list of quadrature points
%         nint: number of integration points
%     itgOrder: order of integration
%     accuracy: order of accuracy can be obtatined from the define quadrature rule
% 
%  methods:
%     \param[out] output1 - Description
%     QuadratureRules(eType, iOrder) - costructor will take element type
%                                      and integration order and define the 
%                                      quadrature rule accordingly
% 
%  Example:
%     qr = QuadratureRules(EnumElementType.Quadrilateral, 1);
%     qr = 
%       QuadratureRules with properties:
%          weights: [4�1 double]
%           points: [4�2 double]
%             nint: 4
%         itgOrder: 1
%         accuracy: 4
%     [qr.weights, qr.points]
%     
%     ans =
%         1.0000   -0.5774   -0.5774
%         1.0000    0.5774   -0.5774
%         1.0000    0.5774    0.5774
%         1.0000   -0.5774    0.5774
%
%  Other m-files required: EnumElementType.m
% 
%  See also: FemLib, BndFemLib 
%
% Author: Sangmin Lee, Ph.D.
% email: crealucu@gmail.com
% 08-Oct-2020; Last revision:
  properties
    weights; points; nint; itgOrder;
    accuracy;
  end
  methods
    function obj = QuadratureRules(eType, iOrder)
      if(nargin < 2)
        iOrder = -1;
      end
      if(iOrder < 0)
        switch(eType)
          case EnumElementType.Tetrahedron
            iOrder = 0;
          otherwise
            iOrder = 1;
        end
      end
      switch(eType)
        case EnumElementType.Point
          obj.weights = 1;
          obj.points = [0.0, 0.0, 0.0];
          obj.accuracy = [];
        case EnumElementType.Line
          [obj.weights, obj.points, obj.accuracy] = Line(iOrder);
        case EnumElementType.Triangle
          [obj.weights, obj.points, obj.accuracy] = Triangle(iOrder);
        case EnumElementType.Quadrilateral
          [obj.weights, obj.points, obj.accuracy] = Quadrilateral(iOrder);
        case EnumElementType.Tetrahedron
          [obj.weights, obj.points, obj.accuracy] = Tetrahedron(iOrder);
        case EnumElementType.Hexahedron
          [obj.weights, obj.points, obj.accuracy] = Hexahedron(iOrder);
      end
      obj.nint = numel(obj.weights);
      obj.itgOrder = iOrder;
    end    
  end
end

function [w, pts, accuracy] = Line(order)
  switch(order)
    case 0
      w = 2.0;
      pts = [0.0, 0.0, 0.0];
      accuracy = 2;
    case 1
      % integration points: -1/sqrt(3) 1/sqrt(3)
      % wight             :          1         1
      % 1/sqrt(3) = 0.577350269189626
      w = [1.0; 1.0];
      pts = [-0.577350269189626, 0.0, 0.0
              0.577350269189626, 0.0, 0.0];
      accuracy = 4;
    case 2
      % integration points: -sqrt(3/5)  0   sqrt(3/5)
      % wight             :         5/9 8/9       5/9
      % sqrt(3/5) = 0.774596669241483
      % 5/9 = 0.555555555555556
      % 8/9 = 0.888888888888889
      w = [0.555555555555556; 0.888888888888889; 0.555555555555556];
      pts = [-0.774596669241483, 0.0, 0.0
                            0.0, 0.0, 0.0
              0.774596669241483, 0.0, 0.0];
      accuracy = 6;
    case 3
      % A = sqrt((15+2*sqrt(30))/35) = 0.861136311594053
      % B = sqrt((15-2*sqrt(30))/35) = 0.339981043584856
      % C = (18-sqrt(30))/36 = 0.347854845137454
      % D = (18+sqrt(30))/36 = 0.652145154862546
      % integration points: -A -B B A
      % wight             :  C  D D C
      w = [0.347854845137454; 0.652145154862546; 
           0.652145154862546; 0.347854845137454];
      pts = [-0.861136311594053, 0.0, 0.0
             -0.339981043584856, 0.0, 0.0
              0.339981043584856, 0.0, 0.0
              0.861136311594053, 0.0, 0.0];
      accuracy = 8;            
    otherwise
      w = [1.0; 1.0];
      pts = [-0.577350269189626, 0.0, 0.0
              0.577350269189626, 0.0, 0.0];
      accuracy = 4;
  end
end
function [w, pts, accuracy] = Triangle(order)
  switch(order)
    case 0
      % nint  O(n) pts pts weight
      %    1    1  1/3 1/3 1/2
      w = 0.5; % factor 1/2 is applied
      pts = [0.333333333333333, 0.333333333333333, 0.0];
      accuracy = 1;      
    case 1
      % nint  O(n) pts pts weight
      %    3    2  1/2   0 1/6
      %            1/2 1/2 1/6
      %              0 1/2 1/6
      
      % factor 1/2 is applied
      w = [0.166666666666667; 0.166666666666667; 0.166666666666667];
      pts = [0.5, 0.0, 0.0
             0.5, 0.5, 0.0
             0.0, 0.5, 0.0];
      accuracy = 2;
    case 2
      % nint  O(n) pts pts weight
      %    4    3  0.2 0.2 25/48
      %            0.6 0.2 25/48
      %            0.2 0.6 25/48
      %            1/3 1/3 -9/16
      
      % factor 1/2 is applied
      w = [0.260416666666667; 0.260416666666667; 0.260416666666667; -0.281250000000000]; 
      pts = [0.2,               0.2, 0.0
             0.6,               0.2, 0.0
             0.2,               0.6, 0.0
             0.333333333333333, 0.333333333333333, 0.0];
      accuracy = 3;
    case 3
      % nint  O(n) pts               pts               weight
      %    6    4  0.091576213509771 0.091576213509771 0.109951743655322
      %            0.816847572980459 0.091576213509771 0.109951743655322
      %            0.091576213509771 0.816847572980459 0.109951743655322
      %            0.445948490915965 0.445948490915965 0.223381589678011
      %            0.445948490915965 0.108103018168070 0.223381589678011
      %            0.108103018168070 0.445948490915965 0.223381589678011

      % factor 1/2 is applied
      w = [0.054975871827661; 0.054975871827661; 0.054975871827661; 
           0.111690794839005; 0.111690794839005; 0.111690794839005]; 
      pts = [0.091576213509771 0.091576213509771, 0.0
             0.816847572980459 0.091576213509771, 0.0
             0.091576213509771 0.816847572980459, 0.0
             0.445948490915965 0.445948490915965, 0.0
             0.445948490915965 0.108103018168070, 0.0
             0.108103018168070 0.445948490915965, 0.0];
      accuracy = 4;
    otherwise
      w = [0.166666666666667; 0.166666666666667; 0.166666666666667];
      pts = [0.5, 0.0, 0.0
             0.5, 0.5, 0.0
             0.0, 0.5, 0.0];
      accuracy = 2;
  end
end
function [w, pts, accuracy] = Quadrilateral(order)
  % quadrature rule is defined from Line
  switch(order)
    case 0
      w = 4.0;
      pts = [0.0, 0.0,0.0];
      accuracy = 2;
    case 1
      % integration points: -1/sqrt(3) 1/sqrt(3)
      % wight             :          1         1
      % 1/sqrt(3) = 0.577350269189626
      w = [1.0; 1.0; 1.0; 1.0];
      pts = [-0.577350269189626, -0.577350269189626, 0.0
              0.577350269189626, -0.577350269189626, 0.0
              0.577350269189626,  0.577350269189626, 0.0
             -0.577350269189626,  0.577350269189626, 0.0];
      accuracy = 4;
    case 2
      % integration points: -sqrt(3/5)  0   sqrt(3/5)
      % wight             :         5/9 8/9       5/9
      % sqrt(3/5) = 0.774596669241483
      % 5/9 = 0.555555555555556
      % 8/9 = 0.888888888888889
      w = [0.308641975308642; 0.493827160493827; 0.308641975308642
           0.493827160493827; 0.790123456790123; 0.493827160493827
           0.308641975308642; 0.493827160493827; 0.308641975308642];
      pts = [-0.774596669241483, -0.774596669241483, 0.0
                            0.0, -0.774596669241483, 0.0
              0.774596669241483, -0.774596669241483, 0.0
              0.774596669241483,                0.0, 0.0
                            0.0,                0.0, 0.0
             -0.774596669241483,                0.0, 0.0
             -0.774596669241483,  0.774596669241483, 0.0
                            0.0,  0.774596669241483, 0.0
              0.774596669241483,  0.774596669241483, 0.0];
      accuracy = 6;
    otherwise
      w = [1.0; 1.0; 1.0; 1.0];
      pts = [-0.577350269189626, -0.577350269189626, 0.0
              0.577350269189626, -0.577350269189626, 0.0
              0.577350269189626,  0.577350269189626, 0.0
             -0.577350269189626,  0.577350269189626, 0.0];
      accuracy = 4;
  end
end
function [w, pts, accuracy] = Tetrahedron(order)
  switch(order)
    case 0
      % nint  O(n) pts pts pts weight
      %    1    1  1/4 1/4 1/4 1
      w = 0.166666666666667; % factor 1/6 is applied
      pts = [0.25, 0.25, 0.25];
      accuracy = 1;
    case 1
      % A = (5-sqrt(5))/20   = 0.138196601125011
      % B = (5+3*sqrt(5))/20 = 0.585410196624969
      % nint  O(n) pts pts pts weight
      %    4    2  A   A   A   1/4
      %            B   A   A   1/4
      %            A   B   A   1/4
      %            A   A   B   1/4
      
      % factor 1/6 is applied
      w = [0.041666666666667; 0.041666666666667; 0.041666666666667; 0.041666666666667];
      pts = [0.138196601125011, 0.138196601125011, 0.138196601125011
             0.585410196624969, 0.138196601125011, 0.138196601125011
             0.138196601125011, 0.585410196624969, 0.138196601125011
             0.138196601125011, 0.138196601125011, 0.585410196624969];
      accuracy = 2;
    case 2
      % nint  O(n) pts pts pts weight
      %    5    3  1/6 1/6 1/6  9/20
      %            1/2 1/6 1/6  9/20
      %            1/6 1/2 1/6  9/20
      %            1/6 1/6 1/2  9/20
      %            1/4 1/4 1/4 -4/5
      
      % factor 1/6 is applied
      w = [0.075; 0.075; 0.075; 0.075; -0.133333333333333];
      pts = [0.166666666666667, 0.166666666666667, 0.166666666666667
             0.5,               0.166666666666667, 0.166666666666667
             0.166666666666667, 0.5,               0.166666666666667
             0.166666666666667, 0.166666666666667, 0.5
             0.25,              0.25,              0.25];
      accuracy = 3;
    otherwise
      w = 0.166666666666667; % factor 1/6 is applied
      pts = [0.25, 0.25, 0.25];
      accuracy = 1;      
  end
end
function [w, pts, accuracy] = Hexahedron(order)
  % quadrature rule is defined from Line
  switch(order)
    case 0
      w = 8.0;
      pts = [0.0, 0.0, 0.0];
      accuracy = 2;
    case 1
      % integration points: -1/sqrt(3) 1/sqrt(3)
      % wight             :          1         1
      % 1/sqrt(3) = 0.577350269189626
      w = [1.0; 1.0; 1.0; 1.0; 1.0; 1.0; 1.0; 1.0];
      pts = [-0.577350269189626, -0.577350269189626, -0.577350269189626
              0.577350269189626, -0.577350269189626, -0.577350269189626
              0.577350269189626,  0.577350269189626, -0.577350269189626
             -0.577350269189626,  0.577350269189626, -0.577350269189626
             -0.577350269189626, -0.577350269189626,  0.577350269189626
              0.577350269189626, -0.577350269189626,  0.577350269189626
              0.577350269189626,  0.577350269189626,  0.577350269189626
             -0.577350269189626,  0.577350269189626,  0.577350269189626];
      accuracy = 4;
    case 2
      % integration points: -sqrt(3/5)  0   sqrt(3/5)
      % wight             :         5/9 8/9       5/9
      % sqrt(3/5) = 0.774596669241483
      % 5/9 = 0.555555555555556
      % 8/9 = 0.888888888888889
      w = [0.171467764060357; 0.274348422496571; 0.171467764060357
           0.274348422496571; 0.438957475994513; 0.274348422496571
           0.171467764060357; 0.274348422496571; 0.171467764060357
           0.274348422496571; 0.438957475994513; 0.274348422496571
           0.438957475994513; 0.702331961591221; 0.438957475994513
           0.274348422496571; 0.438957475994513; 0.274348422496571
           0.171467764060357; 0.274348422496571; 0.171467764060357
           0.274348422496571; 0.438957475994513; 0.274348422496571
           0.171467764060357; 0.274348422496571; 0.171467764060357];
      pts = [-0.774596669241483, -0.774596669241483, -0.774596669241483
                            0.0, -0.774596669241483, -0.774596669241483
              0.774596669241483, -0.774596669241483, -0.774596669241483
              0.774596669241483,                0.0, -0.774596669241483
                            0.0,                0.0, -0.774596669241483
             -0.774596669241483,                0.0, -0.774596669241483
             -0.774596669241483,  0.774596669241483, -0.774596669241483
                            0.0,  0.774596669241483, -0.774596669241483
              0.774596669241483,  0.774596669241483, -0.774596669241483
             -0.774596669241483, -0.774596669241483, 0.0
                            0.0, -0.774596669241483, 0.0
              0.774596669241483, -0.774596669241483, 0.0
              0.774596669241483,                0.0, 0.0
                            0.0,                0.0, 0.0
             -0.774596669241483,                0.0, 0.0
             -0.774596669241483,  0.774596669241483, 0.0
                            0.0,  0.774596669241483, 0.0
              0.774596669241483,  0.774596669241483, 0.0
             -0.774596669241483, -0.774596669241483, 0.774596669241483
                            0.0, -0.774596669241483, 0.774596669241483
              0.774596669241483, -0.774596669241483, 0.774596669241483
              0.774596669241483,                0.0, 0.774596669241483
                            0.0,                0.0, 0.774596669241483
             -0.774596669241483,                0.0, 0.774596669241483
             -0.774596669241483,  0.774596669241483, 0.774596669241483
                            0.0,  0.774596669241483, 0.774596669241483
              0.774596669241483,  0.774596669241483, 0.774596669241483
              ];
       accuracy = 6;
    otherwise
      w = [1.0; 1.0; 1.0; 1.0; 1.0; 1.0; 1.0; 1.0];
      pts = [-0.577350269189626, -0.577350269189626, -0.577350269189626
              0.577350269189626, -0.577350269189626, -0.577350269189626
              0.577350269189626,  0.577350269189626, -0.577350269189626
             -0.577350269189626,  0.577350269189626, -0.577350269189626
             -0.577350269189626, -0.577350269189626,  0.577350269189626
              0.577350269189626, -0.577350269189626,  0.577350269189626
              0.577350269189626,  0.577350269189626,  0.577350269189626
             -0.577350269189626,  0.577350269189626,  0.577350269189626];
      accuracy = 4;
  end
end