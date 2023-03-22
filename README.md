# ChatGptClient

#### iOS模拟器代理配置

输入以下命令，以查找当前配置的所有网络服务：

```
networksetup -listallnetworkservices
```

输入以下命令，将代理设置为模拟器的网络服务(将iOS Simulator替换为上一步骤找到的iOS模拟器的网络服务， 将proxyServerAddress proxyPortNumber改为代理服务的ip和端口，下同)：

```
networksetup -setwebproxy "iOS Simulator" proxyServerAddress proxyPortNumber

```
输入以下命令，将安全网页代理设置为模拟器的网络服务

```
networksetup -setsecurewebproxy "iOS Simulator" proxyServerAddress proxyPortNumber

```

输入以下命令，以关闭该网络服务的代理设置：

```
networksetup -setwebproxystate "iOS Simulator" off

```

输入以下命令，以关闭该网络服务的安全网页代理设置

```
networksetup -setsecurewebproxystate "iOS Simulator" off

```