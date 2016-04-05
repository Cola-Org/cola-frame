(function() {
  cola(function(model) {
    var mainPath, showMessage, submit;
    model.describe({
      userName: {
        validators: {
          $type: "required",
          message: ""
        }
      },
      password: {
        validators: {
          $type: "required",
          message: ""
        }
      }
    });
    mainPath = "" + window.location.origin + (App.prop("mainView"));
    model.set("userName", $.cookie("_userName"), {
      path: "/"
    });
    showMessage = function(content) {
      return cola.widget("formSignIn").setMessages([
        {
          type: "error",
          text: content
        }
      ]);
    };
    submit = function() {
      var data;
      data = model.get();
      cola.widget("containerSignIn").addClass("loading");
      return $.ajax({
        type: "POST",
        url: App.prop("service.login"),
        data: JSON.stringify(data.toJSON()),
        contentType: "application/json"
      }).done(function(result) {
        cola.widget("containerSignIn").removeClass("loading");
        if (!result.type) {
          showMessage(result.message);
          return;
        }
        if (model.get("cacheInfo")) {
          $.cookie("_userName", model.get("userName"), {
            path: "/",
            expires: 365
          });
        }
        return window.location = mainPath;
      }).fail(function() {
        cola.widget("containerSignIn").removeClass("loading");
      });
    };
    return model.action({
      signIn: function() {
        var data;
        cola.widget("formSignIn").setMessages(null);
        data = model.get();
        if (data.validate()) {
          return submit();
        } else {
          return showMessage("用户名或密码不能为空！");
        }
      }
    });
  });

}).call(this);
