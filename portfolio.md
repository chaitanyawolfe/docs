Update: Starting Aug 2018, Long Format is the default format for portfolio upload


# LQuant Portfolio Upload 

LQuant Portfolio Upload module allows you to upload custom portfolio into your database space. The custom porfolio (identified by a string id), once uploaded can be used for backtesting. In addition custom portfolio can be used to add custom attributes into the database. 

Below are a few use cases for this feature

1. Portfolio Tracking
2. Portfolio Rebalance
3. Portfolio Performance Summary
4. Interest List Tracking
5. Data Upload

Portfolio upload system seamlessly ties with the backtesting library to provide several performance metrics, such as Sharpe Ratio, Draw Down and several more. 

## Identifiers

*Following Identifiers can be used to upload the portfolio:*

1. TICKER (US Only)
   Ticker can be point in time or current known ticker. By default the ticker is assumed to be Point-in-Time. 
2. SEDOL 
   Sedol is the most robust identifier. System supports both point-in-time as well as last SEDOL for mapping. For US and CA companies, the SEDOL mapping only goes back to 2002
3. CUSIP (US and Canada Only)
   Cusip is a security level identifier that can be used. In case where we have more than one security per cusip, we map the US one if available, othewise we attempt to map to Canadian. The identifier can be specified as either point-in-time or most recent. 
4. BBTICKER
   Bloomberg Ticker is good recent updates. Our history for Bloomberg ticker only starts from May 2018. 
