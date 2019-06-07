<all-contacts>

	<div class="all_contacts_outter_div">
  		
  		<div class="contact_row contact_row_header" onclick={ showAllContactsNav }>
  			<div>
	         	<span class="contact_row_header">{ opts.title }</span>
	         	<div class="nav_arrow_btn"> 
                	<img hide={ allContactsVisible } src="img/right_arrow.png">
                	<img show={ allContactsVisible } src="img/down_arrow.png">
              	</div>
         	</div>
         	<div class="clear"></div>
         </div>

         <div show={ allContactsVisible } class="contact_row add_contact_row">
         	<input type="text"  ref="user_to_add" onfocusout={ resetAddContactErrors } onkeypress={ addContactEnter } value="">
         	<a class="a_btn add_contact_btn" show = { btn_add_contact } onclick={ addContact }>Add</a>
         	<img class="add_contact_btn_loader" hide = { btn_add_contact } src="img/loading.gif">
         </div>

         <span show={ err_user_to_add } class="contact_row error" > { err_user_to_add_message }</span>

         <div class="contact_row" hide = { load_contacts }><img class=""  src="img/loading.gif"></div>

         <div show={ allContactsVisible } class="all_user_contacts_overflow">
         	<div><input class="all_contacts_search_input" placeholder="Search Contacts..." type="text" ref="contact_search" oninput={ searchContacts }></div>
	         <div show={ showAllUserContacts } each={ contact in user_contacts }>
	         	<div ondblclick={ parent.openChatWindow } if={ (contact.chat_started) && !(contact.blocked) } show = { btn_add_contact && load_contacts} class="contact_row all_user_contacts" >
	         		<span  if={ contact.user_logged_in }>
	         		<div if={ contact.user_chat_status == 0} class="contact_online_status green"></div>
	         		<div if={ contact.user_chat_status == 1} class="contact_online_status red"></div>
	         		<div if={ contact.user_chat_status == 2} class="contact_online_status grey"></div>
	         		</span>
	         		<div if={ !(contact.user_logged_in) } class="contact_online_status grey"></div>
	         		<span class="contact_row_username" onclick={ parent.openChatWindow } >{ contact.contact_user_username }</span>
	         		
	         		
		         	<div if={ contact.message_sent } onclick={ parent.openChatWindow  } onclick={ instantchat.plugin(ChatEngineCore.plugin['chat-engine-emoji']()); } class="contact_option contact_new_message"> 
		         		<img src="img/message_bubble.png">
		         	</div>
		         	<div class="contact_option"> 
	         			<img onclick={ showContactOptions } hide={ contactOptions == contact.contact_user_email } src="img/right_arrow.png">
		         		<img onclick={ showContactOptions } show={ contactOptions == contact.contact_user_email } src="img/down_arrow.png">
		         	</div>
		         	<div class="contact_option_btn_div" show={ contactOptions == contact.contact_user_email } >
		         		<p class="contact_option_btn user_contact_email_word_break cursor-pointer" onclick={ parent.showContactProfile }>{ contact.contact_user_email }</p>
			         	<a class="contact_option_btn cursor-pointer" onclick={ parent.showConfirmdeleteContact }>Remove</a>
			         	<a class="contact_option_btn cursor-pointer" onclick={ parent.showConfirmblockContact }>Block</a>
		         	</div>
	         	</div>
	         </div>
	         <div hide={ showAllUserContacts } each={ contact in user_contacts_search }>
	         	<div ondblclick={ parent.openChatWindow } if={ (contact.chat_started) && !(contact.blocked) } show = { btn_add_contact && load_contacts} class="contact_row all_user_contacts" >
	         		<span  if={ contact.user_logged_in }>
	         		<div if={ contact.user_chat_status == 0} class="contact_online_status green"></div>
	         		<div if={ contact.user_chat_status == 1} class="contact_online_status red"></div>
	         		<div if={ contact.user_chat_status == 2} class="contact_online_status grey"></div>
	         		</span>
	         		<div if={ !(contact.user_logged_in) } class="contact_online_status grey"></div>
	         		<span class="contact_row_username" onclick={ parent.openChatWindow } >{ contact.contact_user_username }</span>
	         		
	         		
		         	<div if={ contact.message_sent } onclick={ parent.openChatWindow } class="contact_option contact_new_message"> 
		         		<img src="img/message_bubble.png">
		         	</div>
		         	<div class="contact_option"> 
	         			<img onclick={ showContactOptions } hide={ contactOptions == contact.contact_user_email } src="img/right_arrow.png">
		         		<img onclick={ showContactOptions } show={ contactOptions == contact.contact_user_email } src="img/down_arrow.png">
		         	</div>
		         	<div class="contact_option_btn_div" show={ contactOptions == contact.contact_user_email } >
		         		<p class="contact_option_btn user_contact_email_word_break cursor-pointer" onclick={ parent.showContactProfile }>{ contact.contact_user_email }</p>
			         	<a class="contact_option_btn cursor-pointer" onclick={ parent.showConfirmdeleteContact }>Remove</a>
			         	<a class="contact_option_btn cursor-pointer" onclick={ parent.showConfirmblockContact }>Block</a>
		         	</div>
	         	</div>
	         </div>
	         <div if={ hasNoData } class="contact_row all_user_contacts has_no_data" >
	         	<span >No contacts have been added.</span>
	         </div>
         </div>
      
   </div>
   <script>

   var self = this;
   this.on('before-mount', function(){
		this.add_contact = false;
		this.btn_add_contact = true;
		this.err_user_to_add = false;
		this.err_user_to_add_message = "";
		this.load_contacts = false;
		this.contactOptions = "";
		this.hasNoData = false;
		self.allContactsVisible = true;
		self.showAllUserContacts = true;
		self.user_contacts_search = null;
   });

   this.on('update', function(){
   		this.load_contacts = true;
   });

   	showAllContactsNav(e){
	    if(self.allContactsVisible == false){
	      self.allContactsVisible = true;
	      self.parent.tags['pending-requests'].update({
	            pendingRequestsVisible: false
	          });
	      self.parent.tags['blocked-contacts'].update({
            blockedContactsVisible: false
          });
	    }
	    else{
	      	self.allContactsVisible = false;
	      	self.resetAddContactErrors();
			self.add_contact = false;
			self.refs.user_to_add.value = "";
	    }
	    self.update();
	}

	searchContacts(e){
		var searchString = self.refs.contact_search.value.trim().toLowerCase();;
		if(searchString != ""){
			if(self.user_contacts){
				self.user_contacts_search = [];
				
				for(var i in self.user_contacts){
					var username = self.user_contacts[i].contact_user_username.toLowerCase();;
					var email = self.user_contacts[i].contact_user_email.toLowerCase();;
					if( username.search(searchString) > -1 || email.search(searchString) > -1 ){

						self.user_contacts_search.push(self.user_contacts[i]);
					}
				}
				self.showAllUserContacts = false;
				self.update();
			}
		}
		else{
			self.showAllUserContacts = true;
			self.user_contacts_search = null;
			self.update();
		}
		
	}

    openChatWindow(e){

    	if(typeof self.parent.parent.tags['app-main-content'].user_contact != "undefined" && self.parent.parent.tags['app-main-content'].user_contact != null){
    		if(typeof self.parent.parent.tags['app-main-content'].user_contact.chat_id != "undefined" ){
    			chat_ref.child(self.parent.parent.tags['app-main-content'].user_contact.chat_id).off('value');
    		}
    	}
    	self.parent.parent.tags['app-main-content'].viewProfile = false;
    	self.parent.parent.tags['app-main-content'].changePassword = false;
    	self.parent.parent.tags['app-main-content'].viewContactProfile = false;

         self.parent.parent.tags['app-main-content'].hideChangePasswordErrors();
         self.parent.parent.tags['app-main-content'].hideEditUserProfileErrors();
    	
    	var user_contact = e.item.contact;
    	
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
			   			user_contact: e.item.contact,
			   			user_chats: user_chats
			   		});
              	});

			}
			else{
				self.parent.parent.tags['app-main-content'].update({
		   			user: self.user,
		   			user_contact: e.item.contact,
		   			user_chats: []
		   		});	
			}
		});
   		
    }

    showContactProfile(e){
    	self.showContactOptions(e);
    	if(typeof self.parent.parent.tags['app-main-content'].user_contact != "undefined" && self.parent.parent.tags['app-main-content'].user_contact != null){
    		if(typeof self.parent.parent.tags['app-main-content'].user_contact.chat_id != "undefined" ){
    			chat_ref.child(self.parent.parent.tags['app-main-content'].user_contact.chat_id).off('value');
    		}
    	}
    	self.parent.parent.tags['app-main-content'].viewProfile = false;
    	self.parent.parent.tags['app-main-content'].changePassword = false;
    	self.parent.parent.tags['app-main-content'].viewContactProfile = true;

         self.parent.parent.tags['app-main-content'].hideChangePasswordErrors();
         self.parent.parent.tags['app-main-content'].hideEditUserProfileErrors();
    	
    	var user_contact = e.item.contact;

    	self.parent.parent.tags['app-main-content'].update({
   			user: self.user,
   			user_contact: user_contact
   		});

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

    showConfirmdeleteContact(e){
    	var delete_contact_obj = e.item.contact;
    	self.parent.parent.tags['modal'].update({
	          title: "Confirm!",
	          message: "Are you sure you want to remove "+delete_contact_obj.contact_user_username+"("+delete_contact_obj.contact_user_email+") from your Contacts?",
	          tag_initiator: "all-contacts",
	          showCancel: true,
	          functionToCall: "deleteContact",
	          functionToCallParameter: e
	    });
	    self.parent.parent.showModal();
    }

    deleteContact(e){
    	self.showContactOptions(e);
    	self.load_contacts = false;
    	var delete_contact_obj = e.item.contact;
		var get_user_contact = firebase_db_obj.ref("Contacts").child(self.user.uid+"/"+delete_contact_obj.contact_user_uid);
			get_user_contact.once('value').then(function(snapshot){
	  			if(snapshot.exists()){
	  				firebase_db_obj.ref("Contacts").child(self.user.uid).update({
	  					[delete_contact_obj.contact_user_uid]: null
	  				})
	  				.then(function(update_data){
	  					if(typeof self.parent.parent.tags['app-main-content'].user_contact != "undefined" && self.parent.parent.tags['app-main-content'].user_contact != null){
      						if(self.parent.parent.tags['app-main-content'].user_contact.chat_id == delete_contact_obj.chat_id){
				    		chat_ref.child(self.parent.parent.tags['app-main-content'].user_contact.chat_id).off('value');
				    		self.parent.parent.tags['app-main-content'].user_contact = null;
					        self.parent.parent.tags['app-main-content'].viewProfile = false;
					        self.parent.parent.tags['app-main-content'].changePassword = false;
					        self.parent.parent.tags['app-main-content'].viewContactProfile = false;
					        self.parent.parent.tags['app-main-content'].user = self.user;
				    		self.parent.parent.tags['app-main-content'].update();
				    		}
				    	}
				    	
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
	          message: "Are you sure you want to block "+block_contact_obj.contact_user_username+"("+block_contact_obj.contact_user_email+") from your sending and recieving messages from you?",
	          tag_initiator: "all-contacts",
	          showCancel: true,
	          functionToCall: "blockContact",
	          functionToCallParameter: e
	    });
	    self.parent.parent.showModal();
    }
   
    blockContact(e){
    	self.showContactOptions(e);
    	self.load_contacts = false;
   		var block_contact_obj = e.item.contact;
		var get_user_contact = firebase_db_obj.ref("Contacts").child(self.user.uid+"/"+block_contact_obj.contact_user_uid);
			get_user_contact.once('value').then(function(snapshot){
      			if(snapshot.exists()){
      				firebase_db_obj.ref("Contacts").child(self.user.uid+"/"+block_contact_obj.contact_user_uid).update({
      					blocked: true
      				})
      				.then(function(update_data){
      					if(typeof self.parent.parent.tags['app-main-content'].user_contact != "undefined" && self.parent.parent.tags['app-main-content'].user_contact != null){
      						if(self.parent.parent.tags['app-main-content'].user_contact.chat_id == block_contact_obj.chat_id){
				    		chat_ref.child(self.parent.parent.tags['app-main-content'].user_contact.chat_id).off('value');
	    		    		self.parent.parent.tags['app-main-content'].user_contact = null;
	    			        self.parent.parent.tags['app-main-content'].viewProfile = false;
	    			        self.parent.parent.tags['app-main-content'].changePassword = false;
	    			        self.parent.parent.tags['app-main-content'].viewContactProfile = false;
	    			        self.parent.parent.tags['app-main-content'].user = self.user;
	    		    		self.parent.parent.tags['app-main-content'].update();
				    		}
				    	}
				    	self.parent.parent.tags['modal'].update({
                              title: "Success!",
                              message: block_contact_obj.contact_user_username+"("+block_contact_obj.contact_user_email+") has been successfully blocked.",
                              tag_initiator: "all-contacts",
                              showCancel: false
                        });
                        self.parent.parent.showModal();
      					self.load_contacts = true;
              			self.update();
      				});
      			}
      		});
    }

   	this.resetAddContactErrors = function(){
   		this.err_user_to_add = false;
		this.err_user_to_add_message = "";
   	}

   	self.checkContactExists = function(user_to_add){
   		for(var i = 0 ;  i < self.user_contacts.length; i++){
   			if(self.user_contacts[i].contact_user_email == user_to_add){
   				return false;
   			}
   		}
   		return true;
   	}

   	addContactEnter(e){
       if(e.key == "Enter"){
       		if(self.parent.parent.openModal == false){ 
            	self.addContact();
            }
       }
    }

   	addContact(e){
   		this.resetAddContactErrors();
   		var user_to_add = this.refs.user_to_add.value.trim();

   		if(user_to_add == ""){
   			self.err_user_to_add_message = "Please an enter email to invite.";
   			self.err_user_to_add = true;
   			self.update();
   		}
   		else if(user_to_add == self.user.user_email){
   			self.err_user_to_add_message = "Please do not add yourself as contact.";
   			self.err_user_to_add = true;
   			self.update();
   		}
   		else if(self.checkContactExists(user_to_add) == false){
   			self.err_user_to_add_message = "User is already your contact";
   			self.err_user_to_add = true;
   			self.update();
   		}
   		else if(this.validateEmail(user_to_add) == false){
   			self.err_user_to_add_message = "Enter a valid email.";
   			self.err_user_to_add = true;
   			self.update();
   		}
   		else{
   			this.btn_add_contact = false;
   			firebase_db_obj.ref().child("Users").orderByChild("user_email").equalTo(user_to_add).once("value").then(function(snapshot) {
	            if(snapshot.exists()){
	               var user_invite_data = snapshot.toJSON();
	               if(user_invite_data != null){
	                  if(typeof user_invite_data == "object"){
	                  	var user_invite_data_obj = {};
	                  	user_invite_data_obj["id"] = (Object.keys(user_invite_data))[0];
	                  	var chat_id = self.generateUID()+"";
	                  	var check_user_invite = firebase_db_obj.ref("Contacts").child(user_invite_data_obj.id+"/"+self.user.uid);
	                  		check_user_invite.once('value').then(function(snapshot){
	                  			if(snapshot.exists()){
	                  				if((snapshot.toJSON()).blocked == false){
                  						var send_user_invite = firebase_db_obj.ref("Contacts").child(user_invite_data_obj.id);
					                  	send_user_invite.update({
						                  		[self.user.uid]: {
							                  		contact_user_uid : self.user.uid,
						                  			contact_user_email : self.user.user_email,
						                  			contact_user_username : self.user.user_username,
						                  			chat_started : false,
						                  			chat_id : (snapshot.toJSON()).chat_id,
						                  			message_sent : false,
						                  			blocked : false
							                  	}
						                  	})
						                  	.then(function(return_data){
						                  		self.parent.parent.tags['modal'].update({
					                              title: "Success!",
					                              message: "An invite has been successfully sent to "+user_to_add,
					                              tag_initiator: "all-contacts",
					                              showCancel: false
					                        });
					                        self.parent.parent.showModal();
					                        self.refs.user_to_add.value = "";
						                  		self.btn_add_contact = true;
						                  		self.update();
					                  	});
	                  				}
	                  				else{
	                  					elf.err_user_to_add_message = "User has already been sent an invite.";
   										self.err_user_to_add = true;
	                  					self.btn_add_contact = true;
						                self.update();
	                  				}
	                  			}
	                  			else{
		                  			var send_user_invite = firebase_db_obj.ref("Contacts").child(user_invite_data_obj.id);
				                  	send_user_invite.update({
				                  		[self.user.uid]: {
					                  		contact_user_uid : self.user.uid,
				                  			contact_user_email : self.user.user_email,
				                  			contact_user_username : self.user.user_username,
				                  			chat_started : false,
				                  			chat_id : chat_id,
				                  			message_sent : false,
				                  			blocked : false
						                }
				                  	})
				                  	.then(function(return_data){
				                  		self.parent.parent.tags['modal'].update({
				                              title: "Success!",
				                              message: "An invite has been successfully sent to "+user_to_add,
				                              tag_initiator: "all-contacts",
				                              showCancel: false
				                        });
				                        self.parent.parent.showModal();
				                        self.refs.user_to_add.value = "";
				                  		self.btn_add_contact = true;
				                  		self.update();
				                  	});
			                  	}
		                  	});
	                  }
	               }
	               else{
	               		self.btn_add_contact = true;
	               		self.err_user_to_add_message = "Entered email is not a Riot Chat User.";
	               		self.err_user_to_add = true;
	               		self.update();
	               }
	            }
	            else{
	            	self.btn_add_contact = true;
	            	self.err_user_to_add_message = "Entered email is not a Riot Chat User.";
               		self.err_user_to_add = true;
               		self.update();
	            }
	         });
	   	}
   	}

   	this.validateEmail  =  function(user_email){  
	    if (/^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/.test(user_email))  
		  {  
		    return true;  
		  }  
		  return false;
	};

	this.generateUID = function(){
		var max = 99999;
		var min = 10000;
		
	    var d = new Date();
	    var n = d.valueOf();
		n = n + "" + parseInt(Math.random() * (max - min) + min);

		
		n = parseFloat(n);
		
		return n;
	}

   </script>
</all-contacts>