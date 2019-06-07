<signin-help-form>
    </style>

    <div class="signin_help_form_outter_div" onkeypress={ keypressedEnter }>
      <div class="form_row_header">
          <label>Sign-In Help</label>
      </div>
        <div class="form_row_body margin-50">
      <!-- <div class="form_row" if={ selectionMade } >
        <div class="div_back_btn" onclick={ signInHelpOptions }>
            <img src="img/back_button.png">
        </div>
      </div> -->

      <div  class="form_row">
        <a class="a_btn" show = { btn_help && !selectionMade } onclick={ showVerificationLink }>Having any problems with the Verification link</a>
        <a class="a_btn" show = { btn_help && !selectionMade } onclick={ showForgotPasswordLink }>Did you Forget your Password! Click Me</a>
      </div>

      <div show = { btn_help && selectionMade } class="form_row">
        <label if={ verificationLink }>Enter your Email ID and Password to recieve a new Verification link:</label>
        <label if={ forgotPassword }>Enter your Registered Riot Chat Email ID to recieve the Forgot Password link:</label>
      </div>

    	<div show= { verificationLink || forgotPassword } class="form_row">
			 <input class="form_row_input" placeholder="Enter your Email ID" type="text" ref="user_email" autocomplete="off" value="" />
  		</div>
  		<div show={ err_user_email } class="form_row">
      		<span class="form_error">Please enter your Email Id.</span>
  		</div>
  		<div show={ err_user_email_valid } class="form_row">
      		<span class="form_error">Please enter a valid Email Id.</span>
  		</div>
  		<div show= { verificationLink } class="form_row">
  			<input class="form_row_input" placeholder="Enter your Password" type="password" ref="user_pass" autocomplete="off" value=""/>
  		</div>
  		<div show={ err_user_pass } class="form_row">
      		<span class="form_error">Please enter your password.</span>
  		</div>


      <div show={ err_auth } class="form_row">
            <span class="form_error">{ auth_error_message }</span>
      </div>

  		<div class="form_row">
  			<a class="a_btn a_href_resend_verification_link" show = { btn_help && verificationLink }  onclick={ sendVerificationLink }>Resend Verification Link</a>
        <a class="a_btn a_href_resend_verification_link" show = { btn_help && forgotPassword } onclick={ sendResetPasswordLink }>Forgot Password</a>
  			<img class="btn_loader" hide = { btn_help } src="img/loading.gif">
  		</div>

      <div class="form_row" >
        <a class="a_href"  onclick={ gotoLogin }><< Back to Login</a>
      </div>
      
		  </div>
	</div>
  

  <script>

  	var self = this;
  	
  	this.on('before-mount', function() {
      this.selectionMade = false
  		this.err_user_email = false;
	  	this.err_user_email_valid = false;
	  	this.err_user_pass = false;
	  	this.err_auth = false;
      this.auth_error_message = "";
      this.btn_help = true;
		  this.verificationLink = false;
      this.forgotPassword = false;
	  });


    keypressedEnter(e){
       if(e.key == "Enter"){
        if(self.parent.openModal == false){
            if(self.verificationLink == true){
                self.sendVerificationLink();
            }
            else if(self.forgotPassword == true){
                self.sendResetPasswordLink();
            }
          }
       }
    }

    signInHelpOptions(e){
      this.hideErrors();
      self.update({
        selectionMade: false,
        verificationLink: false,
        forgotPassword: false,
        btn_help: true
      });
    }

    gotoLogin(e){
      this.parent.newUser = false;
      this.parent.update({
          signInHelp: false
      });
    }
  	
  	showVerificationLink(e){
        if(self.verificationLink == false){
          self.verificationLink = true;
        }
        else{
          self.verificationLink = true;
        }
        self.selectionMade = true;
        self.update();
    }

    showForgotPasswordLink(e){
        if(self.forgotPassword == false){
          self.forgotPassword = true;
        }
        else{
          self.forgotPassword = true;
        }
        self.selectionMade = true;
        self.update();
    }

   	sendVerificationLink(e){

   		    this.hideErrors();
    	    var is_valid = this.validateVerificationForm();

    	    if(is_valid == true){
    	    	this.btn_help = false;
    	    	var user_email = this.refs.user_email.value;
       			var user_pass = this.refs.user_pass.value;
       			self.parent.checkReverificationLink = true;

      	    	firebase_auth_obj.signInWithEmailAndPassword(user_email, user_pass)
      	    	.then(function(user_data){
      	    		if(user_data.emailVerified == false){
    					user_data.sendEmailVerification().then(function() {
                            self.parent.tags['modal'].update({
                              title: "Success!",
                              message: "A reverification link has been successfully sent to your registered Riot Chat email id.",
                              tag_initiator: "signup-help-form",
                              showCancel: false
                            });
                            self.parent.showModal();
                            this.refs.user_email.value = "";
                            self.signInHelpOptions();
                          }).catch(function(error) {
                            if(error){
                              self.btn_help = true;
                              var errorCode = error.code;
                              self.auth_error_message = error.message;
                              self.err_auth = true;
                              self.update();
                            }
                          });
                  	}
                  	else{
                  		firebase_auth_obj.signOut()
                  		.then(function(){
                  			self.err_auth = true;
    	       				    self.auth_error_message = "Your account is already verified.";
    	       				    self.update();
                  		})
                  		.catch(function(error){
    		               	if(error){
    		                	alert(error.message);
    		               	}
    		         	});
                  	}
      	    	})
                .catch(function(error) {
                    if(error){
                      self.btn_help = true;
                      var errorCode = error.code;
                      self.auth_error_message = "The email id or password you entered are invalid. Please try again! ";
                      self.err_auth = true;
                      self.update();
                    }
                });
                this.refs.user_pass.value = "";
  	    }
 	}

 	sendResetPasswordLink(e){
    this.hideErrors();
 		var user_email = this.refs.user_email.value.trim();

 		if(user_email == ""){
 			this.err_user_email = true;
 			return false;
 		}
 		else if(this.validateEmail(user_email) == false){
 			this.err_user_email_valid = true;
 			return false;
 		}
 		else{
      self.btn_help = false;
			firebase_auth_obj.sendPasswordResetEmail(user_email).then(function(){
        self.parent.tags['modal'].update({
            title: "Success!",
            message: "A reverification link has been successfully sent to your registered Riot Chat email id.",
            tag_initiator: "signup-help-form",
            showCancel: false
          });
          self.parent.showModal();
          self.signInHelpOptions();
			}).catch(function(error) {
			    self.btn_help = true;
        	var errorCode = error.code;
        	self.auth_error_message = error.message;
        	self.err_auth = true;
        	self.update();
			});
      this.refs.user_email.value = "";
		}
 	}

 	this.hideErrors =  function(){
 		this.err_user_email = false;
  	this.err_user_email_valid = false;
  	this.err_user_pass = false;
  	this.err_auth = false;
    this.auth_error_message = "";
 	};

 	this.validateVerificationForm =  function(){
 		var user_email = this.refs.user_email.value;
 		var user_pass = this.refs.user_pass.value;

 		if(user_email.trim() == ""){
 			this.err_user_email = true;
 			return false;
 		}
 		if(this.validateEmail(user_email.trim()) == false){
 			this.err_user_email_valid = true;
 			return false;
 		}
 		if(user_pass.trim() == ""){
 			this.err_user_pass = true;
 			return false;
 		}
 		return true;
 	};

 	this.validateEmail  =  function(user_email){  
	    if (/^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/.test(user_email))  
		  {  
		    return true;  
		  }  
		  return false;
	};
  
	
	  
  </script>

</signin-help-form>