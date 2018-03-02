function [ array ] = swap_double( array,index, indexplus )

temp=array(index,1);
array(index,1)=array(indexplus,1);
array(indexplus,1)=temp;
temp=array(index,2);
array(index,2)=array(indexplus,2);
array(indexplus,2)=temp;

end