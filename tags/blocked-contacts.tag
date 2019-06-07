<blocked-contacts>

	<div class="blocked_contacts_outter_div">
      
         <div class="blocked_contacts_row blocked_contacts_row_header" onclick={ showBlockedContactsNav}>
            <div>
              <span class="contact_row_header">{ opts.title }</span>
              <div class="nav_arrow_btn"> 
                 <img hide={ blockedContactsVisible } src="img/right_arrow.png">
                  <img show={ blockedContactsVisible } src="img/down_arrow.png">
              </div>
            </div>
            <div class="clear"></div>
         </div>
         
         <div show={ blockedContactsVisible } class="all_blocked_contacts_overflow">
	         <div  each={ contact in user_contacts }>
	         	<div if={ contact.blocked } show = { btn_add_contact } class="blocked_contacts_row all_blocked_contacts" >
	         	<span>{ contact.contact_user_username }</span>
	         		<div class="contact_option"> 
	         			<img onclick={ showContactOptions } hide={ contactOptions == contact.contact_user_email } src="img/right_arrow.png">
		         		<img onclick={ showContactOptions } show={ contactOptions == contact.contact_user_email } src="img/down_arrow.png">
		         	</div>
			     	<div class="contact_option_btn_div" show={ contactOptions == contact.contact_user_email } >
			     		<a class="contact_option_btn user_contact_email_word_break">{ contact.contact_user_email }</a>
			         	<a class="contact_option_btn cursor-pointer" onclick={ parent.showConfirmignoreContact }>Remove</a>
			         	<a class="contact_option_btn cursor-pointer" onclick={ parent.showConfirmunBlockContact }>UnBlock</a>
			     	</div>
	         	</div>
	         </div>
	         <div if={ hasNoData } class="contact_row all_user_contacts has_no_data" >
	         	<span >No contact has been blocked.</span>
	         </div>
         	<div class="blocked_contacts_row"><img hide = { btn_add_contact } src="img/loading.gif"></div>
         </div>
      
   </div>

   <script>
   		var self = this;

   		self.on('mount', function(){
   			self.btn_add_contact = true;
   			self.hasNoData = false;
   			self.blockedContactsVisible = false;
   		});
	      
   		showBlockedContactsNav(e){
   			if(self.blockedContactsVisible == false){
   				self.blockedContactsVisible = true;
   				self.parent.tags['all-contacts'].update({
	            allContactsVisible: false
	          });
	          self.parent.tags['pending-requests'].update({
	            pendingRequestsVisible: false
	          });
	        }
	        else{
	          self.blockedContactsVisible = false;
	          self.parent.tags['all-contacts'].update({
	            allContactsVisible: true
	          });
	        }
   		}

   		showContactOptions(e){
    	
	    	if(self.contactOptions != e.item.contact.contact_user_email){
	    		self.contactOptions = e.item.contact.contact_user_email;
	    	}
	    	else{
				self.contactOptions = "";
	    	}
	    	
	    	self.update();
	    }

   		showConfirmignoreContact(e){
          var ignore_contact_obj = e.item.contact;
          self.parent.parent.tags['modal'].update({
                title: "Confirm!",
                message: "Are you sure you want to remove "+ignore_contact_obj.contact_user_username+"("+ignore_contact_obj.contact_user_email+") from your Contacts?",
                tag_initiator: "blocked-contacts",
                showCancel: true,
                functionToCall: "ignoreContact",
                functionToCallParameter: e
          });
          self.parent.parent.showModal();
      }

   		ignoreContact(e){
   			self.showContactOptions(e);
   			self.btn_add_contact = false;
   			var ignore_contact_obj = e.item.contact;
   			var check_user_invite = firebase_db_obj.ref("Contacts").child(self.user.uid+"/"+ignore_contact_obj.contact_user_uid);
   				check_user_invite.once('value').then(function(snapshot){
              			if(snapshot.exists()){
              				firebase_db_obj.ref("Contacts").child(self.user.uid).update({
              					[ignore_contact_obj.contact_user_uid]: null
              				})
              				.then(function(update_data){
              					 self.parent.parent.tags['modal'].update({
                                    title: "Success!",
                                    message: ignore_contact_obj.contact_user_username+"("+ignore_contact_obj.contact_user_email+") was successfully not added to your Contacts.",
                                    tag_initiator: "blocked-contacts",
                                    showCancel: false
                                });
                                self.parent.parent.showModal();
              					self.btn_add_contact = true;
	                  			self.update();
              				});
              			}
              		});
   		}

   		showConfirmunBlockContact(e){
          var block_contact_obj = e.item.contact;
          self.parent.parent.tags['modal'].update({
                title: "Confirm!",
                message: "Are you sure you want to unblock "+block_contact_obj.contact_user_username+"("+block_contact_obj.contact_user_email+") to send and recieve messages from you?",
                tag_initiator: "blocked-contacts",
                showCancel: true,
                functionToCall: "unBlockContact",
                functionToCallParameter: e
          });
          self.parent.parent.showModal();
      }

   		unBlockContact(e){
   			self.showContactOptions(e);
   			var block_contact_obj = e.item.contact;
   			var check_user_invite = firebase_db_obj.ref("Contacts").child(self.user.uid+"/"+block_contact_obj.contact_user_uid);
   				check_user_invite.once('value').then(function(snapshot){
              			if(snapshot.exists()){
              				firebase_db_obj.ref("Contacts").child(self.user.uid+"/"+block_contact_obj.contact_user_uid).update({
              					blocked: false
              				})
              				.then(function(update_data){
              					if(typeof self.parent.parent.tags['app-main-content'].user_contact != "undefined" && self.parent.parent.tags['app-main-content'].user_contact != null){
              						if(self.parent.parent.tags['app-main-content'].user_contact.chat_id == block_contact_obj.chat_id){
              						var user_contact = self.parent.parent.tags['app-main-content'].user_contact;
              						block_contact_obj.blocked = false;
              						firebase_db_obj.ref("Chats/"+user_contact.chat_id).orderByChild("time").on('value', function(snapshot){
										    	if(snapshot.exists()){
										    		var user_chats = [];
										    		snapshot.forEach(function(snapshot){
													    var childData = snapshot.val();
													    user_chats.push(childData);
													});
													
													firebase_db_obj.ref("Contacts/"+self.user.uid+"/"+user_contact.contact_user_uid).update({
									                    message_sent: false
									              	})
									              	.then(function(return_data){
									                    self.parent.parent.tags['app-main-content'].update({
												   			user: self.user,
												   			user_contact: block_contact_obj,
												   			user_chats: user_chats
												   		});

												   		self.parent.parent.tags['modal'].update({
							                                title: "Success!",
							                                message: block_contact_obj.contact_user_username+"("+block_contact_obj.contact_user_email+") was successfully added back to your Contacts.",
							                                tag_initiator: "blocked-contacts",
							                                showCancel: false
							                            });
							                            self.parent.parent.showModal();
							          					self.btn_add_contact = true;
							                  			self.update();
									              	});

												}
												else{
													self.parent.parent.tags['app-main-content'].update({
											   			user: self.user,
											   			user_contact: block_contact_obj,
											   			user_chats: []
											   		});
											   		self.parent.parent.tags['modal'].update({
						                                title: "Success!",
						                                message: block_contact_obj.contact_user_username+"("+block_contact_obj.contact_user_email+") was successfully added back to your Contacts.",
						                                tag_initiator: "blocked-contacts",
						                                showCancel: false
						                            });
						                            self.parent.parent.showModal();
						          					self.btn_add_contact = true;
						                  			self.update();	
												}
											});
              						}
              						else{
              							self.parent.parent.tags['modal'].update({
			                                title: "Success!",
			                                message: block_contact_obj.contact_user_username+"("+block_contact_obj.contact_user_email+") was successfully added back to your Contacts.",
			                                tag_initiator: "blocked-contacts",
			                                showCancel: false
			                            });
			                            self.parent.parent.showModal();
			          					self.btn_add_contact = true;
			                  			self.update();	
              						}
						    	}
						    	else{
						    		self.parent.parent.tags['modal'].update({
		                                title: "Success!",
		                                message: block_contact_obj.contact_user_username+"("+block_contact_obj.contact_user_email+") was successfully added back to your Contacts.",
		                                tag_initiator: "blocked-contacts",
		                                showCancel: false
		                            });
		                            self.parent.parent.showModal();
		          					self.btn_add_contact = true;
		                  			self.update();	
						    	}
						    	
              				});
              			}
              		});
   		}
   </script>

</blocked-contacts>