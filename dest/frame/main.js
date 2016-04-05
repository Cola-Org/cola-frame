(function() {
  cola(function(model) {
    model.describe("menus", {
      provider: {
        url: App.prop("service.menus")
      }
    });
    model.describe("messages", {
      provider: {
        url: App.prop("service.messagePull")
      }
    });
    model.describe("user", {
      provider: {
        url: App.prop("service.user.detail")
      }
    });
    model.widgetConfig({
      subMenuTree: {
        $type: "tree",
        autoExpand: true,
        bind: {
          expression: "menu in subMenu",
          child: {
            recursive: true,
            expression: "menu in menu.menus"
          }
        }
      },
      subMenuLayer: {
        beforeShow: function() {
          return $("#viewTab").parent().addClass("lock");
        },
        beforeHide: function() {
          return $("#viewTab").parent().removeClass("lock");
        }
      }
    });
    model.action({
      dropdownDisplay: function(item) {
        return !!item.get("menus");
      },
      showUserSidebar: function() {
        return cola.widget("userSidebar").show();
      },
      logout: function() {
        return $.ajax({
          type: "POST",
          url: App.prop("service.logout")
        }).done(function(result) {
          if (result.type) {
            return window.location.reload();
          }
        }).fail(function() {
          alert("退出失败，请检查网络连接！");
        });
      },
      menuItemClick: function(item) {
        var data, i, len, menu, menus, recursive;
        data = item.toJSON();
        menus = data.menus;
        recursive = function(d) {
          var i, len, ref, results;
          if (d.menus) {
            ref = d.menus;
            results = [];
            for (i = 0, len = ref.length; i < len; i++) {
              item = ref[i];
              results.push(recursive(item));
            }
            return results;
          } else {
            return d.hasChild = false;
          }
        };
        if (menus) {
          for (i = 0, len = menus.length; i < len; i++) {
            menu = menus[i];
            recursive(data);
          }
          model.set("subMenu", menus);
          model.set("currentMenu", data);
          return cola.widget("subMenuLayer").show();
        } else {
          model.set("subMenu", []);
          cola.widget("subMenuLayer").hide();
          return App.open(data.path, data);
        }
      },
      hideSubMenuLayer: function() {
        return cola.widget("subMenuLayer").hide();
      },
      toggleSidebar: function() {
        var $dom, className;
        className = "collapsed";
        $dom = $("#frameworkSidebarBox");
        return $dom.toggleClass(className, !$dom.hasClass(className));
      }
    });
    $("#frameworkSidebar").accordion({
      exclusive: false
    }).delegate(".menu-item", "click", function() {
      $("#frameworkSidebar").find(".menu-item.current-item").removeClass("current-item");
      return $fly(this).addClass("current-item");
    });
    return $("#rightContainer>.layer-dimmer").on("click", function() {
      return cola.widget("subMenuLayer").hide();
    });
  });

}).call(this);
