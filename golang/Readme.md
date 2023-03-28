# sys-echo

#### System Echo:

The sys-echo command will echo the IP and hostname and a custom message to the console when URL is queried.

To start sys-echo, run the following command:

```bash
sys-echo "Hello World"                   
Starting server on port 8080...
```

To query the sys-echo service, run the following command:

```bash
curl -s http://localhost:8080 |jq -r .
{
  "hostname": "dfedick-C02G74HWMD6N",
  "ip": "192.168.86.36",
  "custom_text": "Hello World"
}
```
