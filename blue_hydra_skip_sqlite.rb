# Skip the step of reading blue hydra data from its sqlite db. Instead, directly sending the required data to 
# mysql db and influx db
# Add this in Blue Hydra's modeling file device.rb
# The object containing all properties ready to be is available around line 197 in the device.rb file 

require 'mysql2'
require 'influxdb'

def connect_to_db_mysql(hostname, username, password, dbname)
  mysql = Mysql2::Client.new(:host => hostname, :username => username, :password => password, :database => dbname)
  return mysql
end

def connect_to_db_influx(dbname)
  influx = InfluxDB::Client.new dbname
  return influx
end

# insert into mysql
=begin example of data format for mysql
"insert into #{tablename_mysql} (Addr, UUID) VALUES ('ab:cd:ef', '15717843')"
=end
def insert_into_mysql(client, tablename, columns, values)
  client.query("insert into #{tablename} #{columns} VALUES #{values}")
end

# insert into influx
=begin example of data format for influx
data = {
  values: { value: Value.next },
  tags:   { wave: 'sine' } # tags are optional
}
=end
def insert_into_influx(client, measurement, data)
  client.write_point(measurement, data)
end


