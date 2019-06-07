<user-data>

         <div class="user_data_outter_div">
      		<div class="user_profile_row margin-bottom-10 margin-top-10 font-16 font-bold">
            
      			<p >
               <div >
               <div if={ opts.user.user_chat_status == 0 } onclick={ showChatStatusOptionsClicked } class="user_online_status current_chat_status green"></div><div if={ opts.user.user_chat_status == 1 } onclick={ showChatStatusOptionsClicked } class="user_online_status current_chat_status red"></div><div if={ opts.user.user_chat_status == 2 } onclick={ showChatStatusOptionsClicked } class="user_online_status current_chat_status grey"></div>  { opts.user.displayName }</p> 
               <div show={ chatStatusOptions } onmouseover={ showChatStatusOptions } onmouseleave={ hideChatStatusOptions } class="user_chat_status_update_btn_div" >
                  <a class="user_chat_status_update_btn" id="0" onclick={ updateChatStatusOnline } ><div id="user_online_status" class="user_online_status green"></div><p>Online</p></a>
                  <a class="user_chat_status_update_btn" id="1" onclick={ updateChatStatusBusy } ><div id="user_online_status" class="user_online_status red"></div><p>Busy</p></a>
                  <a class="user_chat_status_update_btn" id="2" onclick={ updateChatStatusInvisible } ><div id="user_online_status" class="user_online_status grey"></div><p>Invisible</p></a>
               </div>
               </div> 
      		</div>
      		<p class="user_profile_row margin-bottom-10 user_data_break_long_status">{ opts.user.user_status }</p>
      	</div>

         
   
    <script>

   var self = this;


   this.on('before-mount', function(){
         self.chatStatusOptions = false;
   });

   showChatStatusOptionsClicked(e){
      if(self.chatStatusOptions == false){
         self.chatStatusOptions = true;
      }
      else{
         self.chatStatusOptions = false;
      }
      self.update();
   }

   showChatStatusOptions(e){
      if(self.chatStatusOptions == false){
         self.chatStatusOptions = true;
      }
      self.update();
   }

   hideChatStatusOptions(e){
      if(self.chatStatusOptions == true){
         self.chatStatusOptions = false;
      }
      self.update();
   }

   updateChatStatusOnline(e){
         self.updateChatStatus(0);      
   }

   updateChatStatusBusy(e){
         self.updateChatStatus(1);      
   }

   updateChatStatusInvisible(e){
         self.updateChatStatus(2);      
   }

   self.updateChatStatus = function(user_chat_status){
      user_ref.child(opts.user.uid).once('value').then(function(snapshot){
         if(snapshot.exists()){
            user_ref.child(opts.user.uid).update({
               user_chat_status : user_chat_status
            })
            .then(function(data){
               self.chatStatusOptions = false;
               opts.user.user_chat_status = user_chat_status;
               self.parent.update();
            });
         }
      });   
   }

   
   </script>

</user-data>