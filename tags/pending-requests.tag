<pending-requests>

	<div class="pending_request_outter_div">
      

         <div class="pending_request_row pending_request_row_header" onclick={ showPendingRequestsNav}>
            <div>
              <span class="contact_row_header"><span class="pending_requests_count" if={ !(hasNoData) }>{ pending_requests_count }</span>{ opts.title }</span>
              
              <div class="nav_arrow_btn"> 
                 <img hide={ pendingRequestsVisible } src="img/right_arrow.png">
                  <img show={ pendingRequestsVisible } src="img/down_arrow.png">
              </div>
            </div>
            <div class="clear"></div>
         </div>
         
         <div show={ pendingRequestsVisible } class="all_pending_request_overflow" >
         <div each={ contact in user_contacts }>
         <div if={ !(contact.chat_started) && !(contact.blocked) }  show = { btn_add_contact } class="pending_request_row all_pending_request" >
         	
         	
         		<span >{ contact.contact_user_username }</span>
	         	<div class="contact_option"> 
              <img onclick={ showContactOptions } hide={ contactOptions == contact.contact_user_email } src="img/right_arrow.png">
              <img onclick={ showContactOptions } show={ contactOptions == contact.contact_user_email } src="img/down_arrow.png">
            </div>
  		     	<div class="contact_option_btn_div" show={ contactOptions == contact.contact_user_email } >
  		     		<a class="contact_option_btn user_contact_email_word_break">{ contact.contact_user_email }</a>
  		     		<a class="contact_option_btn cursor-pointer" onclick={ parent.showConfirmaddContact }>Add</a>
  		         	<a class="contact_option_btn cursor-pointer" onclick={ parent.showConfirmignoreContact }>Ignore</a>
  		         	<a class="contact_option_btn cursor-pointer" onclick={ parent.showConfirmblockContact }>Block</a>
  		     	</div>

         	</div>
         </div>
         <div if={ hasNoData } class="contact_row all_user_contacts has_no_data" >
          <span >No pending contact requests.</span>
         </div>
         <div class="pending_request_row"><img hide = { btn_add_contact } src="img/loading.gif"></div>
         </div>
      	
      	
   </div>

   <script>
   		var self = this;

   		self.on('mount', function(){
   			self.btn_add_contact = true;
        self.hasNoData = false;
        self.pendingRequestsVisible = false;
        self.pending_requests_count = 0;
   		});

      showPendingRequestsNav(e){
        if(self.pendingRequestsVisible == false){
          self.pendingRequestsVisible = true;
          self.parent.tags['all-contacts'].update({
            allContactsVisible: false
          });
          self.parent.tags['blocked-contacts'].update({
            blockedContactsVisible: false
          });
        }
        else{
          self.pendingRequestsVisible = false;
          self.parent.tags['all-contacts'].update({
            allContactsVisible: true
          });
        }
        self.update();
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

      showConfirmaddContact(e){
        var add_contact_obj = e.item.contact;
        self.parent.parent.tags['modal'].update({
              title: "Confirm!",
              message: "Are you sure you want to add "+add_contact_obj.contact_user_username+"("+add_contact_obj.contact_user_email+") to your Contacts?",
              tag_initiator: "pending-requests",
              showCancel: true,
              functionToCall: "addContact",
              functionToCallParameter: e
        });
        self.parent.parent.showModal();
      }

   		addContact(e){
        self.showContactOptions(e);
   			self.btn_add_contact = false;
   			var add_contact_obj = e.item.contact;
   			var check_user_invite = firebase_db_obj.ref("Contacts").child(add_contact_obj.contact_user_uid+"/"+self.user.uid);
          		check_user_invite.once('value').then(function(snapshot){
          			if(snapshot.exists()){
          				if((snapshot.toJSON()).chat_started == false && (snapshot.toJSON()).blocked == false){
      						var accept_user_invite = firebase_db_obj.ref("Contacts").child(add_contact_obj.contact_user_uid);
		                  	accept_user_invite.update({
		                  		[self.user.uid]: {
			                  		contact_user_uid : self.user.uid,
		                  			contact_user_email : self.user.user_email,
		                  			contact_user_username : self.user.user_username,
		                  			chat_started : true,
		                  			chat_id : add_contact_obj.chat_id,
		                  			message_sent : false,
		                  			blocked: false
			                  	}
		                  	})
		                  	.then(function(return_data){
		                  		var update_user_invite_status = firebase_db_obj.ref("Contacts").child(self.user.uid+"/"+add_contact_obj.contact_user_uid);
			                  		update_user_invite_status.update({
			                  			chat_started : true
			                  	}).then(function(update_data){
                                self.parent.parent.tags['modal'].update({
                                    title: "Success!",
                                    message: add_contact_obj.contact_user_username+"("+add_contact_obj.contact_user_email+") has been successfully added to your Contacts.",
                                    tag_initiator: "pending-requests",
                                    showCancel: false
                                });
                                self.parent.parent.showModal();
    			                  		self.btn_add_contact = true;
    		                  			self.update();
  			                  	});
		                  		
		                  	});
              			}
              			else{
              				self.btn_add_contact = true;
			                self.update();
              			}
              		}
          			else{
              			var accept_user_invite = firebase_db_obj.ref("Contacts").child(add_contact_obj.contact_user_uid);
		                  	accept_user_invite.update({
		                  		[self.user.uid]: {
			                  		contact_user_uid : self.user.uid,
		                  			contact_user_email : self.user.user_email,
		                  			contact_user_username : self.user.user_username,
		                  			chat_started : true,
		                  			chat_id : add_contact_obj.chat_id,
		                  			message_sent : false,
		                  			blocked: false
			                  	}
		                  	})
		                  	.then(function(return_data){
		                  		var update_user_invite_status = firebase_db_obj.ref("Contacts").child(self.user.uid+"/"+add_contact_obj.contact_user_uid);
			                  		update_user_invite_status.update({
			                  			chat_started : true
			                  	}).then(function(update_data){
  			                  		self.parent.parent.tags['modal'].update({
                                    title: "Success!",
                                    message: add_contact_obj.contact_user_username+"("+add_contact_obj.contact_user_email+") has been successfully added to your Contacts.",
                                    tag_initiator: "pending-requests",
                                    showCancel: false
                                });
                                self.parent.parent.showModal();
                                self.btn_add_contact = true;
                                self.update();
			                  	});
		                  		
		                  	});
                  	}
          	});
   		}

      showConfirmignoreContact(e){
          var ignore_contact_obj = e.item.contact;
          self.parent.parent.tags['modal'].update({
                title: "Confirm!",
                message: "Are you sure you do not want to add "+ignore_contact_obj.contact_user_username+"("+ignore_contact_obj.contact_user_email+") to your Contacts?",
                tag_initiator: "pending-requests",
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
                                    tag_initiator: "pending-requests",
                                    showCancel: false
                                });
                                self.parent.parent.showModal();
              					self.btn_add_contact = true;
	                  			self.update();
              				});
              			}
              		});
   		}


      showConfirmblockContact(e){
          var block_contact_obj = e.item.contact;
          self.parent.parent.tags['modal'].update({
                title: "Confirm!",
                message: "Are you sure you want to block "+block_contact_obj.contact_user_username+"("+block_contact_obj.contact_user_email+") from sending and recieving messages from you?",
                tag_initiator: "pending-requests",
                showCancel: true,
                functionToCall: "blockContact",
                functionToCallParameter: e
          });
          self.parent.parent.showModal();
      }

   		blockContact(e){
        self.showContactOptions(e);
   			var block_contact_obj = e.item.contact;
   			var check_user_invite = firebase_db_obj.ref("Contacts").child(self.user.uid+"/"+block_contact_obj.contact_user_uid);
   				check_user_invite.once('value').then(function(snapshot){
              			if(snapshot.exists()){
              				firebase_db_obj.ref("Contacts").child(self.user.uid+"/"+block_contact_obj.contact_user_uid).update({
              					blocked: true
              				})
              				.then(function(update_data){
                          self.parent.parent.tags['modal'].update({
                                    title: "Success!",
                                    message: block_contact_obj.contact_user_username+"("+block_contact_obj.contact_user_email+") has been successfully blocked.",
                                    tag_initiator: "pending-requests",
                                    showCancel: false
                                });
                                self.parent.parent.showModal();
            					     self.btn_add_contact = true;
	                  			self.update();
              				});
              			}
              		});
   		}
   </script>

</pending-requests>