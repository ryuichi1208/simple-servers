require 'webrick'
include WEBrick

s = HTTPServer.new(
:DocumentRoot => File.join(Dir.pwd, "www"),
:Port => 2000
)
trap("INT") { s.shutdown }
s.start
