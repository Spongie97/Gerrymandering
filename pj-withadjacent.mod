param M := 4;  #number of state
param N := 403;  #number of county
param D{i in 1..N}>=0;  #vote of demo
param R{i in 1..N}>=0;  #vote of republic

var b{k in 1..M, i in 1..N} binary;  
#if county i is in state k,b[k,i]=1,otherwise 0 

var z{k in 1..M} binary;
#determine demo wins in state k or not 

var n{k in 1..M};
#number of votes in each states

var w{k in 1..M};
#number of wasted vote in each states

minimize wasteVote: sum{k in 1..M} w[k];

subject to least{k in 1..M}:
sum{i in 1..N}b[k,i]>=1;
#every state should have at least one county

subject to oneBag{i in 1..N}:
sum{k in 1..M}b[k,i]=1;
#every county should be in just one state

subject to descendFirst:
sum{k in 1..M}k*b[k,1]=M;
#the county should put in states in descending order

subject to descendLast:
sum{k in 1..M}k*b[k,N]=1;
#the county should put in states in descending order

subject to descending1{i in 1..N-1}:
sum{k in 1..M}k*(b[k,i]-b[k,i+1])>=0;
#the county should put in states in descending order

subject to descending2{i in 1..N-1}:
sum{k in 1..M}k*(b[k,i]-b[k,i+1])<=1;
#the county should put in states in descending order

subject to win{k in 1..M}:
(sum{i in 1..N}b[k,i]*(D[i]-R[i]))<=3000000*z[k];
#if demo wins in state k, z[k]=1

subject to lose{k in 1..M}:
(sum{i in 1..N}b[k,i]*(R[i]-D[i]))<=3000000*(1-z[k]);
#if demo loses in state k, z[k]=0

subject to numberForEachState{k in 1..M}:
n[k] = sum{i in 1..N}b[k,i]*(D[i]+R[i]);
#calculate the population of each state

subject to waste1{k in 1..M}:
z[k] = 0 ==> w[k] = sum{i in 1..N}b[k,i]*D[i];
#calculate the wasted vote

subject to waste2{k in 1..M}:
z[k] = 1 ==> w[k] = sum{i in 1..N}b[k,i]*(D[i]-R[i]);
#calculate the wasted vote

