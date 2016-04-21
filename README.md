# Cola-Frame
cola-ui 桌面应用前段基础框架

1、提供的基础功能

* 登录页面（登录、登出、找回密码、修改密码）
* 管理系统主界面
* 消息系统
* 组件级权限控制

2、如何执行
切换到当前目录执行如下命令进行安装node依赖
```
     npm install
```
启动服务
```
     npm start
```
浏览器打开：http://localhost:4008

3.如何引入cola-frame到自己的项目
请到/build-configs.coffee修改配置
```
module.exports =
	data:
		version: "0.0.1",
		packageName: "",
		contextPath: "/", //应用上下文配置
		htmlSuffix: ".html",
		language: "zh-CN",
		currency: "￥"
		siteRoot:""
```

##不断完善中……

配置系统服务地址：
请到/common/common.js 修改对应参数
```
 properties = {
      mainView: "./frame/main", //系统主框架界面
      loginPath: "./login", //登录界面路径
      longPollingTimeout: 0, 
      longPollingInterval: 2000, //框架长轮询周期
      "service.messagePull": "./service/message/pull", //消息接口
      "service.login": "./service/account/login",  //登录接口
      "service.logout": "./service/account/logout", //登出接口
      "service.menus": "./service/menus", //系统菜单接口
      "service.user.detail": "./service/user/detail"  //获得当前用户详细信息接口
    };
```
