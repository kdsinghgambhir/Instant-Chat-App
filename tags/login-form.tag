<login-form>
	
  <style type="text/css">
  
    </style>
    
      <div class="login_form_outter_div" onkeypress={ keypressedEnter }>
    
      <div class="form_row_header">
          <label class="font-24" >Login</label>
      </div>
    
      <div class="form_row_body margin-50">
    
      <div show={ err_auth } class="form_row">
        <span class="form_error">{ auth_error_message }</span>
      </div>
    
    	<div class="form_row">
			   <input class="form_row_input" placeholder="What is your Email id??" type="text" ref="user_email" autocomplete="off" value="" />
		  </div>
		
      <div show={ err_user_email } class="form_row">
      	 	<span class="form_error">Please enter your Email Id.</span>
		  </div>
		
      <div show={ err_user_email_valid } class="form_row">
      		<span class="form_error">It is an Invalid Email Id! Please provide a Valid Email Id to Login</span>
		  </div>
		
     <div class="form_row">
	   		<input class="form_row_input" type="password" placeholder="Please Provide your Password to access it!!" ref="user_pass" autocomplete="off" value="" />
		  </div>
		 
      <div show={ err_user_pass } class="form_row">
    	  	<span class="form_error">Please provide your password.</span>
	   	</div>
		
      <div class="form_row">
			 <a class="a_btn" show = { btn_login } onclick={ userLogin }>Sign In</a>
	   		<img class="btn_loader" hide = { btn_login } src="img/loading.gif">
		  </div>

		  <div show = { btn_login } class="form_row">
			 Are you not a Registered User ? <a class="a_href" onclick={ gotoSignUp }>Please Sign Up</a>
	   	</div>

      <div show = { btn_login } class="form_row">
        <a class="a_href"  onclick={ gotoSignInHelp }>Do you need any help to Sign In?</a>
      </div>
    
    </div>
	
  </div>
  
  <script>
  	var self = this;
  
  	this.on('before-mount', function() 
    {
  		this.err_user_email = false;
	  	this.err_user_email_valid = false;
	  	this.err_user_pass = false;
	  	this.err_auth = false;
      this.auth_error_message = "";
		  this.btn_login = true;
	  }
    );

  	gotoSignUp(e)
    {
  		this.parent.update({
        newUser: true
      });
	  }

   gotoSignInHelp(e)
   {
      this.parent.update({
        signInHelp: true
      });
   }

   keypressedEnter(e)
   {
       if(e.key == "Enter"){ 
            self.userLogin();
       }
   }
  	
   userLogin(e) 
   {

  	    this.hideErrors();
  	    var is_valid = this.validateLoginForm();

  	    if(is_valid == true)
        {
  	    	self.parent.checkReverificationLink = true;
  	    	self.btn_login = false;
  	    	var user_email = self.refs.user_email.value;
 			    var user_pass = self.refs.user_pass.value;

  	    	firebase_auth_obj.signInWithEmailAndPassword(user_email, user_pass)
  	    	.then(function(user_data){
  	    		if(user_data.emailVerified == true)
            {
				        self.btn_login = true;
              	self.update();
                self.parent.app_loading = true;
              	self.parent.userLoggedIn = true;
              	self.parent.checkReverificationLink = false;
                self.parent.update();
            }
            else
            {
              		self.btn_login = true;
	              	self.err_auth = true;
       				    self.auth_error_message = "Your account needs to be verified.";
                  self.refs.user_pass.value = "";
       				    self.update();
            }
              self.refs.user_email.value = "";
              self.refs.user_pass.value = "";
  	    	})
          .catch(function(error) 
          {
              if(error)
              {
                self.btn_login = true;
                var errorCode = error.code;
                self.auth_error_message = "The email id or password you entered are invalid. Please try again! ";
                self.err_auth = true;
                self.refs.user_pass.value = "";
                self.update();
              }
          });
          }

 	};

 	this.hideErrors =  function()
  {
 		self.err_user_email = false;
	  	self.err_user_email_valid = false;
	  	self.err_user_pass = false;
	  	self.err_auth = false;
        self.auth_error_message = "";
 	};

 	this.validateLoginForm =  function()
  {
 		var user_email = self.refs.user_email.value;
 		var user_pass = self.refs.user_pass.value;

 		if(user_email.trim() == "")
    {
 			self.err_user_email = true;
 			return false;
 		}
 		if(self.validateEmail(user_email.trim()) == false)
    {
 			self.err_user_email_valid = true;
 			return false;
 		}
 		if(user_pass.trim() == "")
    {
 			self.err_user_pass = true;
 			return false;
 		}
 		return true;
 	};

 	this.validateEmail  =  function(user_email)
  {  
	    if (/^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/.test(user_email))  
		  {  
		    return true;  
		  }  
		  return false;
	};

  </script>

</login-form>