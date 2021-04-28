# verify-email

## Dependencies

- bash
- expect 
- nslookup 
- grep 
- awk 
- telnet

## Installation

`git clone https://github.com/rsynnest/verify-email`

## Usage: 

```bash
FROM_EMAIL=me@example.com
TO_EMAIL=someone@example.com
verify-email.sh $FROM_EMAIL $TO_EMAIL
```
