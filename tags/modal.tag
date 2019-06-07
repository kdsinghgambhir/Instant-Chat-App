<modal>
	<style type="text/css">

	</style>

	<div class="modal">
	
		<div class="modal_content">
			
			<div class="modal_header">
				<div class="close_btn" onclick={ closeModal }><img src="img/closebtn.png"></div>
				<div class="modal_title color-black">{ title }</div>	
	    	</div>
	    	
	    	<div class="modal_body">
	    		<div class="modal_message">
	    			<span>{ message }</span>
	    		</div>
	    	</div>
	    	<div class="modal_footer">
				<div class="modal_footer_buttons">
					<a class="a_btn" if={ showCancel } onclick={ closeModal }>Cancel</a>
					<a class="a_btn" onclick={ confirmModal }>OK</a>
				</div>
	    	</div>
	  	</div>

	</div>

	<script>
		var self = this;

		self.on('mount', function(){
			self.title = "Sample";
			self.message = "Sample message for Modal";
			self.tag_initiator = "";
			self.showCancel = false;
			self.functionToCall = "";
			self.functionToCallParameter = "";
		});

		closeModal(e){
			self.parent.update({
				openModal: false
			});
		}

		confirmModal(e){
			if(self.showCancel == false){
				self["closeModal"]();
			}
			else if(self.showCancel == true && self.tag_initiator != "" && self.functionToCall != ""){
				if(self.tag_initiator == "app-main-content" || self.tag_initiator == "header"){
					if(self.functionToCallParameter != ""){
						self.parent.tags[self.tag_initiator][self.functionToCall](self.functionToCallParameter);
						self.closeModal();
					}
					else{
						self.parent.tags[self.tag_initiator][self.functionToCall]();
						self.closeModal();
					}
				}
				if(self.tag_initiator == "all-contacts" || self.tag_initiator == "pending-requests" || self.tag_initiator == "blocked-contacts"){
					if(self.functionToCallParameter != ""){
						self.parent.tags['app-nav'].tags[self.tag_initiator][self.functionToCall](self.functionToCallParameter);
						self.closeModal();
					}
					else{
						self.parent.tags['app-nav'].tags[self.tag_initiator][self.functionToCall]();
						self.closeModal();
					}
				}
			}
			else{
				self["closeModal"]();	
			}
		}


	</script>

</modal>