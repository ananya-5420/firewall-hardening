# 🔥 Web Server Firewall Hardening Lab

This project demonstrates how to harden a web server on **Ubuntu 24.04** using **UFW** and **Fail2Ban**. The lab focuses on securing an Apache server by:
- Allowing only HTTP/HTTPS through the firewall
- Monitoring Apache login failures
- Automatically banning IPs after failed login attempts



## 🎯 Objective
- Secure Apache web server with UFW (firewall)
- Configure Fail2Ban to monitor Apache authentication failures
- Use a custom filter to detect brute-force attacks
- Automatically block malicious IP addresses



## ⚙️ Technologies Used

| Tool         | Purpose                          |
|--------------|----------------------------------|
| Ubuntu 24.04 | Base OS                          |
| Apache2      | Web server                       |
| UFW          | Firewall configuration           |
| Fail2Ban     | Intrusion detection & banning    |
| curl         | Simulate failed login attempts   |


## 🛠️ Configuration Files

### 🔐 Fail2Ban Jail – `jail.local`

```ini
[apache-auth]
enabled = true
port = http,https
filter = apache-auth-custom
logpath = /var/log/apache2/error.log
maxretry = 5
bantime = 600
```

### 📄Custom Filter - `apache-auth-custom.conf`
```
[Definition]
failregex = \[auth_basic:error\] \[pid \d+\] \[client <HOST>:\d+\] AH01617: user .*: authentication failure for "/secure/": Password Mismatch
ignoreregex =
```

## 🧪 Testing & Validation
### 🔁 Simulating Brute Force Logins
```
for i in {1..6}; do
  curl -u testuser:wrongpass http://localhost/secure/
done

```
This triggers failed logins that are recorded in Apache's ```error.log```.

### 📋 Jail Status Output
```
Status for the jail: apache-auth
|- Filter
|  |- Currently failed: 0
|  |- Total failed:     6
|  `- File list:        /var/log/apache2/error.log
`- Actions
   |- Currently banned: 1
   |- Total banned:     1
   `- Banned IP list: ::1
```
### 🔍 fail2ban-regex Output
```
Running tests
=============

Use   failregex filter file : apache-auth-custom, basedir: /etc/fail2ban
Use         log file : /var/log/apache2/error.log
Use         encoding : UTF-8


Results
=======

Failregex: 88 total
|-  #) [# of hits] regular expression
|   1) [88] \[auth_basic:error\] \[pid \d+\] \[client <HOST>:\d+\] AH01617: user .*: authentication failure for .*
`-

Ignoreregex: 0 total

Date template hits:
|- [# of hits] date format
|  [88] {^LN-BEG}(?:DAY )?MON Day %k:Minute:Second(?:\.Microseconds)?(?: ExYear)?
`-

Lines: 88 lines, 0 ignored, 88 matched, 0 missed
[processed in 0.13 sec]
```
✅ Confirms that the custom regex correctly matched 88 failed login entries.
