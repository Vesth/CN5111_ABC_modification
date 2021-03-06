function  ABC_gear_original

x_lo = 12;
x_up = 60;

iter = 0;

f = @(x1,x2, x3, x4) (1/6.931 - (x1*x2/(x3*x4)))^2;

%Generation of initial population (10 bees)
bees = zeros(10,4);

for (a = 1:4)
    for (b = 1:10)
        bees(b,a) = round(x_lo + rand*(x_up - x_lo));
    end
end

%Evaluation of food sources

for (b = 1:10)
    bees_fit(b) = f(bees(b,1),bees(b,2),bees(b,3),bees(b,4));
end
bestvar1_min = min(bees(:,1));
bestvar2_min = min(bees(:,2));
bestvar3_min = min(bees(:,3));
bestvar4_min = min(bees(:,4));

while (iter < 1000)
%Produce new food sources for employed bees

%%Employed bees stage
for (b = 1:10)
    a = randi(4);
    x_randomval = randi(10);
    while (x_randomval == b)
        x_randomval = randi(10);
    end
    newv = bees(b,:);
    newv(a) = round(bees(b, a) + (rand*2-1)*(bees(b,a) - bees(x_randomval, a)));
    if (f(newv(1), newv(2), newv(3), newv(4)) < f(bees(b,1), bees(b,2), bees(b,3), bees(b,4)))
        bees(b,1) = newv(1);
        bees(b,2) = newv(2);
        bees(b,3) = newv(3);
        bees(b,4) = newv(4);
    end
    if (bees(b,a) < x_lo)
        bees(b,a) = x_lo;
    end
    if (bees(b,a) > x_up)
        bees(b,a) = x_up;
    end
end

%Calculate the probability values for Onlookers

%%Evaluation of food sources
for (b = 1:10)
    bees_fit(b) = f(bees(b,1),bees(b,2),bees(b,3), bees(b,4));
end

%%change values of fitness for probability
v_totalf = sum(bees_fit);
inverse_bees_fit = zeros(1,10);
for (b = 1:10)
    inverse_bees_fit(b) = v_totalf/bees_fit(b);
end
bees_probability = zeros(1,10);
for (b = 1:10)
    bees_probability(b) = inverse_bees_fit(b)/sum(inverse_bees_fit);
end

%%Onlooker finds the index and possibly swaps the value
x = cumsum([0 bees_probability(:).'/sum(bees_probability(:))]);
x(end) = 1e3*eps + x(end);
[p_val p_idx] = histc(rand,x);
a = randi(4);
x_randomval = randi(10);
while (x_randomval == p_idx)
    x_randomval = randi(10);
end
newv = bees(p_idx,:);
newv(a) = round(bees(p_idx,a) + (rand*2-1)*(bees(p_idx,a) - bees(x_randomval,a)));
if (f(newv(1),newv(2),newv(3),newv(4)) < f(bees(p_idx,1), bees(p_idx,2),bees(p_idx,3), bees(p_idx,3)))
    bees(p_idx,1) = newv(1);
    bees(p_idx,2) = newv(2);
    bees(p_idx,3) = newv(3);
    bees(p_idx,4) = newv(4);
    
end
for (a = 1:4)
    if (bees(p_idx,a) < x_lo)
        bees(p_idx,a) = x_lo;
    end
end

if (bees(p_idx,a) > x_up)
    bees(p_idx,a) = x_up;
end

%find the current best solution
%%Evaluation of food sources
for (b = 1:10)
    bees_fit(b) = f(bees(b,1),bees(b,2),bees(b,3),bees(b,4));
end

%%min value (best bee)
[val, b] = min(bees_fit);
var1_min = bees(b,1);
var2_min = bees(b,2);
var3_min = bees(b,3);
var4_min = bees(b,4);

%if (abs(f(var1_min, var2_min) - f(bestvar1_min, bestvar2_min)) < 0.000001)
%    break;
%end

%if fitness stagnates, replace with new scout bee
if (iter == 0)
    new_bees_fit = bees_fit;
    stagnant_count = zeros(1,10);
else
    for (b = 1:10)
        if (abs(new_bees_fit(b) - bees_fit(b)) < 0.0001)
            if (stagnant_count(b) < 3)
                stagnant_count(b) = stagnant_count(b) + 1;
            else
            bees(b,1) = round(x_lo + rand*(x_up - x_lo));
            bees(b,2) = round(x_lo + rand*(x_up - x_lo));
            bees(b,3) = round(x_lo + rand*(x_up - x_lo));
            bees(b,4) = round(x_lo + rand*(x_up - x_lo));
            
            stagnant_count(b) = 0;
            end
        else
            new_bees_fit(b) = bees_fit(b);
            stagnant_count(b) = 0;
        end
        
    end
            
end

if (f(var1_min, var2_min, var3_min, var4_min) < f(bestvar1_min,bestvar2_min, bestvar3_min, bestvar4_min))
    bestvar1_min = var1_min;
    bestvar2_min = var2_min;
    bestvar3_min - var3_min;
    bestvar4_min = var4_min;
end

iter = iter + 1;
end
bestvar1_min
bestvar2_min
bestvar3_min
bestvar4_min
iter

