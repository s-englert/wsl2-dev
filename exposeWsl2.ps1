# Get the IPv4 from running Wsl2 Linux

$remoteport = bash.exe -c "ifconfig eth0 | grep 'inet '"
$found = $remoteport -match '\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}';

if( $found ){
  $remoteport = $matches[0];
} else{
  echo "IP not found, is Wsl2 running?";
  exit;
}

# Ports
# All Ports you will make available
$ports=@(80,443,3306);

# Static IPv4
# If you have a static IP on your Windows, you cat set it up here 0.0.0.0 is var.
$addr='0.0.0.0';

# Delete existing rules on that ports, and create new with requested IPv4
for( $i = 0; $i -lt $ports.length; $i++ ){
  $port = $ports[$i];
  iex "netsh interface portproxy delete v4tov4 listenport=$port listenaddress=$addr";
  iex "netsh interface portproxy add v4tov4 listenport=$port listenaddress=$addr connectport=$port connectaddress=$remoteport";
}
