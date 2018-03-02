function [ pen1 ] = pen1( x1,x2  )
dist=(x1^2-x2+1);
if dist>0
    pen1=(dist);
else
    pen1=0;
end
end

