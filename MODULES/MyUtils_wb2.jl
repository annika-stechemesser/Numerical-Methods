## Functions Workbook 2 Question 1
 

# Function 1.1

##This function generates key value pairs. The keys are integers from 1 to n in ascending order and the values are random numbers. 
#Input: desired number of KVPairs
#Output: array of KVPairs
function create_KVPairs(n)
    seed = 1235 
    rng = MersenneTwister(seed)
    X = rand(rng, n)
    values = Array{KVPair}(n)
    for i in 1:n
        values[i] = KVPair(i,X[i])
    end
    return values
end

#FUNCTION 1.2

## This function is the answer to Q1 Part 1 and therefore also included in the notebook.
#Input: list
#Output: print of the key values of the KV Pairs
function list_traverse(LList::Nullable{LList})  #the input needs to be of the type "Nullable{LList}"
    L=LList
    k=get(L).data  #k=key value pair of the list
    k1=k.key       # k = key of the list 
    println(k1)    # print the key
    L=get(L).next  # let L be the list that is stored in LList
    if isnull(L)==false # if L is not null, we want to repeat the process (recursive function)
         list_traverse(L)
    end    
end 

#FUNCTION 1.3

## This function is the answer to Q1 Part 2 and therefore also included in the notebook.
#Input: list, key we want to search for
#Output: KVPair that has the key we searched for
function list_search(LList::Nullable{LList}, a::Int64) 	#the input needs to be of the type "Nullable{LList}", "Int64"
    L=LList
    k=get(L).data 					#k=key value pair of the list
    k1=k.key      					# k1 = key of the list 
    if (k1 == a)  					# if the key is the one we're looking for, return the key value 							pair k
        return(k)
    else
        L=get(L).next 					# else update the list and repeat the process (recursive function)
        list_search(L,a)    
    end
end

#FUNCTION 1.4

## This function is checking if the previously defined function "list_search" is working correctly. 
#Input: desired list size
#Output: statement about the function "list_search"
function working_search(n::Int64) 		# takes a desired list size as input value
    values=create_KVPairs(n)  			# uses the function "create_KVPairs" to build an array of KV pairs
    L=buildLList(values); 			# uses the function "buildLList" to turn them into a list
    working=true 				# set the boolian variable "working" to "true"
    for i=1:length(values)    			#search for every possible key
        if (list_search(L,i).key != values[i].key) 
						#if "list_search" finds a key (of a KVPair) that doesn't match the original 							one -> working = false 
            println("The function does not work correctly.")
            working=false
						# if "list_search" finds a value (of a KVPair) that doesn't match the 							original one -> working = false
        elseif (list_search(L,i).value != values[i].value)
            println("The function does not work correctly.")
            working=false
        end
    end
						# if "list_search" works correctly this function will display it in the 						workbook.
    if working==true
        println("The function works correctly.")    
    end
end


#FUNCTION 1.5

## This function evaluates the growth of the computational cost for an increasing list size of the function "list_search".
#Input: linspace (has maximal list size, stepwidt)
#Output: mean of the running times (search for every possible key) for each list size
function Cost_List_search(x)
Time=zeros(length(x))
	counter=1
        for i in x
            Sub_time=zeros(i)
            values=create_KVPairs(i)
            L=buildLList(values)

            for j=1:i
            Sub_time[j]=(@timed list_search(L,j))[2]
            end
            Time[counter]=mean(Sub_time)
	    counter=counter+1
        end
    return Time
end

##Functions Workbook 2 Question 2

#FUNCTION 2.1

## This function is the answer to Q2 Part 1 and therefore also included in the notebook.
#Input: desired number of intervals
#Output: list of KVPairs, have the interval index and the upper interval boundary
function create_KVPairs_partial_sums(n) #desired number of intervals
    seed = 1235 
    rng = MersenneTwister(seed)
    X = rand(rng, n)                    #random array of length n
    values = Array{KVPair}(n)           #empty array with n KVPairs
    for i in 1:n                     
        x=sum(X[1:i])                   #compute the cumulative sum of the first i values of X
        values[i]=KVPair(i,x)           # define the KV pair
    end
    return values                       #return the array of KVPairs
end


#FUNCTION 2.2

## This function is the answer to Q2 Part 2 and therefore is also included in the notebook.
#Input: list, value we want to match to an interval
#Output:KVPair, has the interval index and the upper interval boundary

