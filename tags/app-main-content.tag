<app-main-content>
	
 
   <div class="app_main_content_outter_div">
      <div class="app_main_content_inner_div">
         <div class="welcome_div" if={ (user) && !(user_contact) && !(viewProfile) && !(changePassword) && !(viewContactProfile)}>
            <h2>Welcome to Instant Chat!</h2>
            <h4>Start adding your Friends using their Email Id's.</h4>
            <h4>Happy Chatting & Have Fun Here!</h4>
            <img src = "img/icon.png" width="400" height="300" />
         </div>
         

         <div class="chat_window_div" if={ (user) && (user_contact) && !(viewProfile) && !(changePassword) && !(viewContactProfile)}>
            <div class="closebtn" >
               <img onclick={ closeChat } class="cursor-pointer" src="img/closebtn.png"/>
            </div>
            <h3>@{user_contact.contact_user_username} ~ <p class="user_contact_quote">"{user_contact.user_status}"</p></h3>
            <div class="chat_window_messages" id="chat_window_messages">
               <div class="message_div" each={ msg in user_chats }>
                  <div>
                  <div class="user_message_div" if={ ( msg.uid == user.uid ) }><p class="message_bubble_text">{msg.txt}</p><p class="font-12 text-right"> - { msg.time_txt }</p></div>
                  </div>
                  <div>
                  <div class="user_contact_message_div" if={ ( msg.uid == user_contact.contact_user_uid ) }><p class="message_bubble_text">{msg.txt}</p><p class="font-12 text-right"> - { msg.time_txt }</p></div>
                  </div>
                  <div class="clear"></div>
               </div>
            </div>
            <p class="user_contact_busy_message" if={ (user_contact.user_logged_in) && user_contact.user_chat_status == 1 }>{user_contact.contact_user_username} is currently busy at the moment and will read your messages later.</p>
            <p class="user_contact_busy_message" if={ (user_contact.user_logged_in) && user_contact.user_chat_status == 2 }>{user_contact.contact_user_username} is currently offline.</p>
            <p class="user_contact_busy_message" if={ !(user_contact.user_logged_in) }>{user_contact.contact_user_username} is currently offline.</p>
            <div class="message_input_div" >
               <textarea ref="chat_message"  onkeypress={ sendChatEnter } oninput={ enableButton }></textarea>
               <a class="a_btn a_btn_message_send" disabled={ buttonActive } onclick={ sendChat }>Send</a>
            </div>
         </div>


         <div class="view_profile_div" if={ (user) && !(user_contact) && (viewProfile) }>
            
            
            <h3>My Profile</h3>
            <div class="profile_detail_div" onkeypress={ updateUserProfileEnter }>
            
               <div if={ !(editUserName) } class="profile_detail_row">
                  <label>User Name: </label>
                  <span>{ user.user_username }</span>
               </div>
               <div show={ editUserName } class="profile_detail_row">
                  <label>User Name: </label>
                  <input class="profile_detail_form_input" type="text" maxlength="23" ref="edit_user_name" value={ user.user_username }>
               </div>
               <div if={ err_edit_user_name } class="profile_detail_row">
                  <label>&nbsp;</label>
                  <span class="error">Please enter a User Name.</span>
               </div>
               <div class="profile_detail_row">
                  <label>Email Id: </label>
                  <span>{ user.user_email }</span>
               </div>
               <div if={ !(editUserStatus) } class="profile_detail_row">
                  <label>Status: </label>
                  <span class="profile_detail_break_long_status">{ user.user_status }</span>
               </div>
               <div show={ editUserStatus } class="profile_detail_row">
                  <label>Status: </label>
                  <textarea class="profile_detail_form_textarea" type="text" maxlength="80" ref="edit_user_status" value={ user.user_status }></textarea>
               </div>
               <div if={ err_edit_user_status } class="profile_detail_row">
                  <label>&nbsp;</label>
                  <span class="error">Please enter a Status.</span>
               </div>
               <div if={ !(editUserStatus) } class="profile_detail_row">
                  <label>Chat Status: </label>
                  <span class="user_contact_profile_chat_status" if={ (user.user_logged_in) && (user.user_chat_status == 0) }>
                     <div  class="user_online_status green"></div><p>Online</p>
                  </span>
                  <span class="user_contact_profile_chat_status" if={ (user.user_logged_in) && (user.user_chat_status == 1) }>
                     <div  class="user_online_status red"></div><p>Busy</p>
                  </span>
                  <span class="user_contact_profile_chat_status" if={ (user.user_logged_in) && (user.user_chat_status == 2) }>
                     <div  class="user_online_status grey"></div><p>Offline</p>
                  </span>
                  <span class="user_contact_profile_chat_status" if={ !(user.user_logged_in) } >
                     <div class="user_online_status grey"></div><p>Offline</p>
                  </span>
               </div>
               <div show={ editUserStatus } class="profile_detail_row">
                  <label>Chat Status: </label>
                  <select ref="user_chat_status" value="user.user_chat_status">
                     <option><div  class="user_online_status green"></div><p>Online</p></option>
                     <option><div  class="user_online_status red"></div><p>Busy</p></option>
                     <option><div  class="user_online_status grey"></div><p>Offline</p></option>
                  </select>
               </div>
               <div if={ !(editUserName) || !(editUserStatus) } class="profile_detail_row">
                  <label>&nbsp;</label>
                  <a onclick={ showEditUser } class="a_btn">Edit</a>
               </div>
               <div if={ (editUserName) || (editUserStatus) } class="profile_detail_row">
                  <label>&nbsp;</label>
                  <a onclick={ hideEditUser } class="a_btn margin-right-10" show={ btn_update_profile }>Cancel</a>
                  <a onclick={ confirm_updateUserProfileEnter } class="a_btn" show={ btn_update_profile }>Save</a>
                  <div hide={ btn_update_profile }>
                     <label>&nbsp;</label>
                     <img class="btn_loader_update_profile_form" src="img/loading.gif" >
                  </div>
               </div>
               
            </div>
         </div>


         <div class="change_password_div" if={ (user) && !(user_contact) && (changePassword) }>

            
            <h3>Change Password</h3>
            <div class="change_password_detail_div" onkeypress={ changeUserPasswordEnter }>

                  <div class="change_password_detail_row">
                     <label>Current Password: </label>
                     <input class="change_password_form_input" type="Password" ref="user_current_password">
                  </div>
                  <div if={ err_user_current_password } class="change_password_detail_row">
                     <label>&nbsp;</label>
                     <span class="error">Please enter your current password.</span>
                  </div>
                  <div if={ err_user_current_password_valid } class="change_password_detail_row">
                     <label>&nbsp;</label>
                     <span class="error">Current password entered is invalid.</span>
                  </div>
                  <div class="change_password_detail_row">
                     <label>New Password: </label>
                     <input class="change_password_form_input" type="Password" ref="user_change_password">
                  </div>
                  <div if={ err_user_change_password } class="change_password_detail_row">
                     <label>&nbsp;</label>
                     <span class="error">Please enter a new password.</span>
                  </div>
                  <div if={ err_user_change_password_same } class="change_password_detail_row">
                     <label>&nbsp;</label>
                     <span class="error">Your new password cannot be the same as the old password.</span>
                  </div>
                  <div if={ err_auth } class="change_password_detail_row">
                     <label>&nbsp;</label>
                     <span class="error">{ err_auth_message }</span>
                  </div>
                  <div class="change_password_detail_row">
                     <label> Confirm New Password: </label>
                     <input class="change_password_form_input" type="Password" oninput={ validatePasswordMatch } ref="user_confirm_change_password">
                  </div>
                  <div if={ err_user_confirm_change_password } class="change_password_detail_row">
                     <label>&nbsp;</label>
                     <span class="error">Please confirm your new password.</span>
                  </div>
                  <div if={ err_user_confirm_change_password_match } class="change_password_detail_row">
                     <label>&nbsp;</label>
                     <span class="error">Your passwords need to match.</span>
                  </div>
                  <div class="change_password_detail_row">
                     <label>&nbsp;</label>
                     <a onclick={ confirm_changeUserPassword } class="a_btn a_href_change_password" show={ btn_change_password }>Change Password</a>
                     <div hide={ btn_change_password }>
                        <label>&nbsp;</label>
                        <img class="btn_loader_change_password_form" src="img/loading.gif" >
                     </div>
                  </div>
            </div>
         </div>

         <div class="view_profile_div" if={ (user) && (user_contact) && (viewContactProfile) && !(viewProfile) && !(changePassword)}>
            
            
            <h3>Contact Profile</h3>
            <div class="profile_detail_div" >
            
               <div class="profile_detail_row">
                  <label>User Name: </label>
                  <span>{ user_contact.contact_user_username }</span>
               </div>
               <div class="profile_detail_row">
                  <label>Email Id: </label>
                  <span>{ user_contact.contact_user_email }</span>
               </div>
               <div class="profile_detail_row">
                  <label>Status: </label>
                  <span class="profile_detail_break_long_status">{ user_contact.user_status }</span>
               </div>
               <div class="profile_detail_row">
                  <label>Chat Status: </label>
                  <span class="user_contact_profile_chat_status" if={ user_contact.user_logged_in && (user_contact.user_chat_status == 0) }>
                     <div  class="user_online_status green"></div><p>Online</p>
                  </span>
                  <span class="user_contact_profile_chat_status" if={ user_contact.user_logged_in && (user_contact.user_chat_status == 1) }>
                     <div  class="user_online_status red"></div><p>Busy</p>
                  </span>
                  <span class="user_contact_profile_chat_status" if={ user_contact.user_logged_in && (user_contact.user_chat_status == 2) }>
                     <div  class="user_online_status grey"></div><p>Offline</p>
                  </span>
                  <span class="user_contact_profile_chat_status" if={ !(user_contact.user_logged_in) } >
                     <div class="user_online_status grey"></div><p>Offline</p>
                  </span>
               </div>
               <div class="profile_detail_row margin-bottom-20">
                  <label>&nbsp;</label>
                  <a class="a_btn" onclick={ startChatwithContact }>Start Chat</a>
               </div>

               
            </div>
         </div>
   </div>
   </div>


   <script>
      var self = this;

      this.on('before-mount', function(){
         self.buttonActive = true;
         self.viewProfile = false;
         self.changePassword = false;
         self.editUserName = false;
         self.editUserStatus = false;
         self.btn_update_profile = true;
         self.btn_change_password = true;
         self.user_has_contacts = true;
         self.viewContactProfile = false;
      });

      this.on('updated', function(){
          if( self.user != null && self.user_contact != null && self.viewProfile == false && self.changePassword == false){
               self.updateChatScroll();
            }
      });

      self.updateChatScroll = function(){
        
            if(document.getElementById("chat_window_messages") != null){

                var chat_window = document.getElementById("chat_window_messages");
                setTimeout(function() {
                  chat_window.scrollTop = chat_window.scrollHeight;
               }, 10);
                
            }
      }

      enableButton(e){
         if(self.refs.chat_message.value.trim() == ""){
            self.buttonActive = true;
         }
         else{
            self.buttonActive = false;
         }
      }

      closeChat(e){
         chat_ref.child(self.user_contact.chat_id).off('value');
         self.user_contact = null;
         self.viewProfile = false;
         self.changePassword = false;
         self.viewContactProfile = false;
      }

      startChatwithContact(e){

         e.item = [];
         e.item.contact = self.user_contact;
         self.parent.tags['app-nav'].tags['all-contacts'].openChatWindow(e);

      }

      sendChatEnter(e){
         if(e.key == "Enter"){
            self.sendChat();
         }
      }

      showEditUser(e){
         if(self.user.user_chat_status == 0){
            self.refs.user_chat_status.value = "Online";
         }
         else if(self.user.user_chat_status == 1){
            self.refs.user_chat_status.value = "Busy";
         }
         else if(self.user.user_chat_status == 2){
            user_chat_status = "Offline";
         }
         self.editUserName = true;
         self.editUserStatus = true;
      }

      hideEditUser(e){
         self.editUserName = false;
         self.editUserStatus = false;
      }

      self.hideEditUserProfileErrors = function(){
            self.err_edit_user_name = false;
            self.err_edit_user_status = false;
            self.update();
      };

      self.confirm_updateUserProfileEnter = function(){
         
         self.hideEditUserProfileErrors();
         var user_name = self.refs.edit_user_name.value.trim();
         var user_status = self.refs.edit_user_status.value.trim();

         if(user_name == "" ){
            self.err_edit_user_name = true;
         }
         else if(user_status == "" ){
            self.err_edit_user_status = true;
         }
         else{
            self.parent.tags['modal'].update({
                  title: "Confirm!",
                  message: "Are you sure you want to update your Profile details?",
                  tag_initiator: "app-main-content",
                  functionToCall: "updateUserProfile",
                  showCancel: true
            });
            self.parent.showModal();
         }
      }

      updateUserProfileEnter(e){
         if(e.key == "Enter"){
            if(self.parent.openModal == false){ 
            
               self.confirm_updateUserProfileEnter();
            
            }
         }
      }

      updateUserProfile(e){
         self.hideEditUserProfileErrors();
         var user_name = self.refs.edit_user_name.value.trim();
         var user_status = self.refs.edit_user_status.value.trim();
         var user_chat_status = 0;
         var user_chat_status_str = self.refs.user_chat_status.value;
         if(self.refs.user_chat_status.value == "Online"){
            user_chat_status = 0;
         }
         else if(self.refs.user_chat_status.value == "Busy"){
            user_chat_status = 1;
         }
         else if(self.refs.user_chat_status.value == "Offline"){
            user_chat_status = 2;
         }

         if(user_name == "" ){
            self.err_edit_user_name = true;
         }
         else if(user_status == "" ){
            self.err_edit_user_status = true;
         }
         else{
            self.btn_update_profile = false;
            firebase_auth_obj.currentUser.updateProfile({
              displayName: user_name
            }).then(function() {
               
               var user_profile_data = user_ref.child(self.user.uid);
               user_profile_data.once('value').then(function(snapshot) {
                 if(snapshot.exists()){
                     user_profile_data.update({
                        user_username: user_name,
                        user_status: user_status,
                        user_chat_status: user_chat_status
                     })
                     .then(function(user_data){

                        self.refs.edit_user_name.value = user_name;
                        self.refs.edit_user_status.value = user_status;
                        self.refs.user_chat_status.value = user_chat_status_str;
                        self.update({
                           btn_update_profile: true,
                           editUserName: false,
                           editUserStatus: false
                        });
                        self.parent.tags['modal'].update({
                              title: "Success!",
                              message: "Your Profile has been successfully updated.",
                              tag_initiator: "app-main-content",
                              showCancel: false
                        });
                        self.parent.showModal();
                        self.parent.update();
                        self.parent.update();

                     });
                  }
                  });
            });
 
         }
      }

      validatePasswordMatch(e){
         var user_pass = this.refs.user_change_password.value+"";
         var user_confirm_pass = this.refs.user_confirm_change_password.value+"";
         if(user_pass.trim() == user_confirm_pass.trim()){
           this.err_user_confirm_change_password_match = false;
         }
         else{
           this.err_user_confirm_change_password_match = true;
         }
       }  

       self.hideChangePasswordErrors = function(){
            self.err_user_current_password = false;
            self.err_user_current_password_valid = false;
            self.err_user_change_password = false;
            self.err_user_change_password_same = false;
            self.err_user_confirm_change_password = false;
            self.err_user_confirm_change_password_match = false;
            self.err_auth = false;
            self.err_auth_message = "";
            self.update();
      };

      self.confirm_changeUserPassword = function(){
         self.hideChangePasswordErrors();
         var current_user_pass = this.refs.user_current_password.value+"";
         var user_pass = this.refs.user_change_password.value+"";
         var user_confirm_pass = this.refs.user_confirm_change_password.value+"";

         if(current_user_pass.trim() == ""){
            self.err_user_current_password = true;
         }
         else if(user_pass.trim() == ""){
            self.err_user_change_password = true;
         }
         else if(user_pass.trim() == current_user_pass.trim()){
            self.err_user_change_password_same = true;
         }
         else if(user_confirm_pass.trim() == ""){
            self.err_user_confirm_change_password = true;
         }
         else if(user_pass.trim() != user_confirm_pass.trim()){
            self.err_user_confirm_change_password_match = true;
         }
         else{
            self.parent.tags['modal'].update({
                  title: "Confirm!",
                  message: "Are you sure you want to change your Password?",
                  tag_initiator: "app-main-content",
                  functionToCall: "changeUserPassword",
                  showCancel: true
            });
            self.parent.showModal();
         }
      }

      changeUserPasswordEnter(e){
         if(e.key == "Enter"){
            if(self.parent.openModal == false){ 
               self.confirm_changeUserPassword();
            }
         }

      }

      changeUserPassword(e){
         self.hideChangePasswordErrors();
         var current_user_pass = this.refs.user_current_password.value+"";
         var user_pass = this.refs.user_change_password.value+"";
         var user_confirm_pass = this.refs.user_confirm_change_password.value+"";

         if(current_user_pass.trim() == ""){
            self.err_user_current_password = true;
         }
         else if(user_pass.trim() == ""){
            self.err_user_change_password = true;
         }
         else if(user_pass.trim() == current_user_pass.trim()){
            self.err_user_change_password_same = true;
         }
         else if(user_confirm_pass.trim() == ""){
            self.err_user_confirm_change_password = true;
         }
         else if(user_pass.trim() != user_confirm_pass.trim()){
            self.err_user_confirm_change_password_match = true;
         }
         else{
            self.btn_change_password = false;
            firebase_auth_obj.signInWithEmailAndPassword(self.user.email, current_user_pass)
            .then(function(user_data){
                  firebase_auth_obj.currentUser.updatePassword(user_pass.trim()).then(function() {
                     self.refs.user_current_password.value = "";
                     self.refs.user_change_password.value = "";
                     self.refs.user_confirm_change_password.value = "";
                     self.btn_change_password = true;
                     self.parent.tags['modal'].update({
                              title: "Success!",
                              message: "Your Password has been successfully changed.",
                              tag_initiator: "app-main-content",
                              showCancel: false
                     });
                     self.parent.showModal();
                     self.update();
                  }).catch(function(error) {
                     if(error){
                        self.refs.user_current_password.value = "";
                        self.refs.user_change_password.value = "";
                        self.refs.user_confirm_change_password.value = "";
                        self.err_auth = true;
                        var errorCode = error.code;
                        self.err_auth_message = error.message;
                        self.btn_change_password = true;
                        self.update();
                    }
                  });
            })
            .catch(function(error) {
                 if(error){
                  self.refs.user_current_password.value = "";
                  self.refs.user_change_password.value = "";
                  self.refs.user_confirm_change_password.value = "";
                  self.err_user_current_password_valid = true;
                  self.btn_change_password = true;
                  self.update();
                 }
            });

         }
      }

      sendChat(e){
         
         if(self.user_contact.chat_id != "" && self.refs.chat_message.value.trim() != "" && self.user_contact.blocked == false){
            var now = new Date();
            firebase_db_obj.ref("Chats/"+self.user_contact.chat_id).push().set({
                  uid: self.user.uid,
                  txt: self.refs.chat_message.value.trim(),
                  time_txt: now.getHours()+":"+now.getMinutes()+" "+ now.toLocaleDateString(), 
                  time: now.getTime()
            }).then(function(return_data){  
                  self.refs.chat_message.value = "";
                  firebase_db_obj.ref("Contacts/"+self.user_contact.contact_user_uid+"/"+self.user.uid).once('value').then(function(snapshot){
                        if(snapshot.exists()){  
                           firebase_db_obj.ref("Contacts/"+self.user_contact.contact_user_uid+"/"+self.user.uid).update({
                                 message_sent: true
                              })
                              .then(function(return_data){

                              });
                        }
                  });

            });
         }

      }
   </script>
</app-main-content>