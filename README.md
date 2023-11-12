# ssl-proto-scan
A script that uses openssl to scan for different protocols available on a TLS/SSL secured service

I found myself in need of a simple tool run against a specific server / port while remediating a large number of servers and services. 
This script will connect to any SSL/TLS service like WWW/Email/LDAPS and so on.

It requires OpenSSL and coreutils packages to be installed. ( OpenSSL for openssl s_client, coreutils for the timeout command )

Usage:

![Screenshot 2023-11-12 at 08 59 50](https://github.com/geek4unix/ssl-proto-scan/assets/6726149/b3fa44f4-679f-4b1c-80d3-111116b70f46)

Examples:

![Screenshot 2023-11-12 at 09 26 14](https://github.com/geek4unix/ssl-proto-scan/assets/6726149/c546e2b8-25f9-4d09-bec0-74199b7ba80f)
![Screenshot 2023-11-12 at 09 26 37](https://github.com/geek4unix/ssl-proto-scan/assets/6726149/5e9a911b-a15b-4675-8518-6ebd135eef72)
