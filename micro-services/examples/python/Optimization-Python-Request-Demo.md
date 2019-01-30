
# Python API
apply python function to call the optimization and risk model APIs

```python
# Input: Postman token 
test_token = '5bc0a1a2-f3f9-4f29-8bcb-0eca2cb76a25'
```


```python
import requests
import json
import pandas as pd
```

## Optimization API
feature argument - json format:
```json
{
   "alpha": "QES_LEAP_1_SCORE",
   "template" : "default",
   "portfolio" : "SP500",
   "startDate" : "2018-09-30",
   "endDate" : "2018-12-31",
   "freq" : "1me",
   "notionalValue" : 100000000,
   "baseCurrency" : "USD",
   "riskModel" : 
       {
         "universe": "SP500",
         "template" : "default"
       }
}
```

**optimization_call**: 

call the API and derive the optimal portfolio weights of pandas dataframe format


```python
def optimization_call(postman_token, 
                      alpha = "QES_LEAP_1_SCORE", 
                      template = "default",
                      portfolio = "SP500",
                      startDate = "2018-09-30",
                      endDate = "2018-12-31",
                      freq = "1me", notionalValue = 100000000,
                      baseCurrency = "USD",
                      riskModel = '{"universe": "SP500","template" : "default"}',
                      verbose = True, saveFlag = True, savePath = '.'):
    '''
    call the optimization API and generate the corresponding Postman UUID token, 
    fectch and save the optimal weights and summary into pandas dataframe type
    Inputs:
        alpha: signal
        portfolio: universe
        startDate: start trading date
        endDate: end trading date
        freq: trading frequency
        verbose: boolean value of whether display the running status
        saveFlag: boolean value of whether save the file 
        savePath: file path for saving data
    Outputs:
        dictionary contains the status of API calling, portfolio optimal weights and summary 
    '''
    # get the header & args 
    headers = {
    'Authorization': 'Basic aGphaW46aGphaW4xMjM=','Content-Type': 'application/json',
    'Postman-Token': postman_token,
    'cache-control': 'no-cache',
    }
    args_data = {"alpha": alpha,
                 "template" : template,
                 "portfolio" : portfolio,
                 "startDate" : startDate,
                 "endDate" : endDate,
                 "freq" : freq,
                 "notionalValue" : notionalValue,
                 "baseCurrency" : baseCurrency,
                 "riskModel" : riskModel
                }
    # derive the API token
    uid = token_access(args_data, headers, verbose= verbose)
    
    callFlag = True
    if uid is None:
        # unsuccessful call
        callFlag = False
    
    # accesss Weight
    df_weight = data_process(uid, headers, saveFlag=saveFlag, savePath=savePath)
    # access Summary 
    df_summary = data_process(uid, headers, feature= 'Summary', saveFlag=saveFlag, savePath=savePath)
    
    return {'status': callFlag, 'weight': df_weight, 'summary':df_summary}
```

* usage showcase


```python
# Optimization results dictionary with default inputs
result_dic = optimization_call(test_token)
```


```python
# Weight display
result_dic['weight']
```

<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>DATE</th>
      <th>ID</th>
      <th>Sedol</th>
      <th>Ticker</th>
      <th>Company Name</th>
      <th>Sector</th>
      <th>Industry Group</th>
      <th>Country</th>
      <th>Currency</th>
      <th>IssuerId</th>
      <th>WEIGHT</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>259</th>
      <td>2018-09-30</td>
      <td>9KRRG25L84</td>
      <td>BD0PJ08</td>
      <td>COL</td>
      <td>Inmobiliaria Colonial</td>
      <td>SOCIMI</td>
      <td>S.A.</td>
      <td>60</td>
      <td>6010</td>
      <td>ES</td>
      <td>50</td>
    </tr>
    <tr>
      <th>322</th>
      <td>2018-09-30</td>
      <td>9NJJO3GPRZ</td>
      <td>7025471</td>
      <td>EGL</td>
      <td>Mota-Engil</td>
      <td>SGPS</td>
      <td>S.A.</td>
      <td>20</td>
      <td>2010</td>
      <td>PT</td>
      <td>50</td>
    </tr>
    <tr>
      <th>363</th>
      <td>2018-09-30</td>
      <td>ZVVV283MPZ</td>
      <td>5962934</td>
      <td>SEM</td>
      <td>Semapa - Sociedade de Investimento e Gestão</td>
      <td>SGPS</td>
      <td>S.A.</td>
      <td>15</td>
      <td>1510</td>
      <td>PT</td>
      <td>50</td>
    </tr>
    <tr>
      <th>490</th>
      <td>2018-09-30</td>
      <td>ZVVVKK0K1Z</td>
      <td>5973992</td>
      <td>SON</td>
      <td>Sonae</td>
      <td>SGPS</td>
      <td>S.A.</td>
      <td>30</td>
      <td>3010</td>
      <td>PT</td>
      <td>50</td>
    </tr>
    <tr>
      <th>633</th>
      <td>2018-09-30</td>
      <td>92VVWDL039</td>
      <td>4657736</td>
      <td>COR</td>
      <td>Corticeira Amorim</td>
      <td>S.G.P.S.</td>
      <td>S.A.</td>
      <td>15</td>
      <td>1510</td>
      <td>PT</td>
      <td>50</td>
    </tr>
  </tbody>
</table>




```python
# Summary
result_dic['summary']
```

