### R Class to work with optimizer

require(httr)
require(R6)

qes.microsvc.Conn <- R6Class(
  "QESConnection",
  public = list(
    URL = NULL,
    username = NULL,
    password = NULL,
    jobs = NULL,
    initialize = function(URL = 'https://feed.luoquant.com',
                          username, password){
      self$URL <- URL
      self$username <- username
      self$password <- password
    },
    .authenticate = function(){
      httr::authenticate(self$username, self$password)
    },
    post = function(svc,body) {
      response <- httr::POST(paste0(self$URL,'/',svc),
                      body = toJSON(body, auto_unbox=TRUE, digits=NA),
                      self$.authenticate(),
                      encode="json")
      rawToChar(response$content)
    },
    get = function(svc) {
      response <- httr::GET(paste0(self$URL,'/',svc),
                             self$.authenticate())
      rawToChar(response$content)
    },
    .jobs = function() {
      if (is.null(self$jobs)){
        self$refresh_jobs()
      }
      return(self$jobs)
    },
    refresh_jobs = function() {
      jobs <- fromJSON(self$get('job'))
      jobs$STARTTIME <- as.POSIXct(as.Date('1970-01-01')) + jobs$STARTTIME/1e3
      jobs$ENDTIME <- as.POSIXct(as.Date('1970-01-01')) + jobs$ENDTIME/1e3

      idx <- order(jobs$STARTTIME,decreasing = T)
      jobs <- jobs[idx,]
      self$jobs <- jobs
      return(TRUE)
    },
    failed_job = function(type) {
      subset(self$.jobs(),STATUS == 'ERROR' & TYPEID %in% type)
    },
    success_job = function(type) {
      subset(self$.jobs(),STATUS == 'SUCCESS' & TYPEID %in% type)
    }

  )


)

qes.microsvc.EntitySvc <- R6Class(
  "EntityService",
  public = list(
    conn = NULL,
    uuid = NULL,
    svc = NULL,
    initialize = function(conn, svc,uuid) {
      self$conn <- conn
      self$uuid <- uuid
      self$svc <- svc
    },
    info = function() {
      self$conn$get(paste0(self$svc,'/',self$uuid))
    }
  )
)

qes.microsvc.Optimizer <- R6Class(
  "QESOptimizer",
  public = list(
    conn = NULL,
    esvc = NULL,
    req = NULL,
    typeid = 2,

    completed = function() {
      self$conn$success_job(self$typeid)
    },
    failed = function() {
      self$conn$success_job(self$typeid)
    },

    initialize = function(conn) {
      self$conn = conn
    },

    info = function() {
      if (is.null(self$esvc)) {
        stop('No Optimization Associated with the class, either set id or create new optimization request')
      }
      return(fromJSON(self$esvc$info()))
    },

    set_id = function(uuid) {
      self$esvc = qes.microsvc.EntitySvc$new(self$conn,'optimization',uuid)
    },


    newRequest = function(template, univId, startDate, endDate, freq) {
      self$esvc <- NULL
      self$req <- list(
        template = template,
        universe = univId,
        startDate = startDate,
        endDate = endDate,
        freq = freq
      )
      response <- self$conn$post(self$req)
      self$esvc <- qes.microsvc.EntitySvc$new(self$conn,'optimization',response)
    }

  )
)

