require 'spec_helper'

describe "OwnershipPages" do
  
	subject { page }

	before(:each) do
 		Business.any_instance.stub(:geocode).and_return([1,1]) 
	end

	let!(:founder) 			{ FactoryGirl.create(:user) }
	let!(:administrator)	{ FactoryGirl.create(:user) }
	let!(:founder_biz)		{ FactoryGirl.create(:business, created_by: founder.id)}
	let!(:ownership_1) 		{ founder_biz.ownerships.find_by(user_id: founder.id) }

	describe "for business creator" do

		before { sign_in founder }

		describe "Index page" do
	
			before { visit my_business_ownerships_path(founder_biz) }

			it { should have_title("Frontline team") }
           	it { should have_content("Frontline team") }
           	it { should have_selector('h2', text: "for #{founder_biz.name}, #{founder_biz.city}")}
            it { should have_link("<- Business details", href: my_business_path(founder_biz)) }
            it { should have_selector('li', text: founder.name) }
            it { should have_selector('li', text: founder.email) }
            it { should_not have_selector('span.contact') }
            it { should_not have_selector('span.mobile') }
            it { should_not have_selector('span.glyphicon-sort') }		#no sort icon if only one owner listed
            it { should_not have_selector('li', text: administrator.name) }
            it { should have_link('edit', href: edit_ownership_path(ownership_1)) }
            it { should_not have_button('remove') }  #because only 1 owner
            it { should have_link('Add someone else ->', href: new_my_business_ownership_path(founder_biz)) }    
	 		it { should have_link('<- Business details', href: my_business_path(founder_biz)) }   
		
	 		pending "no test for jquery draggable sort - note that draggable js-enabled only"

	 		it "cannot delete the sole owner" do
	 			click_link "Sign out"
	 			sign_in founder, no_capybara: true
	 			expect do
           			delete ownership_path(ownership_1)
           			flash[:notice].should eq "Not removed! There has to be at least one team member."
         		end.not_to change(Ownership, :count)
         	end
	 	end

		describe "visit the New page" do

	         before { visit new_my_business_ownership_path(founder_biz) }

	         it { should have_title("New team member") }
	         it { should have_content("New team member") }
	         it { should have_selector('h2', text: "for #{founder_biz.name}, #{founder_biz.city}") }
	         it { should have_link("<- Team list", 
	         							href: my_business_ownerships_path(founder_biz)) }

	         describe "then create a new team-member successfully" do
	            before do
	                fill_in "The team member's email address",  with: administrator.email
	                choose "Yes"
	                fill_in "direct phone number", with: "0123-45678"
	            end

	            it "creates a new Ownership record" do
	               	expect do
	               	 click_button "Create"
	               	end.to change(founder_biz.ownerships, :count).by(1)

	               	@ownership = Ownership.last
	               	@ownership.created_by.should eq founder.id
	            end

	            describe "and redirects to the team list for this Business" do
	               	before do
	               		click_button 'Create'
	               		@ownership = Ownership.last
	               	end

	               	it { should have_title("Frontline team") }
	               	it { should have_selector('h2', text: "for #{founder_biz.name}, #{founder_biz.city}")}
	               	it { should have_selector('li', text: administrator.name) } 
	               	it { should have_selector('span.contact') }
	               	it { should have_selector('span.mobile') }
	               	it { should have_selector('span.glyphicon-sort') }		#with a second owner, draggable sort icon appears
	               	it { should have_selector('li', text: administrator.email) }
	               	it { should have_selector('div.alert.alert-success', 
	               		     text: "#{administrator.name} added to the team.") } 
	               	it { should have_button('remove') }  #because now >1 owner

	               	it "can delete team members when there are multiple members" do
	 					click_link "Sign out"
	 					sign_in founder, no_capybara: true
	 					expect do
	 	          			delete ownership_path(@ownership)
	 	          			flash[:success].should eq "Removed #{@ownership.user.name} from the team." 
	 	        		end.to change(Ownership, :count).by(-1)
	 	        	end

	 	        	it "does not delete the User when team member is removed" do
	 	        		click_link "Sign out"
	 					sign_in founder, no_capybara: true
	 					expect do
	 	          			delete ownership_path(ownership_1)
	 	        		end.not_to change(User, :count)
	 	        	end

	 	        	it "can delete self and successfuly redirect when there are other team-members" do
	 	        		click_link "Sign out"
	 					sign_in founder, no_capybara: true
	 					expect do
	 	          			delete ownership_path(ownership_1)
	 	          			flash[:success].should eq "You've taken yourself out of the team at #{founder_biz.name}, #{founder_biz.city}." 
	 	        		end.to change(Ownership, :count).by(-1)
	 	        	end
	             end
	         end

	         describe "then fail to create a new team-member successfully" do
	            
	            it "should not create an Ownership" do    #no parameters
	               	expect { click_button 'Create' }.not_to change(founder_biz.ownerships, :count)
	            end

	            describe "continue to show the New page with an error message" do

	               	before do
	                 	fill_in "The team member's email address", with: "   "
	                 	click_button "Create"
	               	end
	            
	               	it { should have_title("New team member") }
	               	it { should have_content("Sorry, we can't find this person in the HROOMPH listings.") }
	             end
	        end
	 	end

	 	describe "visit the Edit page" do

	 		before { visit edit_ownership_path(ownership_1) }

	 		it { should have_title('Team member update') }
	        it { should have_content('Team member update') }
	        it { should have_selector('h2', text: "#{founder_biz.name}, #{founder_biz.city}") }
	        it { should have_link('<- Cancel', href: my_business_ownerships_path(founder_biz)) }
	        it { should have_selector('input#ownership_contactable_true') }
	        it { should have_selector('input#ownership_phone') }
	        it { should have_selector('div.detail', text: founder.name) } 
	        it { should have_selector('div.detail', text: founder.email) } 

	        describe "make the team member contactable with phone number" do

	         	before do
	         		choose "Yes"
	                fill_in "direct phone number", with: "099 999 9999"
	                click_button "Confirm"
	            end

	            it { should have_title("Frontline team") }
	            it { should have_selector('h2', text: "for #{founder_biz.name}, #{founder_biz.city}") }
	            it { should have_selector('span.contact') }
	            it { should have_selector('span.mobile') }
	        end

	        describe "make the team member contactable with no phone number" do

	         	before do
	         		choose "Yes"
	                click_button "Confirm"
	            end

	            it { should have_title("Frontline team") }
	            it { should have_selector('span.contact') }
	            it { should_not have_selector('span.mobile') }
	        end

	 	end
	end

	describe "for other signed-in team members" do

		let!(:member)	{ FactoryGirl.create(:ownership, 
								business: founder_biz, user: administrator,
								email_address: administrator.email, created_by: founder.id) }
		let!(:other_biz)	{ FactoryGirl.create(:business, created_by: founder.id) }
		let(:ownership_other) { other_biz.ownerships.find_by(user_id: founder.id) }
		let(:team_player)	{ FactoryGirl.create(:user) }

		before { sign_in administrator }

		describe "has access to the member business pages and actions" do

			describe "Index" do

				before { visit my_business_ownerships_path(founder_biz) }

				it { should have_title("Frontline team") }
	           	it { should have_selector('h2', text: "for #{founder_biz.name}, #{founder_biz.city}")}
	            it { should have_selector('li', text: founder.name) }
	            it { should have_selector('li', text: administrator.name) }
	            it { should have_button('remove') }
			
	            it "can delete a team member" do
	            	sign_in administrator, no_capybara: true
	            	expect do
 	          			delete ownership_path(ownership_1)
 	          			flash[:success].should eq "Removed #{ownership_1.user.name} from the team." 
 	        		end.to change(Ownership, :count).by(-1)
	            end
			end

			describe "Go to the New page" do

				before { visit new_my_business_ownership_path(founder_biz) }

				it { should have_title("New team member") }
	         	it { should have_selector('h2', text: "for #{founder_biz.name}, #{founder_biz.city}") }

	         	describe "and create a new team member" do

	         		before do
		                fill_in "The team member's email address",  with: team_player.email
		            end

		            it "creates a new Ownership record" do
		               	expect do
		               	 click_button "Create"
		               	end.to change(founder_biz.ownerships, :count).by(1)

		               	@ownership = Ownership.last
		               	@ownership.created_by.should eq administrator.id
		            end
	         	end
	        end

	        describe "Go to the Edit page" do

	        	before { visit edit_ownership_path(ownership_1) }

	        	it { should have_title('Team member update') }
	        	it { should have_selector('h2', text: "#{founder_biz.name}, #{founder_biz.city}") }
	        
	        	describe "successfully edit the member details" do
	        	
	        		let(:ext_phone) { "1234-567 ext 215" }
	        		before do
		         		choose "Yes"
		                fill_in "direct phone number", with: ext_phone
		                click_button "Confirm"
		            end

		            it { should have_title("Frontline team") }
		            it { should have_selector('h2', text: "for #{founder_biz.name}, #{founder_biz.city}") }
		            specify { expect(ownership_1.reload.phone).to eq ext_phone }
	        	end
	        end
		end

		describe "does not have access to non-member business pages and actions" do

			describe "attempt to visit Index" do
				
				before { visit my_business_ownerships_path(other_biz) }

	           	it { should_not have_selector('h2', text: "for #{founder_biz.name}, #{founder_biz.city}")}
	            it { should have_title(administrator.name) }
	            it { should have_content("The page you requested doesn't belong to you!") }
			
	            it "cannot delete an Ownership" do
	            	sign_in administrator, no_capybara: true
	            	expect do
 	          			delete ownership_path(ownership_other)
 	          			flash[:error].should eq "Action not permitted!" 
 	        		end.not_to change(Ownership, :count)
	            end
			end

			describe "Attempt to visit New page" do

				before { visit new_my_business_ownership_path(other_biz) }

				it { should_not have_title("New team member") }
	         	it { should have_title(administrator.name) }
	            it { should have_content("The page you requested doesn't belong to you!") }
	        end

	        describe "Attempt to visit Edit page" do

	        	before { visit edit_ownership_path(ownership_other) }

				it { should_not have_title("Team member update") }
	         	it { should have_title(administrator.name) }
	            it { should have_content("The page you requested doesn't belong to you!") }
	        end

	        describe "attempting to change Ownership data directly" do

	        	before { sign_in administrator, no_capybara: true }
	        	
	        	describe "Create" do

	        		let(:params) do
                 		{ ownership: { email_address: team_player.email,
                						created_by: administrator.id } }
               		end
              
               		it "should not create a new team member" do
                 		expect do
                   			post my_business_ownerships_path(other_biz, params)
                		end.not_to change(Ownership, :count)
               		end

               		describe "should redirect to User Home" do

                 		before { post my_business_ownerships_path(other_biz, params) }
                 		
                 		specify do
							expect(response).to redirect_to(user_path(administrator))
			    			expect(flash[:error]).to eq("Action not permitted!")
			    		end
               		end
             	end

             	describe "Update" do

               		let(:new_phone)  { "909090"}
               		let(:params) do
                		{ ownership: { phone: new_phone } }
               		end
              
               		describe "should not modify the existing team member" do
                
                 		before { patch ownership_path(ownership_other, params) } 
                 		specify { expect(ownership_other.reload.phone).not_to eq new_phone }
               		end

               		describe "should redirect to User Home" do

                 		before { patch ownership_path(ownership_other, params) }
                 		
                 		specify do
							expect(response).to redirect_to(user_path(administrator))
			    			expect(flash[:error]).to eq("Action not permitted!")
			    		end
               		end
             	end
	        end
		end

	end

	describe "for non-authorized business owners" do

		let!(:ownership_2) { FactoryGirl.create(:ownership, 
						business: founder_biz,
						user: administrator,
						email_address: administrator.email,
						created_by: founder.id) }       
			#2nd team member added. 2 owners allows delete tests to work properly.

  		describe "who are non-signed-in users" do

  	 		describe "Index" do
				
	 			describe "redirect to the signin page" do
				
	 				before { get my_business_ownerships_path(founder_biz) }
	 				inaccessible_without_signin
	 			end

	 			describe "go to correct Index page after signing in" do

	 				before do
	 					visit my_business_ownerships_path(founder_biz)
	 					valid_signin(founder)
	 				end
					
	 				specify do
	 					expect(page).to have_title("Frontline team")
             			expect(page).to have_selector('h2', text: "for #{founder_biz.name}, #{founder_biz.city}")
	 				end

	 				describe "but don't go to this index page when signing in the next time" do

	 					before do
	 						click_link "Sign out"
	 						sign_in founder
	 					end	

	 					specify { expect(page).not_to have_title('Frontline team') }
	 				end
	 			end
	 		end

			describe "Edit" do

				before { get edit_ownership_path(ownership_1) }
				inaccessible_without_signin

				describe "go to correct Edit page after signing in" do

					before do
						visit edit_ownership_path(ownership_1)
						valid_signin(founder)
					end
					
					specify { expect(page).to have_title("Team member update") }
		

					describe "but don't go to this Edit page when signing in the next time" do

						before do
							click_link "Sign out"
							sign_in founder
						end	

						specify { expect(page).not_to have_title("Team member update") }
					end
				end
			end

	 		describe "New" do

	 			before { get new_my_business_ownership_path(founder_biz) }
	 			inaccessible_without_signin

	 			describe "go to correct New page after signing in" do

	 				before do
	 					visit new_my_business_ownership_path(founder_biz)
	 					valid_signin(founder)
	 				end
					
	 				specify do
	 					expect(page).to have_title('New team member')
	 					expect(page).to have_selector("input#ownership_created_by[value=\"#{founder.id}\"]")
	 					# NOTE: Capybara set to handle hidden fields in spec_helper
	 				end

					describe "but don't go to this New page when signing in the next time" do

	 					before do
	 						click_link "Sign out"
	 						sign_in founder
	 					end	

	 					specify { expect(page).not_to have_title('New team member') }
	 				end
	 			end
	 		end

	 		describe "attempting to manipulate the Ownership data" do
	             
             	describe "Create" do

               		let(:params) do
                 		{ ownership: { email_address: administrator.email,
                						created_by: founder.id } }
               		end
              
               		it "should not create a new team member" do
                 		expect do
                   			post my_business_ownerships_path(founder_biz, params)
                		end.not_to change(Ownership, :count)
               		end

               		describe "should redirect to root" do

                 		before { post my_business_ownerships_path(founder_biz, params) }
                 		forbidden_without_signin
               		end
             	end

             	describe "Update" do

               		let(:new_phone)  { "909090"}
               		let(:params) do
                		{ ownership: { phone: new_phone } }
               		end
              
               		describe "should not modify the existing team member" do
                
                 		before { patch ownership_path(ownership_1, params) } 
                 		specify { expect(ownership_1.reload.phone).not_to eq new_phone }
               		end

               		describe "should redirect to root" do

                 		before { patch ownership_path(ownership_1, params) }
                 		forbidden_without_signin
               		end
             	end

             	describe "Destroy" do

               		it "should not delete the existing ownership" do
                 		expect do
                   			delete ownership_path(ownership_1)
                 		end.not_to change(Ownership, :count)
               		end

               		describe "should redirect to root" do

                 		before { delete ownership_path(ownership_1) }
                 		forbidden_without_signin
                 	end
               	end
           	end
  	 	end

  	 	describe "who are signed in users but not frontline team in this business" do

  	 		let(:non_team_member) { FactoryGirl.create(:user) }
  	 		before { sign_in non_team_member, no_capybara: true }

  	 		describe "Index page" do
				
				before { get my_business_ownerships_path(founder_biz) }
				specify do
					expect(response).to redirect_to(user_path(non_team_member))
			    	expect(flash[:error]).to eq("The page you requested doesn't belong to you!")
			    end
			end

			describe "New page" do

				before { get new_my_business_ownership_path(founder_biz) }
				specify do
					expect(response).to redirect_to(user_path(non_team_member))
			    	expect(flash[:error]).to eq("The page you requested doesn't belong to you!")
			    end
			end

			describe "Edit page" do

				before { get edit_ownership_path(ownership_1.id) }
				specify do
					expect(response).to redirect_to(user_path(non_team_member))
			    	expect(flash[:error]).to eq("The page you requested doesn't belong to you!")
			    end
			end
  		
  			describe "attempting to modify Ownership data" do

  				describe "Create" do

    				let(:params) do
                 		{ ownership: { email_address: non_team_member.email,
                 						created_by: non_team_member.id } }
               		end
              
               		it "should not create a new team member" do
                 		expect do
                   			post my_business_ownerships_path(founder_biz), params
                		end.not_to change(Ownership, :count)
               		end

               		describe "redirects to user home page" do

                 		before { post my_business_ownerships_path(founder_biz), params }
                 		
                 		specify do
							expect(response).to redirect_to(user_path(non_team_member))
			    			expect(flash[:error]).to eq("Action not permitted!")
			    		end
               		end
             	end

             	describe "Update" do

	           		let(:new_phone)  { "909090"}
               		let(:params) do
                		{ ownership: { phone: new_phone } }
               		end
              
               		describe "should not modify the existing team member" do
                
                 		before { patch ownership_path(ownership_1, params) } 
                 		specify { expect(ownership_1.reload.phone).not_to eq new_phone }
               		end

               		describe "should redirect to root" do

                 		before { patch ownership_path(ownership_1, params) }
                 		
                 		specify do
                 			expect(response).to redirect_to(user_path(non_team_member))
			    			expect(flash[:error]).to eq("Action not permitted!")
			    		end
               		end             		
             	end

             	describe "Destroy" do

             		it "should not delete the existing Ownership" do
                		expect do
                  			delete ownership_path(ownership_1)
                		end.not_to change(Ownership, :count)
              		end

              		describe "redirects to User home" do

                		before { delete ownership_path(ownership_1) }
                		
                		specify do
                 			expect(response).to redirect_to(user_path(non_team_member))
			    			expect(flash[:error]).to eq("Action not permitted!")
			    		end
                	end
             	end
  			end
  		end
  	end

  	describe "for HROOMPH admins" do
  		pending "dealt with in a separate controller"
  	end
end