5. QESID (This is internal 
   This is QES internal idenfier

## Format

Following keywords in the file or data frame header are looked for:

1. DATED: Indicates date of Rebalance
2. TICKER/BBTICKER/CUSIP/CUSIP8/SEDOL/SEDOL6/QESID: Indicates Identifier
3. WEIGHT 
4. ..

Any number of additional properties can be added to the portfolio. All properties will become accessible for further processing using lquant library. 

In this example, the porfolio is specified at monthly frequency. For the first month, we had MSFT, APPL and IBM, and for the second month IBM is dropped and GOOG is added. The  format allows you to add addition attributes that are uploaded as factor in the LQuant database, e.g., you can choose to add weights 

|TICKER|DATED|WEIGHT|
|------|-----|------|
|MSFT|30-Apr-2010|0.3|
|AAPL|30-Apr-2010|0.4|
|IBM|30-Apr-2010|0.3|
|MSFT|31-May-2010|0.2|
|AAPL|31-May-2010|0.5|
|GOOG|31-May-2010|0.3|

Click [here](https://raw.githubusercontent.com/wolferesearch/docs/master/sample/LongFormatPort.csv) to download a sample Long Format File. 

After uploading LQuant will make the universe constituents available to the user and also provide WEIGHT as a factor. 

## 1. Uploading the portfolio

Portfolio can be uploading using either R or python API. 


### RCode
```R
myport<-wq.port.uploadFile('MyPortfolio1','/mnt/ebs1/data/Share/sample/LongPort.csv',global=FALSE,pitId=FALSE,shortFormat=FALSE)
```

### Python Code
```python
from lquantPy import LQuant
wq = LQuant.LQuant()
myPort = wq.port_upload_file('MyPortfolio1','/mnt/ebs1/data/Share/sample/LongPort.csv',global=FALSE,pitId=FALSE,shortFormat=FALSE)
```

*myport* is and R6 class that provides handle to the uploaded object. You can use this handle to query properties of the porfolio. There are several methods available under this that provide access/mutation operation on the portfolio. By default, the portfolio uploaded is visible to other users within your space, however, if you want to make it private, that can be done by changing the security properties of the portfolio. Portfolio can be mutated by the user. 

## 2. Access API

### A. Summary

Provides a succinct summary of the portfolio, i.e., Start Date, End Date, Number of Securities, Mapped Securities. The output comes back a simple data frame. Below are code snippets from R and python languages

### R Code
```R
myPort$summary()
```
### Python Code
```python
myPort.summary()
```

### B. Mapping

The identifiers in the portfolio file are mapped to LQuant internal identifier (QESID). In some cases, when the system is unable to map them based on the criteria. In such a scenario, the unmapped securities can be accessed

### R Code
```R
myPort$unmapped()
```
### Python Code
```python
myPort.unmapped()
```

### C. Attributes

Additional columns in the uploaded file (or data frame) is exposed as lquant attributes (prefixed with universe id). List of attributes can be accessed via a simple function. Below is the code to access the list

### R Code
```R
myPort$attributes()
```
### Python Code
```python
myPort.attributes()
```

### D. Owner

The owner (username) can be accessed via owner function

### R Code
```R
myPort$owner()
```
### Python Code
```python
myPort.owner()
```

### E. Dates

Rebalance dates can be accessed via dates function

### R Code
```R
myPort$dates()
```
### Python Code
```python
myPort.dates()
```

### F. Constituents

There are 2 functions 

### R Code
```R
myPort$dates()
```
### Python Code
```python
myPort.dates()
```


## Backtest API




## R API

R API is provided within the [wquantR](https://github.com/wolferesearch/docs/blob/master/r-api/wquantR.pdf) package hosted on our platform. The set of function exposed as wq.port provide access to the functions. Please the documentation within RStudio console for these functions. 

Here are specific example of the upload data


#### Uploading Portfolio using *wq.port.uploadFile*

```R
myport<-wq.port.uploadFile('MyPortfolio1',''/mnt/ebs1/data/Share/sample/LongPort.csv',
															,global=FALSE,pitId=FALSE,shortFormat=FALSE)
```
*myport* is and R6 class that provides handle to the uploaded object. You can use this handle to query properties of the porfolio. There are several methods available under this that provide access/mutation operation on the portfolio. By default, the portfolio uploaded is visible to other users within your space, however, if you want to make it private, that can be done by changing the security properties of the portfolio. Portfolio can be mutated by the user. 



1. delete (Deletes the portfolio)
2. exists (Checks if the portfolio exists in the database)
3. id     (String id for the portfolio)
4. owner  (Login name of the person who uploaded the portfolio)
5. summary (Quick summary of the portfolio in terms of number of stocks and start date)
6. unmapped (List of Unmapped identifiers)
7. uploadAttributes(This is the method to upload the attributes and is only supported for long format file). This should be called immediately after the upload of long format file. 




### 2. Short Format

Short format is just membership list, hence it captures the tenure pair of security membership in the index, here is a simple example of portfolio in short format

|TICKER|STARTDATE|ENDDATE|
|------|---------|--------|
|MSFT|30-Apr-2010|30-Jun-2010|
|IBM |30-Apr-2010|30-May-2010|
|AAPL|30-Apr-2010|30-Jun-2010|
|GOOG|31-May-2010|30-Jun-2010|

While this format is quick to upload and faster to work with, this does not allow custom attributes to be uploaded. 

Click [here](https://raw.githubusercontent.com/wolferesearch/docs/master/sample/ShortFormatPort.csv) to download a sample Long Format File. 

## Identifier

LQuant Portfolio Uploader supports SEDOL(7 character), TICKER and CUSIP(9 character) as identifier to link security internally. The security can be linked either using the point in time identifier (more accurate) or most recent identifier. The uploader uses the header names to detect the Identifier. In case there are multiple identifier in the file/data then it searches in the following order SEDOL, CUSIP, TICKER. 

1. SEDOL
2. CUSIP
3. TICKER



## Mapping (Global vs US/Canada)
Portfolio can be uploaded in Global or US/Canada mode. Since internally LQuant maintains separate identifiers for US/Canada stocks, it is usually advisable to use the US/Canada mode for US/Canada universe. This way, there is less loss when mapping the identifier to internal one. 





Once the portfolio is uploaded you can use it as an LQuant Universe. For long format files, please ensure to call uploadAttributes() method in order to ensure that factor data is also persisted in the database. 

Querying Data

```R
data<-wq.getdata(wq.newRequest()$runFor('MyPortfolio1')$from('2012-02-28')$to('2017-02-28')$at('1m')$a('IN_MyPortfolio1')$a('MyPortfolio1_Weight')$a('PRCCD'))
```

The above function will use the securities in the uploaded portfolio to query data at monthly frequency from the LQuant Data API. Note that *MyPortfolio1_Weight* is a custom factor that was uploaded in the database using the long format file


#### Listing portfolio using the *wq.port.list* function

```R
	allcustomports<-wq.port.list()
  myports<-wq.port.list(TRUE)
```

The function takes a boolean flag to filter out porftolio portfolios that are uploaded by other users. Note that you can access other users portfolios, but cannot delete or update them. The id is unique in the system, hence if one user has used *MyPortfolio1* as the Id for the portfolio, it cannot be used by another user. 






## Python API
Coming Soon


 





