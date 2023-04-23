# futu-opend
futu-opend是基于富途官网opnend封装的docker镜像

## 官网下载地址
https://www.futunn.com/download/OpenAPI?lang=zh-CN

## 使用说明
### 1.创建镜像
```commandline
docker build -t <镜像名称>:<标签> <Dockerfile所在目录>

# 例如：在当前目录
docker build -t futud:v0.0.1 .
```

### 2.安装docker-compose
- 如果使用的是最新版的`docker-desktop`，则已经默认安装了`docker-compose`
- 如果没有安装`docker-compose`请参考docker官网：https://docs.docker.com/compose/install/

### 3. 准备docker-compose.yaml
```commandline
version: '3'
services:
  other_service:
    image: "image:tag"
    container_name: other
    restart: always
    networks:
      - opend
    ports:
      - "8888:8888"
    command: ["command", "argument"]

  futud:
    image: "image:tag"
    container_name: futud
    restart: always
    volumes:
      - ./config:/config
    networks:
      - opend
    ports:
      - "11111:11111"
    command: ["./FutuOpenD", "-cfg_file", "/config/futu-wudi.xml"]

networks:
   opend:
     driver: bridge
```
- `futud`为了安全需要再本地地址(`127.0.0.1`)进行调用，所以需要把依赖`opend`的服务部署在同一个自定义网络内(这里是`opend`),这样可以通过`127.0.0.1`相互调用
- 这里挂载一个`volume`(`./config`)用来存放自定义配置文件

