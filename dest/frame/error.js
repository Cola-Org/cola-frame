(function() {
  cola(function(model) {
    var homePath, value, waitingTime;
    waitingTime = 15;
    model.set("timer", waitingTime);
    homePath = App.prop("mainView");
    model.set("home", homePath);
    $("#timeProgress").progress({
      total: waitingTime
    });
    value = 1;
    return setInterval(function() {
      value++;
      if (value >= waitingTime) {
        window.location = homePath;
      }
      model.set("timer", waitingTime - value);
      return $("#timeProgress").progress({
        value: Math.round(value / waitingTime * 10000) / 100.00
      });
    }, 1000);
  });

}).call(this);
