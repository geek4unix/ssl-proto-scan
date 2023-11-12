# ssl-proto-scan
A script that uses openssl to scan for different protocols available on a TLS/SSL secured service

I found myself in need of a simple tool run against a specific server / port while remediating a large number of servers and services. 
This script will connect to any SSL/TLS service like WWW/Email/LDAPS and so on.

It requires OpenSSL and coreutils packages to be installed. ( OpenSSL for openssl s_client, coreutils for the timeout command )

Usage:

![Screenshot 2023-11-12 at 08 59 50](https://github.com/geek4unix/ssl-proto-scan/assets/6726149/b3fa44f4-679f-4b1c-80d3-111116b70f46)

Examples:

![Screenshot 2023-11-12 at 14 35 39](https://github.com/geek4unix/ssl-proto-scan/assets/6726149/564ceecc-de6a-4fc4-bb24-6fd60373b4cd)
