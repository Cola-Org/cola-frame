# Cola-Frame
cola-ui 桌面应用前段基础框架

1、提供的基础功能

* 登录页面（登录、登出、找回密码、修改密码）
* 管理系统主界面
* 消息系统
* 组件级权限控制


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