### 4. 准备futud的配置文件
1. 在`FutuOpenD_7.1.3308_NN_Ubuntu16.04`目录内有个配置文件模板`FutuOpenD.xml`
2. 复制该模板到步骤`3`中的配置文件目录中(`config`)
3. 修改里面的内容为真实的内容，这里列出几个必须要填写的
```xml
<futu_opend>
	<!-- 基础参数 -->
	<!-- Basic parameters -->
		<!-- 协议监听地址,不填默认127.0.0.1 -->
		<!-- Listening address. 127.0.0.1 by default -->
		<ip>127.0.0.1</ip>
		<!-- API接口协议监听端口 -->
		<!-- API interface protocol listening port -->
		<api_port>11111</api_port>
		<!-- 登录帐号 -->
		<!-- Login account -->
		<login_account>1000000</login_account>
		<!-- 登录密码32位MD5加密16进制 -->
		<!-- Login password, 32-bit MD5 encrypted hexadecimal --> 
        <!--<login_pwd_md5></login_pwd_md5>-->
		<!-- 登录密码明文，密码密文存在情况下只使用密文 -->
		<!-- Plain text of login password. When cypher text exists, the cypher text will be used. --> 
        <login_pwd>xxxxx</login_pwd>
		<!-- FutuOpenD语言，en：英文，chs：简体中文 -->
		<!-- FutuOpenD language. en: English, chs: Simplified Chinese -->
		<lang>chs</lang>
	<!-- 进阶参数 -->
	<!-- Advanced parameters -->
		<!-- FutuOpenD日志等级，no, debug, info, warning, error, fatal --> 
		<!-- FutuOpenD log level: no, debug, info, warning, error, fatal --> 
		<log_level>info</log_level>
		<!-- API推送协议格式，0：pb, 1：json -->
		<!-- API push protocol format. 0: pb, 1: json -->
		<push_proto_type>0</push_proto_type>
		<!-- API订阅数据推送频率控制，单位毫秒，目前不包括K线和分时，不设置则不限制频率-->
		<!-- Data Push Frequency, in milliseconds. Candlesticks and timeframes are not included. If not set, the frequency will be unlimited. -->
		<!-- <qot_push_frequency>1000</qot_push_frequency> -->
		<!-- Telnet监听地址,不填默认127.0.0.1 -->
		<!-- Telnet listening address. 127.0.0.1 by default -->
		 <telnet_ip>127.0.0.1</telnet_ip>
		<!-- Telnet监听端口 -->
		<!-- Telnet listening port -->
		 <telnet_port>22222</telnet_port>
		<!-- API协议加密私钥文件路径,不设置则不加密 -->
		<!-- File path for private key for API protocol enctyption. If not set, it will not be encrypted. -->
		<!-- <rsa_private_key>~/rsa</rsa_private_key> -->
		<!-- 是否接收到价提醒推送，0：不接收，1：接收 -->
		<!-- Whether to receive the price reminder push. 0: not receive, 1: receive -->
		<price_reminder_push>1</price_reminder_push>
		<!-- 被踢后是否自动抢权限，0：否，1：是 -->
		<!-- 开启该选项后，要想在其他终端上获取行情权限需要在10秒连续踢FutuOpenD两次行情权限（终端登录算一次） -->
		<!-- Whether to automatically grab highest quote right after being kicked, 0: No, 1: Yes -->
		<!-- When this parameter is set as 1, if you want to get highest quote right on APP, you need to kick FutuOpenD twice in 10 seconds (terminal login counts once) -->
		<auto_hold_quote_right>1</auto_hold_quote_right>
		<!-- 指定期货交易 API 时区，期货账户调用交易 API 时，涉及的时间按照此时区规则。期货交易必须配置此字段 -->
		<!-- UTC：0时区，UTC+1：东一区，UTC+2：东二区，......，UTC+11：东十一区，UTC+12：东十二区，UTC-11：西十一区，......，UTC-1：西一区 -->
		<!-- The time zone of futures trading API. When using trading API with futures account, the time involved is in accordance with the time zone rules. You must set this parameter when trading futures -->
		<!-- UTC: 0 time zone, UTC+1: East 1st zone, UTC+2: East 2nd zone, ..., UTC+11: East 11th zone, UTC+12: East 12th zone, UTC-11: West 11th zone,..., UTC-1: West 1st zone -->
		<future_trade_api_time_zone>UTC+8</future_trade_api_time_zone>
	<!-- WebSocket 专用参数 -->
	<!-- Specific parameters for WebSocket -->
		<!-- WebSocket监听地址, 不填默认127.0.0.1 -->	
		<!-- WebSocket listening address. 127.0.0.1 by default -->
		<!-- <websocket_ip>127.0.0.1</websocket_ip> -->
		<!-- WebSocket监听端口, 不配置则不启用该功能 -->
		<!-- WebSocket listening port. WebSocket will not work if not set -->
		<!-- <websocket_port>33333</websocket_port> -->
		<!-- WebSocket鉴权密钥密文, 32位MD5加密16进制 -->
		<!-- WebSocket authentication key ciphertext, 32-bit MD5 encrypted hexadecimal -->
		<!-- <websocket_key_md5>14e1b600b1fd579f47433b88e8d85291</websocket_key_md5> -->
		<!-- WebSocket证书私钥文件路径，不配置则不启用SSL，需要和证书同时配置 -->
		<!-- WebSocket private key file path. SSL will not work if not set. WebSocket certificate and private key need to be set at the same time -->	
		<!-- <websocket_private_key>~/key</websocket_private_key> -->
		<!-- WebSocket证书文件路径，不配置则不启用SSL，需要和私钥同时配置 -->
		<!-- WebSocket certificate file path. SSL will not work if not set. WebSocket certificate and private key need to be set at the same time -->
		<!-- <websocket_cert>~/cer</websocket_cert> -->
	<!-- FUTU US 专用参数 -->
	<!-- Specific parameters for FUTU US -->
	<!-- 是否开启 防止被标记为日内交易者 的功能, 0：否，1：是-->	
		<!-- 开启功能后，我们会在您将要被标记 PDT 时阻止您的下单，但不确保您一定不被标记。若您被标记 PDT，当您的账户权益小于$25000时，您将无法开仓。-->	
		<!-- Whether to turn on the Pattern Day Trade Protection, 0: No, 1: Yes  -->
		<!-- When this parameter is set as 1, we will prevent you from placing orders which might mark you as a Pattern Day Trader(PDT). The Protection can not guarentee that you won't be marked as a PDT. If you are marked as a PDT, you will not be allowed to open new positions until your equity is above $25000.-->
		<pdt_protection>1</pdt_protection>
		<!-- 是否开启 日内交易保证金追缴预警 的功能, 0：否，1：是 -->	
		<!-- 开启功能后，我们会在您即将开仓下单超出剩余日内交易购买力前阻止您的下单。提醒您当前开仓订单的市值大于您的剩余日内交易购买力，若您在今日平仓当前标的，您将会收到日内交易保证金追缴通知（Day-Trading Call），只能通过存入资金才能解除。 -->	
		<!-- Whether to turn on the Day-Trading Call Warning, 0: No, 1: Yes  -->
		<!-- When this parameter is set as 1, we will prevent you from placing orders which might exceed your remaining day-trading buying power. We will alert you that you are placing orders that exceed your remaining day-trading buying power. If you close the positions today, you will receive a Day-Trading Call. The DT Call can ONLY be met by depositing funds in the full amount of the call.-->
		<dtcall_confirmation>1</dtcall_confirmation>
</futu_opend>
```

- `<login_account>1000000</login_account>`：富途的账号
- `<login_pwd>xxxxx</login_pwd>`：富途的密码
- 其他如果可以保持默认

### 5. 启动/停止服务
#### 启动服务
> 在`docker-compose.yaml`同一目录执行命令

```commandline
docker-compose up -d futud
```

#### 停止服务
```commandline
docker-compose stop futud
```

### 6. 输入验证码
富途为了安全大概率会发个验证码给你，这是你需要登录到docker中输入验证码
```commandline
# 进入docker
docker exec -it futu-only /bin/bash

# 连接富途内置的telnet服务
telnet 127.0.0.1 22222

# 输入接收到的验证码
input_phone_verify_code -code=123456
```

## 反馈
如有任何建议可以加我微信反馈：`opentime0plus`