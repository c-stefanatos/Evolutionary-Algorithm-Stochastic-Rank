function [ array ] = swap_single( array,index, indexplus )
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here
temp=array(index,1);
array(index,1)=array(indexplus,1);
array(indexplus,1)=temp;

end

