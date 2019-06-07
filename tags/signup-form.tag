<signup-form>

    <div class="signup_form_outter_div" onkeypress={ keypressedEnter }>
      <div class="form_row_header">
          <label class="font-24">Sign up</label>
      </div>
      <div class="form_row_body margin-50">
      <div class="form_row">
        <input class="form_row_input" type="text" maxlength="23" placeholder="Please select your Username !" ref="user_username"  autocomplete="off" value="" />
      </div>
    	<div class="form_row">
  			<input class="form_row_input" type="text" placeholder="What is your Email Id ?" ref="user_email" autocomplete="off" value="" />
  		</div>
  		<div show={ err_user_email } class="form_row">
      		<span class="form_error">Please enter an Email Id.</span>
  		</div>
  		<div show={ err_user_email_valid } class="form_row">
      		<span class="form_error">Please enter a valid Email Id.</span>
  		</div>
  		<div class="form_row">
  			<input class="form_row_input" type="password" placeholder="Please provide your Password !" ref="user_pass" autocomplete="off" value=""/>
  		</div>
  		<div show={ err_user_pass } class="form_row">
      		<span class="form_error">Please enter a password.</span>
  		</div>
      <div class="form_row">
        <input class="form_row_input" type="password" placeholder="Please Confirm your Password !" ref="user_confirm_pass" oninput={ validatePasswordMatch } autocomplete="off" value=""/>
      </div>
      <div show={ err_user_confirm_pass } class="form_row">
          <span class="form_error">Please confirm your password.</span>
      </div>
      <div show={ err_user_confirm_pass_match } class="form_row">
          <span class="form_error">Passwords do not match.</span>
      </div>
      <div show={ err_auth } class="form_row">
          <span class="form_error">{ auth_error_message }</span>
      </div>
  		<div class="form_row">
  			<a class="a_btn" show = { btn_signup } onclick={ userSignUp }>Sign Up</a>
  			<img class="btn_loader" hide = { btn_signup } src="img/loading.gif">
  		</div>
      <div class="form_row">
           If you are Already a Member !<a class="a_href" onclick={ gotoLogin } > Please Login</a>
      </div>
      </div>
  	</div>
  

  <script>

  	var self = this;
  	
  	this.on('before-mount', function() {
        this.initTag();
	  });

    this.initTag = function(){
        this.err_user_username = false;
        this.err_user_email = false;
        this.err_user_email_valid = false;
        this.err_user_pass = false;
        this.err_user_confirm_pass = false;
        this.err_user_confirm_pass_match = false;
        this.err_auth = false;
        this.auth_error_message = "";
        this.btn_signup = true;
    }

    gotoLogin(e){
      this.parent.newUser = false;
      this.parent.update();
    }
  	
    validatePasswordMatch(e){
      var user_pass = this.refs.user_pass.value+"";
      var user_confirm_pass = this.refs.user_confirm_pass.value+"";
      if(user_pass.trim() == user_confirm_pass.trim()){
        this.err_user_confirm_pass_match = false;
      }
      else{
        this.err_user_confirm_pass_match = true;
      }
    }

    keypressedEnter(e){
       if(e.key == "Enter"){
          if(self.parent.openModal == false){
            self.userSignUp();
          }

       }
    }

  	userSignUp(e) {
  	    this.hideErrors();
  	    var is_valid = this.validateSignUpForm();

  	    if(is_valid == true){
  	    	this.btn_signup = false;
          var user_username = this.refs.user_username.value+"";
          var user_email = this.refs.user_email.value+"";
          var user_pass = this.refs.user_pass.value+"";
  	    	
          try{
            firebase_auth_obj.createUserWithEmailAndPassword(user_email, user_pass)
            .then(function(user_data){
                user_data.updateProfile({
                      displayName: user_username,
                  }).then(function() {
                      user_data.sendEmailVerification().then(function() {
                        var user_additional_data = user_ref.child(user_data.uid);
                        user_additional_data.once('value').then(function(snapshot) {
                              if(snapshot.exists()){

                              } 
                              else{
                               user_additional_data.set({
                                  user_username : user_username,
                                  user_email : user_email,
                                  user_logged_in : false,
                                  user_status : "Available",
                                  user_chat_status: 0
                                });
                              }
                           
                         });
                        this.parent.newUser = false;
                        self.btn_signup = true;
                        self.parent.tags['modal'].update({
                              title: "Sign-Up Successful!",
                              message: "You have been Successfully registered to the Riot Chat App. You will shortly recieve an email on your registered email id to verify your registration.",
                              tag_initiator: "signup-form",
                              showCancel: false
                        });
                        self.parent.newUser = false;
                        self.parent.showModal();
                        this.refs = [];
                        self.update();
                      }).catch(function(error) {
                        if(error){
                          self.btn_signup = true;
                          var errorCode = error.code;
                          self.auth_error_message = error.message;
                          self.err_auth = true;
                          this.refs = [];
                          self.update();
                        }
                      });
                  }, function(error) {
                    if(error){
                      self.btn_signup = true;
                      var errorCode = error.code;
                      self.auth_error_message = error.message;
                      self.err_auth = true;
                      self.refs.user_pass.value = "";
                      self.refs.user_confirm_pass.value = "";
                      self.update();
                    }
                });
            })
            .catch(function(error) {
                if(error){
                  self.btn_signup = true;
                  var errorCode = error.code;
                  self.auth_error_message = error.message;
                  self.err_auth = true;
                  self.refs.user_pass.value = "";
                  self.refs.user_confirm_pass.value = "";
                  self.update();
                }
            });
          }
          catch(e){
            console.log(e);
          }

  	    	
  	    }
 	};

 	this.hideErrors =  function(){
      this.err_user_username = false;
 		  self.err_user_email = false;
	  	self.err_user_email_valid = false;
	  	self.err_user_pass = false;
      self.err_user_confirm_pass = false;
      self.err_auth = false;
      self.update();
 	};

 	this.validateSignUpForm =  function(){
    var user_username = this.refs.user_username.value+"";
 		var user_email = this.refs.user_email.value+"";
 		var user_pass = this.refs.user_pass.value+"";
    var user_confirm_pass = this.refs.user_confirm_pass.value+"";

    if(user_username.trim() == ""){
      this.err_user_username = true;
      return false;
    }
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
    if(user_confirm_pass.trim() == ""){
      this.err_user_confirm_pass = true;
      return false;
    }
    if(user_confirm_pass.trim() != user_pass.trim()){
      this.err_user_confirm_pass_match = true;
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

</signup-form>