function intervalmembership(list::Nullable{LList},x::Float64) #The input has to be a Nullable{LList} and a Float64
    L=list
    k=get(L).data   #k is the key value pair at the top of the list (corresponding to the first interval)
    k2=k.value      #k2 is the upper interval border
    if (x < k2)     #if x is smaller than the interval border, it is in the interval, return the corresponding KVPair
        return(k)  
        else        #if the x is not smaller than the upper interval border, it has to be in one of the higher intervals 
        L=get(L).next #update the list to the next interval
        intervalmembership(L,x) #repeat the process (recursively)
        
    end
end

#FUNCTION 2.3

#This function evaluates the computational effort of the function "intervalmembership" with growing number of intervals. #Input: maximal number of intervals, number of iterations per number of intervals
#Output: mean Time per interval length, standard deviation per interval length
function Cost_lin_interval(x,m::Int64)
Time=zeros(length(x))
Std=zeros(length(x))
counter=1
for i in x
    Sub_time=zeros(m)
     for j=1:m
        values=create_KVPairs_partial_sums(i)
        L=buildLList( values)
        x=rand()*values[i].value
        Sub_time[j]=(@timed intervalmembership(L,x))[2];
      end
    Time[counter]=mean(Sub_time)
    Std[counter]=std(Sub_time)
    counter=counter+1
end
    return Time,Std
end

#FUNCTION 2.4


## This function is the answer to Q2 Part 3 and therefore is also influcded in the notebook.
#Input: List, value we want to match to an interval
#Output: KVPair, has the interval index, upper interval boundary
function intervalmembership_tree(FT::Nullable{FTree},x::Float64) #the input needs to be of the type "Nullable{LList}", "Int64" 
    l=get(FT).left                            #let l be the left subtree
    r=get(FT).right                           #let r be the right subtree
    k=get(FT).data                            #let k be the stored KVPair
    if (isnull(l)==true && isnull(r)==true)   #if both subtrees are empty, we are in a leaf and found the interval
        return(k)                                             
        elseif (isnull(l) ==false && x<get(l).data.value) #if the leftsubtree is not empty and x is smaller than the key value stored there go left
            intervalmembership_tree(l,x)      #repeat the process with the left subtree
        elseif (isnull(r)==false)             # if the rightsubtree is not empty and we're not in one of the previous cases
            x=x-get(l).data.value             #update x to be x-key value of the left subtree  
            intervalmembership_tree(r,x)      #repeat the process with the right subtree
    end
end

#FUNCTION 2.5

# this function generates the arrays of KVPairs that are needed two compare our two methods of solving the interval membership problem. 
#Input: desired number of KVPairs
#Output: Two arrays of KVPais,one with random numbers as values and one with partial sums of these random values as values. 
function create_list_sumlist(n)
    seed = 1235 
    rng = MersenneTwister(seed)
    X = rand(rng, n)
    values = Array{KVPair}(n)
    sum_values= Array{KVPair}(n)
    for i in 1:n
        values[i] = KVPair(i,X[i])
        s=sum(X[1:i])
        sum_values[i]=KVPair(i,s)
    end
    return values,sum_values
end

#FUNCTION 2.6

#This function evaluates the computational effort of the function "intervalmembership_tree" with growing number of intervals. 
#Input: linspace(gives max. list size, stepwidth), number of iterations per number of intervals
#Output: mean execution time per list length, standard deviation per list length
function Cost_tree_interval(x,m)
Time=zeros(length(x))
Std=zeros(length(x))
counter=1
for i in x
    Sub_time=zeros(m)
     for j=1:m
    values=create_KVPairs(i)
    L=buildLList(values);
    T = Nullable{FTree}(FTree(KVPair(0,0.0)));
        
    T=buildFTree(T, values);    
    y=rand()*values[i].value
       Sub_time[j]=(@timed intervalmembership_tree(T,y);)[2]
      end
    Time[counter]=mean(Sub_time)
	Std[counter]=std(Sub_time)
    counter=counter+1
end
    return Time,Std
end

#FUNCTION 2.7

## This function is build to compare the running times of the linear search solution to the interval membership problem and the solution using the fenwick tree. 
#Input: linspace x and the number of iterations per fixed list size m. 
# Output: mean time difference and the standard deviation for each considered list length.
function time_compare(x,m)
Time=zeros(length(x))
Std=zeros(length(x))
counter=1
for i in x
    Sub_time=zeros(m)
    Sub_time_tree=zeros(m)
    for j=1:m
        lists=create_list_sumlist(i)
        L=buildLList(lists[2])
        T = Nullable{FTree}(FTree(KVPair(0,0.0)))
        T=buildFTree(T, lists[1])
        C=lists[2]
        y=rand()*C[i].value
    
        Sub_time[j]= (@timed intervalmembership(L,y);)[2]
        Sub_time_tree[j]=(@timed intervalmembership_tree(T,y);)[2]
    end
    Time[counter]=abs(mean(Sub_time-Sub_time_tree))
    Std[counter]=std(Sub_time-Sub_time_tree)
    counter=counter+1
