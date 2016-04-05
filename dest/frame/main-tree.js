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
      menuTree: {
        $type: "tree",
        autoExpand: true,
        autoCollapse: false,
        bind: {
          expression: "menu in menus",
          child: {
            recursive: true,
            expression: "menu in menu.menus"
          }
        }
      }
    });
    return model.action({
      showUserSidebar: function() {
        return cola.widget("userSidebar").show();
      },
      menuItemClick: function(item) {},
      toggleSidebar: function() {
        var $dom, className;
        className = "collapsed";
        $dom = $("#frameworkSidebarBox");
        return $dom.toggleClass(className, !$dom.hasClass(className));
      }
    });
  });

}).call(this);
