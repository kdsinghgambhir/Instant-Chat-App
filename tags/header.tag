<header>
   <div class="header_id_outter_div">
      <div>
         <span class="app_title">{opts.title}</span>
         <div if={ parent.userLoggedIn } class="user_login_div">
         <a  class="" onclick={ showWelcome }>Home</a>
         <span>|</span>
         <a  class="" onclick={ showUserProfile }>My Profile</a>
         <span>|</span>
         <a  class="" onclick={ showChangePassword }>Change Password</a>
         <span>|</span>
         <a  class="btn_logout" onclick={ showConfirmuserLogout  }> Logout</a>
         </div>
      </div>
      <div class="clear"></div>
   </div>
   <script>
      var self = this;

      showConfirmuserLogout(e){

         self.parent.tags['modal'].update({
                  title: "! Are You Sure !",
                  message: "Logout? Hope to see You soon again!!",
                  tag_initiator: "header",
                  functionToCall: "userLogout",
                  functionToCallParameter: e,
                  showCancel: true
            });
            self.parent.showModal();

      }

      userLogout(e){
         self.parent.app_loading = true;
         var userid = self.parent.tags['app-nav'].user.uid;
         self.parent.tags['app-nav'].user = null;
         user_ref.child(userid).off('value');
         user_ref.off('value');
         contact_ref.child(userid).off('value');
         self.showWelcome();
         var user_additional_data = user_ref.child(userid);
               user_additional_data.once('value').then(function(snapshot) {
                 if(snapshot.exists()){
                     user_additional_data.update({
                        user_logged_in : false
                     })
                     .then(function(user_data){
                           firebase_auth_obj.signOut()
                           .then(function(){
                           })
                           .catch(function(error){
                              if(error){
                                 alert(error.message);
                              }
                              else{
                                 
                              }
                           });
                     });
                 }
            });
         
      }

      showWelcome(e){
         self.parent.tags['app-main-content'].user = self.user;
         self.parent.tags['app-main-content'].user_contact = null;
         self.parent.tags['app-main-content'].viewProfile = false;
         self.parent.tags['app-main-content'].changePassword = false;
         self.parent.tags['app-main-content'].viewContactProfile = false;
         self.parent.tags['app-main-content'].hideChangePasswordErrors();
         self.parent.tags['app-main-content'].hideEditUserProfileErrors();
         self.parent.tags['app-main-content'].update();   
      }

      showUserProfile(e){
         if(self.parent.tags['app-main-content'].viewProfile == false){
            self.parent.tags['app-main-content'].user = self.user;
            self.parent.tags['app-main-content'].user_contact = null;
            self.parent.tags['app-main-content'].hideChangePasswordErrors();
            self.parent.tags['app-main-content'].viewProfile = true;
            self.parent.tags['app-main-content'].viewContactProfile = false;
            if(self.parent.tags['app-main-content'].changePassword == true){
               self.parent.tags['app-main-content'].changePassword = false;
            }
         }
         self.parent.tags['app-main-content'].update();
      }

      showChangePassword(e){
         if(self.parent.tags['app-main-content'].changePassword == false){
            self.parent.tags['app-main-content'].user = self.user;
            self.parent.tags['app-main-content'].user_contact = null;
            self.parent.tags['app-main-content'].hideEditUserProfileErrors();
            self.parent.tags['app-main-content'].changePassword = true;
            self.parent.tags['app-main-content'].viewContactProfile = false;
            if(self.parent.tags['app-main-content'].viewProfile == true){
               self.parent.tags['app-main-content'].viewProfile = false;
            }
         }  
         self.parent.tags['app-main-content'].update();
      }

   </script>
</header>