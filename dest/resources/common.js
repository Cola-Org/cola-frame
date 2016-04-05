(function() {
  var App, language, properties;

  properties = {
    contextPath: "/",
    serviceUrlPattern: /^\/?service\/[a-z]+/,
    serviceUrlPrefix: "/",
    htmlSuffix: "",
    mainView: "/frame/main",
    loginPath: "/login",
    longPollingTimeout: 0,
    longPollingInterval: 2000,
    "service.messagePull": "/service/message/pull",
    "service.login": "/service/account/login",
    "service.logout": "/service/account/logout",
    "service.menus": "/service/menus",
    "service.user.detail": "/service/user/detail"
  };

  App = window.App = {
    _tabs: {},
    open: function(path, config) {
      var tab, viewTab;
      viewTab = cola.widget("viewTab");
      if (this._tabs[path]) {
        tab = viewTab.getTab(path);
        return viewTab.setCurrentTab(tab);
      } else {
        if (config.type !== "subWindow") {
          window.open(path);
          return;
        }
        tab = new cola.TabButton({
          afterClose: (function(_this) {
            return function(self, arg) {
              return _this.close(self.get("name"));
            };
          })(this),
          content: {
            $type: "iFrame",
            path: config.path
          },
          icon: config.icon,
          name: path,
          closeable: config.closeable || true,
          caption: config.label
        });
        viewTab = cola.widget("viewTab");
        this._tabs[path] = tab;
        viewTab.addTab(tab);
        return viewTab.setCurrentTab(tab);
      }
    },
    close: function(path) {
      return delete this._tabs[path];
    },
    goLogin: function() {},
    prop: function(key, value) {
      var i, len, p, results;
      if (arguments.length === 1) {
        if (typeof key === "string") {
          return properties[key];
        } else if (key) {
          results = [];
          for (i = 0, len = key.length; i < len; i++) {
            p = key[i];
            if (key.hasOwnProperty(p)) {
              results.push(properties[p] = key[p]);
            } else {
              results.push(void 0);
            }
          }
          return results;
        }
      } else {
        return properties[key] = value;
      }
    }
  };

  cola.defaultAction("setting", function(key) {
    return App.prop(key);
  });

  cola.defaultAction("numberString", function(number) {
    return ["one", "two", "three", "four", "five", "six", "seven", "eight", "nine", "ten", "eleven", "twelve", "thirteen", "fourteen", "fifteen", "sixteen"][number - 1];
  });

  $(document).ajaxError(function(event, jqXHR) {
    var message;
    if (jqXHR.status === 401) {
      App.goLogin();
      return false;
    } else {
      message = jqXHR.responseJSON;
      if (message) {
        throw new cola.Exception(message);
      }
    }
  });

  language = $.cookie("_language") || window.navigator.language;

  if (language) {
    document.write("<script src=\"resources/cola-ui/i18n/" + language + "/cola.js\"></script>");
    document.write("<script src=\"resources/i18n/" + language + "/common.js\"></script>");
  }

  $(NProgress.done);

}).call(this);
