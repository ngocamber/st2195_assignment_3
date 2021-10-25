# get the working directory
setwd('C:/Users/LENOVO/Documents/year3/Programming/Assignments/3')

library('dbplyr')
library('DBI')
library(data.table)


if (file.exists('airline2.db'))
  file.remove('airline2.db')

# connect to sqlite driver
conn <- dbConnect(RSQLite::SQLite(), 'airline2.db')

# list tables
dbListTables(conn)

# create table
## ontime table
path <- "C:/Users/LENOVO/Documents/year3/Programming/Assignments/3/New Folder"

multmerge = function(path){
  filenames=list.files(path=path, full.names=TRUE)
  rbindlist(lapply(filenames, fread))
} 
ontime <- multmerge(path)

planes <- read.csv('plane-data.csv', header = TRUE)
airports <- read.csv('airports.csv', header = TRUE)
carriers <- read.csv('carriers.csv', header = TRUE)

# copy dataframes to database
dbWriteTable(conn, 'planes', planes)
dbWriteTable(conn, 'ontime', ontime)
dbWriteTable(conn, 'carriers', carriers)
dbWriteTable(conn, 'airports', airports)

dbListTables(conn)
  ## [1] "airports" "carriers" [3] "ontime"  "planes"  

# Quering
## q1
q1 <- dbGetQuery(conn,
'SELECT DISTINCT model, AVG(DepDelay) as avg_depdelay
FROM ontime NATURAL JOIN planes 
WHERE DepDelay > 0 AND Diverted = 0 AND Cancelled = 0
GROUP BY model
ORDER BY avg(DepDelay) asc')
q1
write.csv(q1, 'C:/Users/LENOVO/Documents/year3/Programming/Assignments/3/Q1r.csv', row.names = FALSE)

## q2
q2 <- dbGetQuery(conn,
                 'SELECT DISTINCT city, Count(Dest) as number_inbound_flights
                  FROM ontime NATURAL JOIN airports
                  WHERE Cancelled = 0
                  GROUP BY city
                  ORDER BY number_inbound_flights asc')
q2

## q3
q3 <- dbGetQuery(conn, 
'SELECT DISTINCT Description, Count(Cancelled) as number_cancelleds
FROM ontime NATURAL JOIN carriers
WHERE Cancelled = 1
GROUP BY Description
ORDER BY number_cancelleds')
q3

## q4
q4 <- dbGetQuery(conn, )
