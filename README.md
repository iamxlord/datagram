### Datagram Node Manager - One-Click CLI 

***This script contains simple, yet powerful Bash script to effortlessly manage your Datagram node***

***what is datagram?***

```Datagram is a decentralized video conferencing platform that eliminates central servers, ensuring privacy, scalability, and cost-efficiency.```

> ✓ AI-powered DePIN infrastructure

> ✓ Industry-leading backers 

> ✓ Explosive community growth of over 200K users across networks```

***how to get your API KEY***

> Visit: https://dashboard.datagram.network?ref=155141239

> login with Gmail

> Goto account → API → create an API KEY

> script By Mr. X ([@iamxlord](https://x.com/iamxlord) / [github.com/iamxlord](https://github.com/iamxlord))

### 🛠️ Requirements ✘

* A Linux-based system (tested on Ubuntu 20.04-22.04/Debian,).
* `wget` installed (the script will guide you if it's missing).
* Your Datagram API Key.
* a big smile to your face. 

### UBUNTU/DEBIAN VPS/PC USAGE GUIDE

```1. Clone the Repository```

```bash 
git clone https://github.com/iamxlord/datagram.git
```


```2. Navigate to the Directory (All commanda after this point works only in the "datagram directory")``` 

```bash
cd datagram
```

```3. Make the Script Executable```
```bash
chmod +x datagram.sh
```

```⚙️ start the node```
```bash
./datagram.sh start
```

***input your API key when prompted; press N if you are running datagram cli for the first time***

### IMPORTANT / USEFUL COMMANDS (WORKS ONLY IN DATAGRAM DIRECTORY)

start datagram
```bash
./datagram.sh start
```

stop datagram
```bash
./datagram.sh stop
```

reboot datagram node
```bash
./datagram.sh restart
```

check node current status
```bash
./datagram.sh restart
```

commands & help lists
```bash
./datagram.sh help
```

view datagram log file
```bash
tail -f datagram.log
```
(Press Ctrl+C to exit tail -f)

***⚠️ Important Notes***
 * Your API key is stored in $HOME/.datagram_cli/api_key.conf.
 * For advanced configurations or troubleshooting, refer to the official Datagram CLI documentation.

✘ Contributions:

Feel free to fork the repository, open issues, or submit pull requests if you have suggestions or improvements!
