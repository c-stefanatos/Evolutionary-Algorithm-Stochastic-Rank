function [ pen2 ] = pen2( x1, x2 )
dist =(1- x1+(x2-4)^2);
if dist>0
    pen2=(dist);
else 
    pen2 = 0;
end
end



