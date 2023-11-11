# ssl-proto-scan
A script that uses openssl to scan for different protocols available on a TLS/SSL secured service

I found myself in need of a simple tool run against a specific server / port while remediating a large number of servers and services. 
This script will connect to any SSL/TLS service like WWW/Email/LDAPS and so on.

It requires OpenSSL and coreutils packages to be installed. ( OpenSSL for openssl s_client, coreutils for the timeout command )

Usage:

![Screenshot 2023-11-11 at 14 06 20](https://github.com/geek4unix/ssl-proto-scan/assets/6726149/458fb0cc-fc8e-4f4d-9950-be137119bbd6)

Examples:

![Screenshot 2023-11-11 at 14 13 56](https://github.com/geek4unix/ssl-proto-scan/assets/6726149/59494d5f-58ff-49f8-9003-36698ae3c200)
