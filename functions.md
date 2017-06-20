# Functions support in LQuant

LQuant allows you to create your own factors using existing functions. This can be achived by using the wq.define method in R API and LQuant.define method in lquantPy package. 


Following are the list of functions available


# In Line Regular Functions

|Function | Description | Example |
|--------|-------------| --------|
| abs    |Computes absolute value. For NA and NaN, this returns NaN | abs(PRCCD/EPSX12) | 
| pow    |Computes power function | pow(PRCCD/EPSX12,3) | 
| nvl    |Returns the first value (PRCHD) when not NA or NaN otherwise second (PRCCD)| nvl(PRCHD,PRCCD) | 
| ifelse |Logical operator taking 3 operands, first one boolean, when the first operand is true then second operand is returned, otherwise  third| ifelse(PRCCD<5.0,5.0,PRCCD) | 
| nullif |Logical operator taking 2 operands, first one boolean, when the first operand is true then it returns NaN otherwise second operand| nullif(EPSPX12<0.0,EPSPX12) | 
| isnull |Single operand operator, return true if the operand is null | isnull(EPSPX12) |
| days_between |Returns number of days between the operands | days_between(SALEQ.DATADATE,POINTDATE) |
| min | Returns minimum of 2 operands| min(PRCCD,100.0) |
| max | Returns maximum of 2 operands| max(PRCCD,100.0) |


# Timeseries Functions
