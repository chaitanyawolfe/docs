## Author: Kartik Arora
## Date : 13-Feb-2018
## 
## File shows simple example of using Risk Model/Optimization API

## Source the API file
source('micsvc.R')

# Setup a connection object 
conn1 <- qes.microsvc.Conn$new(username = '<username here>', password = '<password>')

# Get instance of risk model builder
risk_model_builder <- conn1$get_risk_model_builder()

# Submit a new risk model builder request
risk_model_builder$new_request(universe = 'SP500',
                              template = 'default',
                              startDate = '2018-01-31',
                              endDate = '2018-12-31',
                              freq = '1me')
# Wait for it to finish
risk_model_builder$wait(max_wait_secs = 600)

# Download all data to a directory
risk_model_builder$download_all('QES-Risk-Model-Data')



