clc
clear all
format long
minimum_t=NaN(1);
winning_gen=NaN(1);
winning_index=NaN(1);
winning_coordinates=NaN(1,2);
limits=[0,10;0,10];
q_par = 30;
q_child = 210;
n=2;
x = zeros (q_child,n);
x_mutate = zeros (q_child,n);
parent=zeros(q_par,n);
backup = zeros(q_child,n);
sigma=zeros(q_child,n);
taf_ton=1/((2*n^(1/2))^(1/2));%for change of sigma
taf=1/((2*n)^(1/2));%for change of sigma


%initialize sigma (mutations coefficient)
for i=1:q_child
sigma(i,1)=(limits(1,2)-limits(1,1))/(2^(1/2));
sigma(i,2)=(limits(2,2)-limits(2,1))/(2^(1/2));
end
%ano oria for sigma
upper_sigma(1,1)=sigma(1,1);
upper_sigma(1,2)=sigma(1,2);

%initialize fitness & penalnty function
f=zeros(q_child,1);
pen_total=zeros(q_child,1);

%first random praktores
for i=1 : q_child;
             x(i,1)= limits(1,1)+(limits(1,2)-limits(1,1))*rand;
             x(i,2)= limits(2,1)+(limits(2,2)-limits(2,1))*rand;
             f(i,1)=main_fun(x(i,1),x(i,2));
    pen_total(i,1)=pen1(x(i,1),x(i,2))+pen2(x(i,1),x(i,2));
end

%enter selection, crossover for sigmas, mutation loop
gen=0;
while gen<=200
swap=1;
comps=0;
while (swap==1) && (comps<=q_child)
    swap=0;
     for i=1:(q_child-1-comps)
         u=rand;
         if ((pen_total(i,1)==0) &&(pen_total(i+1,1)==0))||(u<0.35)
             if f(i,1)>f(i+1,1)%smallest goes highest
                 f=swap_single(f,i,i+1);
                 x=swap_double(x,i,i+1);
                 sigma=swap_double(sigma,i,i+1);
                 pen_total=swap_single(pen_total,i,i+1);
                 swap=1;
             end
         else
             if pen_total(i,1)>pen_total(i+1,1)%smallest penalnty goes highest
                 f=swap_single(f,i,i+1);
                 x=swap_double(x,i,i+1);
                 sigma=swap_double(sigma,i,i+1);
                 pen_total=swap_single(pen_total,i,i+1);
                 swap=1;
                 
             end
         end
        
     end
      comps=comps+1;
      
end

%store optimal solution so far
zeropen=find(pen_total==0);%deiktes i gia feasible coordinates
if ~isempty(zeropen)%an yparxoun stoixeia me pen=0(feasible)
[unchecked_min,unchecked_index]=min(f(zeropen));
    if unchecked_min<minimum_t || isnan(minimum_t)
        minimum_t=unchecked_min;
        winning_gen=gen;
        winning_index=unchecked_index;
        winning_coordinates=x(winning_index,:);
    end
end
for i=1:q_par
    parent(i,1)=x(i,1); %krata tous kalyterous 30
    parent(i,2)=x(i,2);
    %apo kathe gonio 7 kids
    for j=1:7
    backup((i-1)*7+j,1)=parent(i,1);
    backup((i-1)*7+j,2)=parent(i,2);
    %crossover only for sigmas
    sigma((i-1)*7+j,1)=(sigma(i,1)+sigma(ceil(q_par*rand),1))/2;
    sigma((i-1)*7+j,2)=(sigma(i,2)+sigma(ceil(q_par*rand),2))/2;
    end
end



%new sigma
for i=1:q_child
common=normrnd(0,1);%koino gia oles tis diastaseis enos kid
for j=1:n 
 sigma(i,j)=sigma(i,j)*exp(taf_ton*common+(taf*normrnd(0,1)));
 if sigma(i,j)>upper_sigma(1,j)
     sigma(i,j)=upper_sigma(1,j);
 end
end
end



%mutate
for i=1:q_child
    for j=1:n
    x_mutate(i,j)= backup(i,j) + normrnd(0,sigma(i,j));
    reps=0;
    while ((x_mutate(i,j)<limits(j,1))||(x_mutate(i,j)>limits(j,2)))&&reps<10
            x_mutate(i,j)= backup(i,j) + normrnd(0,sigma(i,j));
            reps=reps+1;
    end
        if reps==10
            x_mutate(i,j)=backup(i,j);
        end
    end
  
end

 
      
%reevaluate for new mutated kids
for i=1:q_child
   
 x(i,1)= x_mutate(i,1);
 x(i,2)= x_mutate(i,2);
 f(i,1)=main_fun(x(i,1),x(i,2));
 pen_total(i,1)=(pen1(x(i,1),x(i,2))+pen2(x(i,1),x(i,2)));
end
gen=gen+1;
end

%sort last population
swap=1;
comps=0;
while (swap==1) && (comps<=q_child)
    swap=0;
     for i=1:(q_child-1-comps)
         u=rand;
         if ((pen_total(i,1)==0) &&(pen_total(i+1,1)==0))||(u<0)
             if f(i,1)>f(i+1,1)%smallest goes highest
                 f=swap_single(f,i,i+1);
                 x=swap_double(x,i,i+1);
                 pen_total=swap_single(pen_total,i,i+1);
                 swap=1;
             end
         else
             if pen_total(i,1)>pen_total(i+1,1)%smallest penalnty goes highest
                 f=swap_single(f,i,i+1);
                 x=swap_double(x,i,i+1);
                 pen_total=swap_single(pen_total,i,i+1);
                 swap=1;
                 
             end
         end
        
     end
      comps=comps+1;
      
end

%check last gen for possibe min
zeropen=find(pen_total==0);
if ~isempty(zeropen)
[unchecked_min,unchecked_index]=min(f(zeropen));
    if unchecked_min<minimum_t || isnan(minimum_t)
        minimum_t=unchecked_min;
        winning_gen=gen;
        winning_index=unchecked_index;
        winning_coordinates=x(winning_index,:);
    end
end
'minimum'
minimum_t
'coordinates'
winning_coordinates
'generation'
winning_gen