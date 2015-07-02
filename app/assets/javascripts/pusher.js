// Enable pusher logging - don't include this in production
Pusher.log = function(message) {
  if (window.console && window.console.log) {
    window.console.log(message);
  }
};

var pusher = new Pusher('e513ae0db2f71c44d4e0');
simpleStorage.set("members", [], {TTL: 86400000}); // Expires in 24 hours
var pendingRemoves = []

var pluck_by_id = function(in_arr, id, exists) {
  for (i = 0; i < in_arr.length; i++ ) {
    if (in_arr[i].id == id) {
      return (exists === true) ? true : in_arr[i];
    }
  }
};

var add_member = function(member_id, member_info) {
  // var pendingRemoveTimeout = pendingRemoves[member_id];
  // if(pendingRemoveTimeout) {
  //   // user left, but has rejoined
  //   clearTimeout(pendingRemoveTimeout);
  // } else {
  //   var members = simpleStorage.get("members");
  //   if (!pluck_by_id(members, member_id, true)) {
  //     members.push({
  //       id: member_id,
  //       info: member_info
  //     });
  //   }
  //   simpleStorage.set("members", members);
  // }
  var members = simpleStorage.get("members");
  if (!pluck_by_id(members, member_id, true)) {
    members.push({
      id: member_id,
      info: member_info
    });
  }
  simpleStorage.set("members", members);
};

var remove_member = function(member_id, member_info) {
  // pendingRemoves[member_id] = setTimeout(function() {
  //   var members = simpleStorage.get("members");
  //   var conlone_members = [];
  //   for(var i = members.length - 1; i >= 0; i--) {
  //     if(members[i].id === member_id) {
  //       continue;
  //     }
  //     conlone_members.push(members[i]);
  //   }
  //   simpleStorage.set("members", conlone_members);
  // }, 1500); // wait 1.5 seconds
  var members = simpleStorage.get("members");
  var conlone_members = [];
  for(var i = members.length - 1; i >= 0; i--) {
    if(members[i].id === member_id) {
      continue;
    }
    conlone_members.push(members[i]);
  }
  simpleStorage.set("members", conlone_members);
};
