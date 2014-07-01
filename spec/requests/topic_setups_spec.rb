require 'spec_helper'

describe "TopicSetups" do

	subject { page }

  	describe "signed in as Admin" do   
  
  		let(:admin) { FactoryGirl.create(:admin) }
  		before {sign_in admin }

  		describe "working with Genres" do

        	describe "index" do
          
	          	let!(:genre_1) 	{ FactoryGirl.create(:genre, status: 1) }
	          	let!(:genre_2)	{ FactoryGirl.create(:genre, description: "Not approved")}
	          	let!(:genre_3)	{ FactoryGirl.create(:genre, description: "Rejected", status: 3)}
	          	before do
	           		visit genres_path 
	        	end

	            it { should have_title('Genres') }
	            it { should have_content('Genres') }
	            it { should have_content('To help users find the training they want easily')}
	            it { should have_link("Framework menu", href: framework_path) }
	            it { should have_selector('li', text: genre_1.description) }
	            it { should_not have_selector('li', text: genre_2.description) }
	            it { should_not have_selector('li', text: genre_3.description) }
	            it { should have_link('0 categories', '#')}
	            it { should have_link('edit', href: edit_genre_path(genre_1)) }
	            it { should have_link('delete', href: genre_path(genre_1)) }
	            it { should have_link('Add a genre', href: new_genre_path) }
		        
		        pending "No test for sortable list yet."
		        pending "No delete link when the genre has categories."
		        pending "Include link to Genres awaiting approval."

		        it "should be able to delete a genre" do
		            expect do
		              click_link('delete', href: genre_path(genre_1))
		            end.to change(Genre, :count).by(-1)
		            expect(page).to have_title('Genres')
		            expect(page).not_to have_selector('li', text: genre_1.description)
		        end
		    end

		    describe "visit the New page" do

		        before { visit new_genre_path }

		        it { should have_title("New genre") }
		        it { should have_content("New genre") }
		        it { should_not have_field("Status") }
		        it { should have_link("<- All genres", href: genres_path) }

		        describe "then create a new approved Genre successfully" do
		            before do
		               	fill_in "Description",    with: "Leisure"
		            end

		            it "should create a Genre" do
		              	expect { click_button "Create" }.to change(Genre, :count).by(1) 
		            end

		            describe "and redirect to the Genre index" do
		              	before { click_button 'Create' }

		              	it { should have_title('Genres') }
		              	it { should have_selector('li', text: 'Leisure') }   #because approved
		              	it { should have_selector('div.alert.alert-success', text: "'Leisure' added") } 
		            end
		        end

		        describe "then fail to create a new Genre successfully" do
		            
		            it "should not create a Genre" do    #no parameters
		              	expect { click_button 'Create' }.not_to change(Genre, :count)
		            end

		            describe "continue to show the New page with an error message" do

		              	before do
		                	fill_in "Description",    with: "   "
		                	click_button "Create"
		              	end
		            
		              	it { should have_title('New genre') }
		              	it { should have_content('error') }
		            end
		        end
		    end

		    describe "visit the Edit page" do

		        let!(:changed_genre) { FactoryGirl.create(:genre, status: 1) }
		        before do
		           	visit edit_genre_path(changed_genre) 
		        end

	          	it { should have_title('Edit genre') }
	          	it { should have_content('Edit genre') }
	          	it { should_not have_field('Approved') }
	          	it { should have_link('<- Cancel', href: genres_path) }

		        describe "and update the Genre" do

		            let(:old_description) { changed_genre.description }
		            describe "succesfully" do

		              	let(:new_description)   { "Updated description" }
		              	before do
		                	fill_in "Description",    with: new_description
		                	click_button "Confirm"
		              	end

		              	it { should have_title('Genres')}
		              	it { should have_selector('div.alert.alert-success', text: "Updated to '#{new_description}'") }
		              	specify { expect(changed_genre.reload.description).to eq new_description }
		            end
		        end
		    end
        end
  	end

  	describe "deny access to non-admin users" do

  		describe "when not signed in" do

  			describe "in the Genre controller" do

          		let!(:existing_genre) { FactoryGirl.create(:genre, status: 1) }

	          	describe "GET requests" do

	            	describe "Index" do
	              		@title = "Genres"
	              		before { get genres_path }
	              		non_admin_illegal_get(@title)
	            	end

	            	describe "Edit" do
	              		@title = "Edit genre"
	              		before { get edit_genre_path(existing_genre) }
	              		non_admin_illegal_get(@title)
	            	end

	            	describe "New" do
	              		@title = "New genre"
	              		before { get new_genre_path }
	              		non_admin_illegal_get(@title)
	            	end
	          	end

	          	describe "attempting to manipulate the Genre data" do
	            
	            	describe "Create" do

	              		let(:params) do
	                		{ genre: { description: "New genre", status: 1 } }
	              		end
	              
	              		it "should not create a new genre" do
	                		expect do
	                  			post genres_path(params)
	                		end.not_to change(Genre, :count)
	              		end

	              		describe "should redirect to root" do

	                		before { post genres_path(params) }
	                		not_administrator
	              		end
	            	end

	            	describe "Update" do

	              		let(:new_genre)  { "Changed description"}
	              		let(:params) do
	                		{ genre: { description: new_genre } }
	              		end
	              
	              		describe "should not modify the existing genre" do
	                
	                		before { patch genre_path(existing_genre), params } 
	                		specify { expect(existing_genre.reload.description).not_to eq new_genre }
	              		end

	              		describe "should redirect to root" do

	                		before { patch genre_path(existing_genre), params }
	                		not_administrator
	              		end
	            	end

	            	describe "Destroy" do

	              		it "should not delete the existing Genre" do
	                		expect do
	                  			delete genre_path(existing_genre)
	                		end.not_to change(Genre, :count)
	              		end

	              		describe "should redirect to root" do

	                		before { delete genre_path(existing_genre) }
	                		not_administrator
	                	end
	              	end
	          	end
	        end	
  		end
  	end

end
