# LQuant Portfolio Upload 



LQuant Portfolio Upload module allows you to upload custom portfolio into your database space. The custom porfolio (identified by a string id), once uploaded can be used for backtesting. In addition custom portfolio can be used to add custom attributes into the database. 





## **Supported Format**

### 1. Long Format
	
Long Format is a true porfolio format with constituents for each rebalance date. Here is a minimalistic sample of long porfolio:

|TICKER|DATED|
|------|-----|
|MSFT|30-Apr-2010|
|AAPL|30-Apr-2010|
|IBM|30-Apr-2010|
|MSFT|31-May-2010|
|AAPL|31-May-2010|
|GOOG|31-May-2010|

In this example, the porfolio is specified at monthly frequency. For the first month, we had MSFT, APPL and IBM, and for the second month IBM is dropped and GOOG is added. The  format allows you to add addition attributes that are uploaded as factor in the LQuant database, e.g., you can choose to add weights 

|TICKER|DATED|WEIGHT|
|------|-----|------|
|MSFT|30-Apr-2010|0.3|
|AAPL|30-Apr-2010|0.4|
|IBM|30-Apr-2010|0.3|
|MSFT|31-May-2010|0.2|
|AAPL|31-May-2010|0.5|
|GOOG|31-May-2010|0.3|

After uploading LQuant will make the universer constituents available to the user and also provide WEIGHT as a factor. 

### 2. Short Format

Short format is just membership list, hence it captures the tenure pair of security membership in the index, here is a simple example of portfolio in short format

|TICKER|STARTDATE|ENDDATE|
|------|---------|--------|
|MSFT|30-Apr-2010|30-Jun-2010|
|IBM |30-Apr-2010|30-May-2010|
|AAPL|30-Apr-2010|30-Jun-2010|
|GOOG|31-May-2010|30-Jun-2010|

While this format is quick to upload and faster to work with, this does not allow custom attributes to be uploaded. 


## Identifier

LQuant Portfolio Uploader supports SEDOL(7 character), TICKER and CUSIP(9 character) as identifier to link security internally. The security can be linked either using the point in time identifier (more accurate) or most recent identifier. The uploader uses the header names to detect the Identifier. In case there are multiple identifier in the file/data then it searches in the following order SEDOL, CUSIP, TICKER. 

1. SEDOL
2. CUSIP
3. TICKER



## Mapping (Global vs US/Canada)
Portfolio can be uploaded in Global or US/Canada mode. Since internally LQuant maintains separate identifiers for US/Canada stocks, it is usually advisable to use the US/Canada mode for US/Canada universe. This way, there is less loss when mapping the identifier to internal one. 


## R API

R API is provided within the [wquantR](https://github.com/wolferesearch/docs/blob/master/r-api/wquantR.pdf) package hosted on our platform. The set of function exposed as wq.port provide access to the functions. Please the documentation within RStudio console for these functions. 


## Python API
Coming Soon


 





