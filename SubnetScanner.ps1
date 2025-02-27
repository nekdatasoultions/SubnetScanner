#Input your first three octets of your /24 CIDR
$FirstThreeOctets = Read-Host "Enter the first three octets of the subnet (e.g., 192.168.1)"

# Validate input to ensure it's in the correct format
if ($FirstThreeOctets -match "^\d{1,3}\.\d{1,3}\.\d{1,3}$") {
    1..254 | ForEach-Object {
        $IP = "$FirstThreeOctets.$_"
        if (Test-Connection -Count 1 -ComputerName $IP -Quiet) {
            try {
                $HostName = Resolve-DnsName -Name $IP -ErrorAction Stop | 
                            Select-Object -ExpandProperty NameHost -ErrorAction Stop
                Write-Host "$IP - $HostName"
            }
            catch {
                Write-Host "$IP - <Could not resolve hostname>" -ForegroundColor Red
            }
        }
    }
} else {
    Write-Host "Invalid input. Please enter a valid subnet in the format 'X.X.X' (e.g., 192.168.1)" -ForegroundColor Red
}
