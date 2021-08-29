//WebSocketURL: ws://localhost:3000/cable

App.notification = App.cable.subscriptions.create("WebNotificationsChannel", {
  received: function(data) {
    var notificationNumberTags = document.getElementsByClassName("notification-number")
    for (var i = 0; i < notificationNumberTags.length; i++) {
      notificationNumberTags[i].style.display = "block"
      notificationNumberTags[i].innerText = parseInt(notificationNumberTags[i].innerText) + 1
    }    
  },

  speak: function(data) {
    this.perform("speak", data);
  }
})

// Make request to server
// App.notification.speak({action_type: "TEST"});
