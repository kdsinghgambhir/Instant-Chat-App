<app>
   <style type="text/css">
     
   </style>
   
   <header title="Instant Chat :" >
     <div id="login-form-image"></div>
     
   </header>
   <div show={ app_loading } class="app_loading">
      <img  src="img/loading.gif"/>
   </div>

   <div id="login-form">
   <div hide={ app_loading }>
      
      <login-form hide={ userLoggedIn } if={ !newUser && !signInHelp }></login-form>
      <signin-help-form hide={ userLoggedIn } if={ !newUser && signInHelp }></signin-help-form>
      <signup-form hide={ userLoggedIn } if={ newUser }></signup-form>
   
    </div>
    
      <div show={ userLoggedIn }>
         <app-nav></app-nav>
         <app-main-content></app-main-content>
      </div>
   </div>
   <modal show={ openModal }></modal>
   
   <script>
   var self = this;
      showModal(e){
            self.openModal = true;
            self.update();
      }

      firebase_auth_obj.onAuthStateChanged(instantChatUser =>{
         self.app_loading = true;
         if(instantChatUser){
            if(instantChatUser.emailVerified == true && this.checkReverificationLink == false){
               // console.log("user logged in.");
               self.current_user.displayName = instantChatUser.displayName;
               self.current_user.email = instantChatUser.email;
               self.current_user.uid = instantChatUser.uid;
               self.userLoggedIn = true;
               self.newUser = false;
               self.signInHelp = false;
               var user_additional_data = user_ref.child(instantChatUser.uid);
               user_additional_data.once('value').then(function(snapshot){
                  if(snapshot.exists()){
                     user_additional_data.update({
                        user_logged_in : true
                     })
                     .then(function(data){
                        self.current_user.user_username = (snapshot.toJSON()).user_username;
                        self.current_user.user_email = (snapshot.toJSON()).user_email;
                        self.current_user.user_logged_in = true;
                        self.current_user.user_status = (snapshot.toJSON()).user_status;
                        self.current_user.user_chat_status = (snapshot.toJSON()).user_chat_status;
                        riot.mount('user-data');
                        riot.mount('all-contacts');
                        riot.mount('pending-requests');
                        self.tags['app-nav'].user = self.current_user;
                        self.tags['header'].user = self.current_user;
                        self.tags['app-main-content'].user = self.current_user;
                        self.app_loading = false;
                        self.update();
                     });
                  }
               });
               
            }
            else{
               self.app_loading = false;
            }

            if(self.checkReverificationLink == true){
               self.checkReverificationLink = false;
            }
         }
         else{
            // console.log("user is not logged in.");
            self.signInHelp = false;
            self.userLoggedIn = false;
            self.tags['app-nav'].user = null;
            self.tags['header'].user = null;
            self.app_loading = false;
            self.update();
         }
      });

      self.current_user = [];


      self.on('before-mount', function(){
         self.app_loading = true;
         self.userLoggedIn = false; 
         self.newUser = false;
         self.checkReverificationLink = false;
         self.openModal = false;
      }); 

      self.on('mount', function(){
         if(self.userLoggedIn = false)
         self.app_loading = false;
      }); 

      
      
   </script>
</app>

