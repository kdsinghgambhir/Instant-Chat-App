<app-nav>
   
       <div class="app_nav_id_outter_div">
          <div if={ user }>
             <user-data user={ user } ></user-data>
             <all-contacts  title="Contacts" user={ user }></all-contacts>
             <pending-requests  title="Pending Requests"></pending-requests>
             <blocked-contacts  title="Blocked Contacts"></blocked-contacts>
         </div>
      </div>

    <script>
      var self = this;
      this.on('update', function()
      {
         if(self.user != null && self.user.uid != "")
         {
               user_ref.child(self.user.uid).on('value', function(snapshot)
               {
                 if(snapshot.exists())
                 {
                     var user_additional_data = snapshot.toJSON();
                     if(user_additional_data.user_logged_in == true)
                     {
                        self.current_user_obj = snapshot.toJSON();
                        self.current_user_obj.uid = self.user.uid;
                        self.user.user_chat_status = self.current_user_obj.user_chat_status;
                        self.user.user_status = self.current_user_obj.user_status;
                        self.user.displayName = self.current_user_obj.user_username;
                        self.user.email = self.current_user_obj.user_email;
                        
                        self.tags['all-contacts'].update({
                           user: self.current_user_obj
                        });
                        
                        self.tags['pending-requests'].update({
                           user: self.current_user_obj
                        });
                        
                        self.tags['blocked-contacts'].update({
                           user: self.current_user_obj
                        });
                        
                        self.parent.tags['app-main-content'].update({
                           user: self.current_user_obj
                        });
                        
                        contact_ref.child(self.user.uid).on('value', function(snapshot) 
                        {
                             if(snapshot.exists())
                             {
                                 var user_additional_data_contacts = snapshot.toJSON();
                                 if(self.current_user_obj.user_logged_in == true)
                                 {
                                    self.current_user_contacts_obj = [];
                                       for(var key in user_additional_data_contacts)
                                       {
                                            if (user_additional_data_contacts.hasOwnProperty(key))
                                             {
                                               self.current_user_contacts_obj.push(user_additional_data_contacts[key]);
                                            }
                                       }

                                       user_ref.on('value', function(snapshot)
                                       {
                                             if(snapshot.exists())
                                             {
                                                var all_users = snapshot.toJSON();
                                                for(var key in all_users)
                                                {
                                                   for(var i = 0; i < self.current_user_contacts_obj.length; i++)
                                                   {
                                                      if(key == self.current_user_contacts_obj[i].contact_user_uid)
                                                      {
                                                         self.current_user_contacts_obj[i]["user_logged_in"] = all_users[key]["user_logged_in"];
                                                         self.current_user_contacts_obj[i]["user_status"] = all_users[key]["user_status"];
                                                         self.current_user_contacts_obj[i]["contact_user_username"] = all_users[key]["user_username"];
                                                         self.current_user_contacts_obj[i]["user_chat_status"] = all_users[key]["user_chat_status"];

                                                      }
                                                   }
                                                }

                                                var hasNoBlockedContacts = self.checkForBlockedData(self.current_user_contacts_obj);
                                                var hasNoPendingContacts = self.checkForPendingRequestsData(self.current_user_contacts_obj);
                                                var hasNoContacts = self.checkForContactsData(self.current_user_contacts_obj);
                                                var pending_requests_count = self.getPendingRequestsCount(self.current_user_contacts_obj);

                                                self.parent.tags['app-main-content'].update({
                                                  user_has_contacts: true
                                                });

                                                self.tags['all-contacts'].update({
                                                   user_contacts: self.current_user_contacts_obj,
                                                   hasNoData: hasNoContacts
                                                });

                                                self.tags['pending-requests'].update({
                                                   user_contacts: self.current_user_contacts_obj,
                                                   hasNoData: hasNoPendingContacts,
                                                   pending_requests_count: pending_requests_count
                                                });

                                                self.tags['blocked-contacts'].update({
                                                   user_contacts: self.current_user_contacts_obj,
                                                   hasNoData: hasNoBlockedContacts
                                                });
                                             }
                                             
                                             else
                                             
                                             {

                                                var hasNoBlockedContacts = self.checkForBlockedData(self.current_user_contacts_obj);
                                                var hasNoPendingContacts = self.checkForPendingRequestsData(self.current_user_contacts_obj);
                                                var hasNoContacts = self.checkForContactsData(self.current_user_contacts_obj);
                                                var pending_requests_count = self.getPendingRequestsCount(self.current_user_contacts_obj);
                                                console.log(pending_requests_count);

                                                self.parent.tags['app-main-content'].update({
                                                   user_has_contacts: true
                                                });
                                             
                                                self.tags['all-contacts'].update({
                                                   user_contacts: self.current_user_contacts_obj,
                                                   hasNoData: hasNoContacts
                                                });
                                             
                                                self.tags['pending-requests'].update({
                                                   user_contacts: self.current_user_contacts_obj,
                                                   hasNoData: hasNoPendingContacts,
                                                   pending_requests_count: pending_requests_count
                                                });
                                             
                                                self.tags['blocked-contacts'].update({
                                                   user_contacts: self.current_user_contacts_obj,
                                                   hasNoData: hasNoBlockedContacts
                                                });
                                             
                                             }
                                       });
                                    
                                 }
                             }
                             else
                             {
                                 self.parent.tags['app-main-content'].update({
                                     user_has_contacts: false
                                  }); 
                             
                                 self.tags['all-contacts'].update({
                                    user_contacts: [],
                                    hasNoData: true
                                 });
                             
                                 self.tags['pending-requests'].update({
                                    user_contacts: [],
                                    hasNoData: true,
                                    pending_requests_count: 0
                                 });
                             
                                 self.tags['blocked-contacts'].update({
                                    user_contacts: self.current_user_contacts_obj,
                                    hasNoData: true
                                 });                        
                              }
                        });
                     }
                 }
                 else
                 {

                 }
               });
         }
      });
      
      self.checkForBlockedData = function(user_contacts)
      {
          for(var i in user_contacts)
          {
            if(user_contacts[i].blocked == true)
            {
              return false;
            }
          }
          return true;
        }

        self.checkForPendingRequestsData = function(user_contacts)
        {
          for(var i in user_contacts)
          {
            if(user_contacts[i].blocked == false && user_contacts[i].chat_started == false){
              return false;
            }
          }
          return true;
        }

        self.getPendingRequestsCount = function(user_contacts){
          var count = 0;
          for(var i in user_contacts)
          {
            if(user_contacts[i].blocked == false && user_contacts[i].chat_started == false){
              count = count + 1;
            }
          }
          return count;
        }

        self.checkForContactsData = function(user_contacts){
          for(var i in user_contacts){
            if(user_contacts[i].blocked == false && user_contacts[i].chat_started == true){
              return false;
            }
          }
          return true;
        }

   </script>
   
</app-nav>