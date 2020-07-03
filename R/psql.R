#library(DBI)
#con <- DBI::dbConnect(RPostgreSQL::PostgreSQL(), 
#  dbname = "mypsql",
#  user = "liripo",
#  password = "liripo"
#)
#-----

#credentials <- tbl(con,"credentials")
#collect会将数据从数据库转成R对象，从而可以使用R的其他函数进行编程，但这会降低数据库
#性能，所以可以使用dplyr操作或者使用sql语句操作后再collect到本地
#credentials <- credentials %>% collect() %>% as.data.frame()
#show_query可以展示所使用的sql语句
#断开连接，虽然退出R会自动退出，但还是务必显示退出
#dbDisconnect(con)
#-------------------------
#暂时不用了，使用sqllite生成的.sqlite文件,sqlite无需密码
library(DBI)
library(keyring)
conn <- DBI::dbConnect(RSQLite::SQLite(), dbname = "database.sqlite")
credentials <- read_db_decrypt(conn = conn, 
  name = "credentials", passphrase = key_get("liripo"))
