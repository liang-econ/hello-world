##memoization using C++;
library(Rcpp)
library(inline)

mincltxt<-'
#include <algorithm>
#include <vector>
#include <stdexcept>
#include <cmath>
#include <iostream>

using namespace std;
class Fib{
public:
   Fib (unsigned int n=1000){
   memo.resize(n);
   fill(memo.begin(),memo.end(),NAN);
   memo[0]=0.0;
   memo[1]=1.0;
}
   double fibonacci(int x){
     if (x<0) 
        return(  (double) NAN); 
     if (x>=(int) memo.size())
        throw range_error(\"x too large for implementation\");
     if (!isnan(memo[x]))
        return(memo[x]);
    
 
     memo[x]=fibonacci(x-2)+fibonacci(x-1);
     return(memo[x]);
}
private:
    vector<double> memo;
};
'

mfibRcpp<-cxxfunction(signature(xs="int"),
                      plugin="Rcpp",
                      include=mincltxt,
                      body='
  int x=Rcpp::as<int>(xs);
  Fib f;
  return Rcpp::wrap(f.fibonacci(x-1));
')
