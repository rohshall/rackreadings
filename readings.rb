require 'rack'
require 'pg'

getDevices = Proc.new do |env|
  conn = PG.connect( dbname: 'sd_ventures_development', user: 'sd_ventures' )
  response = Rack::Response.new
  response['Content-Type'] = 'text/html'
  data = conn.exec( "SELECT * FROM devices" ) do |result|
    result.map do |row|
      row.values_at('device_type_id', 'mac_addr', 'manufactured_at').join('|')
    end
  end
  conn.close
  response.write data
  response.finish
end

getDeviceReadings = Proc.new do |env|
  conn = PG.connect( dbname: 'sd_ventures_development', user: 'sd_ventures' )
  response = Rack::Response.new
  response['Content-Type'] = 'text/html'
  data = conn.exec( "SELECT * FROM readings" ) do |result|
    result.map do |row|
      row.values_at('device_mac_addr', 'value', 'created_at').join('|')
    end
  end
  conn.close
  response.write data
  response.finish
end

$mapper = Rack::URLMap.new(
  'http://localhost/api/v1/devices' => getDevices,
  'http://localhost/api/v1/readings' => getDeviceReadings
)