<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>Alpha</th>
      <th>Ex-Ante Risk</th>
      <th>Ex-Ante Tracking Error</th>
      <th>Turnover</th>
      <th>Max Turnover</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>1</th>
      <td>0.34771553678194</td>
      <td>0.0975385350142646</td>
      <td>0.0975385350142646</td>
      <td>1.99999962340783</td>
      <td>NA</td>
    </tr>
    <tr>
      <th>2</th>
      <td>0.355137553618081</td>
      <td>0.107704547829215</td>
      <td>0.107704547829215</td>
      <td>1.44999721432476</td>
      <td>NA</td>
    </tr>
    <tr>
      <th>3</th>
      <td>0.288000411658759</td>
      <td>0.104215536770768</td>
      <td>0.104215536770768</td>
      <td>1.49999918674998</td>
      <td>NA</td>
    </tr>
    <tr>
      <th>4</th>
      <td>0.24134166758503</td>
      <td>0.0971503585210817</td>
      <td>0.0971503585210817</td>
      <td>1.49654598552549</td>
      <td>NA</td>
    </tr>
  </tbody>
</table>


#### Inner Tool Function
* token_access



```python
# init a Postman headers and optimization argument for fetch the data
headers = "{'Authorization': 'Basic aGphaW46aGphaW4xMjM=','Content-Type': 'application/json','Postman-Token': '8732d840-1fcf-4f21-a92e-d4390dd88fc6','cache-control': 'no-cache'}"

data = '{\n    "alpha": "QES_LEAP_1_SCORE",\n    "template": "default",\n    "portfolio": "SP500",\n    "startDate": "2018-08-30",\n    "endDate": "2018-12-31",\n    "freq": "1me",\n    "notionalValue": 100000000,\n    "baseCurrency": "USD",\n    "riskModel": {\n        "universe": "SP500",\n        "template": "default"\n    }\n}'
```


```python
def token_access(args_data, headers, function = 'optimization', verbose = True):
    ''' 
    access the token for accessing the API results
    Input:
        args_data: feature with each value 
        function: {optimization|risk}
        verbose: boolean value to display the argument or not
    Output:
        unique id
    '''
    # call the 
    response = requests.post('http://feed.luoquant.com/{}/'.format(function),
                             headers=headers, data=data)
    if response.status_code == 200:
        return response.text
    
    if verbose:
        print('Unsuccessful call')
    return None
```


```python
# Example : generat
uid =  token_access(data, headers)
print(uid)
```

    78b871e5-982b-419c-8398-e2d31496fdf6


* data_process


```python
def data_process(uid, headers, feature = 'Weights', function = 'optimization', saveFlag = True, savePath = '.'):
    # I. get the data content 
    response = requests.get('http://feed.luoquant.com/{0}/{1}/{2}.csv'.format(function, uid, feature),
                            headers=headers)
    data_text = response.text 
    
    # II. generate the corresponding pandas df
    df_raw = pd.DataFrame([[word.replace("\"", "") for word in line.split(',')] for line in data_text.split('\n')])
    # process the data df
    df = df_raw.rename(columns=df_raw.iloc[0]).iloc[1:]
    # drop the all-none value
    df.dropna(inplace = True)
    # III. save the data into local path with csv format
    if saveFlag:
        # by default save into the current directory
        df.to_csv(savePath + '/{}.csv'.format(feature))
    
    return df
```


```python
# Example : generate and save the Weights data
df_weight = data_process(uid, headers)

df_weight.tail()
```

<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>DATE</th>
      <th>ID</th>
      <th>Sedol</th>
      <th>Ticker</th>
      <th>Company Name</th>
      <th>Sector</th>
      <th>Industry Group</th>
      <th>Country</th>
      <th>Currency</th>
      <th>WEIGHT</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>2566</th>
      <td>2018-12-31</td>
      <td>4MOOJ25EK9</td>
      <td>B6ZC3N6</td>
      <td>TRIP</td>
      <td>TripAdvisor Inc</td>
      <td>50</td>
      <td>5020</td>
      <td>US</td>
      <td>160</td>
      <td>0</td>
    </tr>
    <tr>
      <th>2567</th>
      <td>2018-12-31</td>
      <td>4M7KNQL719</td>
      <td>B6WVMH3</td>
      <td>CBRE</td>
      <td>CBRE Group Inc</td>
      <td>60</td>
      <td>6010</td>
      <td>US</td>
      <td>160</td>
      <td>0</td>
    </tr>
    <tr>
      <th>2568</th>
      <td>2018-12-31</td>
      <td>4M7KY5YDK9</td>
      <td>B01R258</td>
      <td>WCG</td>
      <td>WellCare Health Plans Inc</td>
      <td>35</td>
      <td>3510</td>
      <td>US</td>
      <td>160</td>
      <td>0</td>
    </tr>
    <tr>
      <th>2569</th>
      <td>2018-12-31</td>
      <td>4MK60M351Z</td>
      <td>B3SPXZ3</td>
      <td>LYB</td>
      <td>LyondellBasell Industries NV</td>
      <td>15</td>
      <td>1510</td>
      <td>US</td>
      <td>160</td>
      <td>0</td>
    </tr>
    <tr>
      <th>2570</th>
      <td>2018-12-31</td>
      <td>4M3YQMNYKZ</td>
      <td>BFRT3W7</td>
      <td>ALLE</td>
      <td>Allegion Plc</td>
      <td>20</td>
      <td>2010</td>
      <td>US</td>
      <td>160</td>
      <td>0</td>
    </tr>
  </tbody>
</table>