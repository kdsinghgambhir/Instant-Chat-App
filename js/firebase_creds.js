
  
  var config = {
    apiKey: "",
    authDomain: "",
    databaseURL: "",
    projectId: "instantchatweb",
    storageBucket: "",
    messagingSenderId: ""
  };

  firebase.initializeApp(config);

  var firebase_auth_obj = firebase.auth();
  var firebase_db_obj = firebase.database();
  var user_ref = firebase_db_obj.ref("Users");
  var contact_ref = firebase_db_obj.ref("Contacts");
  var chat_ref = firebase_db_obj.ref("Chats");