end
    return Time,Std
end
## Functions Question 3

#FUNCTION 3.1

# This is the adapted code from Question 3.1
# Input: number of particles
# Output: X, P=estimated density of the particles
function particle_linear(N)
    L=10
    Nx = 201
    dx = 2.0*L/(Nx-1)
    X = dx.*(-(Nx-1)/2:(Nx-1)/2)
    Y =zeros(Int64,N)
    D = 1.0 				#fix the mean to be 1.0
    t=0.0
    T=1.0				#fix the time to be 1.0

    Rates=zeros(2*N)			#initialize an array of length 2N for the rates
    Rates[1:N]=randexp(N)*D		#draw the first N rates from the exponential distribution with mean D
    Rates[N+1:2N]=Rates[1:N]		#make sure that the forward- and backwardsrates are the same (Rates[i]=Rates[N+i])
    Rates=Rates.*(1/2(dx*dx))           #scale according to the formula from before (r_i=(D/2)*(1/dx^2))
    
    totalRate=sum(Rates)		#calculate the total rate
    
    dt = 1.0/totalRate			#scale the time

    KV_Rates=Array{KVPair}(2*N)    	#initialize the array of KVPairs

    for i=1:2*N				#build the list (needed to solve the interval membership problem)
        x=sum(Rates[1:i])
        KV_Rates[i]=KVPair(i,x)
    end
    Rates_list=buildLList(KV_Rates)

    #This is the main loop

    while t < T
  
        k = rand(1:totalRate)				# Pick an event 
        interval=intervalmembership(Rates_list,k)	#solve the intervalmembership problem
       
          interval=interval.key				#find the corresponding interval key
     
        if interval<=N					#decide which way to hop and update the particle ID 
            hop = 1
            particleId = interval
        else
            hop = -1
            particleId=interval-N
        end
        Y[particleId]+=hop				#update Y
        t+=dt						#update t
    end

    #Calculate the estimated density of particles
    P =zeros(Float64,length(X))
    for i in 1:length(Y)
        P[Y[i]+Int64((Nx-1)/2)+1]+=1/(N * dx)
    end
    return X,P
end

#FUNCTION 3.2

## This is the theoretical prediction of the particle density

function normal(x, D, t)
    return (exp(-sqrt(2/D*t)*abs(x))/sqrt(2D*t))
end


###



#FUNCTION 3.3

## This is the adapted code of Question 3.2
#Input: Number of particles
#Output: X, P=estimated particle density

function particle_tree(N)
    L=10.0
    Nx = 201
    dx = 2.0*L/(Nx-1)
    X = dx.*(-(Nx-1)/2:(Nx-1)/2)
    Y =zeros(Int64,N)
    D = 1.0 				#fix the mean to be 1.0
    t=0.0
    T=1.0				#fix the time to be 1.0

    Rates=zeros(2*N)			#initialize an array of length 2N for the rates
    Rates[1:N]=randexp(N)*D		#draw the first N rates from the exponential distribution with mean D
    Rates[N+1:2N]=Rates[1:N]		#make sure that the forward- and backwardsrates are the same (Rates[i]=Rates[N+i])
    Rates=Rates.*(1/2(dx*dx))           #scale according to the formula from before (r_i=(D/2)*(1/dx^2))
    
    totalRate=sum(Rates)		#calculate the total rate
    
    dt = 1.0/totalRate			#scale the time

    KV_Rates_tree=Array{KVPair}(2*N)    #initialize the array of KVPairs

    for i=1:2*N				#build the list (needed to solve the interval membership problem) 
        x=Rates[i]			# don't consider the cumulative sum this time!
        KV_Rates_tree[i]=KVPair(i,x)
    end
    Tree = Nullable{FTree}(FTree(KVPair(0,0.0)))	#build the tree
    Tree=buildFTree(Tree, KV_Rates_tree)


    #This is the main loop
    while t < T
 
        k = rand(1:totalRate)				# Pick an event 
        interval=intervalmembership_tree(Tree,k)	#solve the intervalmembership problem using the Fenwick tree
          interval=interval.key				#find the corresponding interval key
        if interval<=N					#decide which way to hop and update the particle ID 
            hop = 1
            particleId = interval
        else
            hop = -1
            particleId=interval-N
        end
        Y[particleId]+=hop
        t+=dt
    end

    #Calculate the estimated density of particles
    P =zeros(Float64,length(X))
    for i in 1:length(Y)
        P[Y[i]+Int64((Nx-1)/2)+1]+=1/(N * dx)
    end
    return X,P
end



