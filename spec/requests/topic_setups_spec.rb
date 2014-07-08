require 'spec_helper'

describe "TopicSetups" do

	subject { page }

  	describe "signed in as Admin" do   
  
  		let(:admin) { FactoryGirl.create(:admin) }
  		before {sign_in admin }

  		describe "working with Genres" do

        	describe "index" do

	          	let!(:genre_1) 	{ FactoryGirl.create(:genre, status: 1) }
	          	let!(:genre_2)	{ FactoryGirl.create(:genre, description: "Not approved") }
	          	let!(:genre_3)	{ FactoryGirl.create(:genre, description: "Rejected", status: 3) }
	          	let!(:category_1)	{ FactoryGirl.create(:category, status: 1, genre: genre_1) }

	          	before { visit genres_path }

	            it { should have_title('Genres') }
	            it { should have_content('Genres') }
	            it { should have_content('To help users find the training they want easily')}
	            it { should have_link("Framework menu", href: framework_path) }
	            it { should have_selector('li', text: genre_1.description) }
	            it { should_not have_selector('li', text: genre_2.description) }
	            it { should_not have_selector('li', text: genre_3.description) }
	            it { should have_link('1 category ->', genre_categories_path(genre_1)) }
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
		              	it { should have_link('0 categories ->', genre_categories_path(Genre.last)) }
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

		            describe "unsuccessfully" do

		            	before do
		                	fill_in "Description",    with: "  "
		                	click_button "Confirm"
		              	end

		              	it { should have_title('Edit genre')}
		              	it { should have_content('error') }
		              	specify { expect(changed_genre.reload.description).to eq old_description }

		            end
		        end
		    end
        end

        describe "working with Categories" do

        	let!(:genre_1) 	{ FactoryGirl.create(:genre, status: 1) }

        	describe "Index" do
        		
        		let!(:approved_category) {FactoryGirl.create(:category, genre: genre_1, status: 1) }
				let!(:unapproved_category) {FactoryGirl.create(:category, genre: genre_1, status: 2) }
				let!(:rejected_category) {FactoryGirl.create(:category, genre: genre_1, status: 3) }

				before { visit genre_categories_path(genre_1) }

	            it { should have_title("Categories: #{genre_1.description}") }
	            it { should have_content("Categories") }
	            it { should have_selector('h2', text: "for the '#{genre_1.description}' genre")}
	            it { should have_link("<- All genres", href: genres_path) }
	            it { should have_selector('li', text: approved_category.description) }
	            it { should_not have_selector('li', text: unapproved_category.description) }
	            it { should_not have_selector('li', text: rejected_category.description) }
	            it { should have_link("0 topics ->", href: category_topics_url(approved_category)) }
	            it { should have_link('edit', href: edit_category_path(approved_category)) }
	            it { should have_link('delete', href: category_path(approved_category)) }
	            it { should have_link('Add a category', href: new_genre_category_path(genre_1)) }
		        
		        pending "No delete link when the category has been used by providers."
		        pending "Include link to Categories awaiting approval."

		        it "should be able to delete a category" do
		            expect do
		              click_link('delete', href: category_path(approved_category))
		            end.to change(genre_1.categories, :count).by(-1)
		            expect(page).to have_title("Categories: #{genre_1.description}")
		            expect(page).not_to have_selector('li', text: approved_category.description)
		        end
        	end

        	describe "visit the New page" do

		        before { visit new_genre_category_path(genre_1) }

		        it { should have_title("#{genre_1.description}: new category") }
		        it { should have_content("New category") }
		        it { should have_selector('h2', text: "for the '#{genre_1.description}' genre")}
		        it { should_not have_field("Status") }
		        it { should have_link("<- All categories for '#{genre_1.description}'", 
		        							href: genre_categories_path(genre_1)) }

		        describe "then create a new approved Category successfully" do
		            before do
		               	fill_in "Description",    with: "New Category"
		            end

		            it "should create a Category" do
		              	expect { click_button "Create" }.to change(genre_1.categories, :count).by(1) 
		            end

		            describe "and redirect to the Category index for this Genre" do
		              	before { click_button 'Create' }

		              	it { should have_title("Categories: #{genre_1.description}") }
		              	it { should have_selector('li', text: 'New Category') }   #because approved
		              	it { }
		              	it { should have_selector('div.alert.alert-success', 
		              		     text: "'New Category' added to the '#{genre_1.description}' genre") } 
		            end
		        end

		        describe "then fail to create a new Category successfully" do
		            
		            it "should not create a Category" do    #no parameters
		              	expect { click_button 'Create' }.not_to change(genre_1.categories, :count)
		            end

		            describe "continue to show the New page with an error message" do

		              	before do
		                	fill_in "Description",    with: "   "
		                	click_button "Create"
		              	end
		            
		              	it { should have_title("#{genre_1.description}: new category") }
		              	it { should have_content('error') }
		            end
		        end
		    end

		    describe "visit the Edit page" do

		        let!(:changed_category) { FactoryGirl.create(:category, genre: genre_1, status: 1) }
		        before do
		           	visit edit_category_path(changed_category) 
		        end

	          	it { should have_title("#{genre_1.description}: edit category") }
	          	it { should have_content('Edit category') }
	          	it { should have_selector('h2', text: "for the '#{genre_1.description}' genre")}
	          	it { should_not have_field('Approved') }
	          	it { should have_link('<- Cancel', href: genre_categories_path(genre_1)) }

		        describe "and update the Category" do

		            let(:old_description) { changed_category.description }
		            describe "succesfully" do

		              	let(:new_description)   { "Updated description" }
		              	before do
		                	fill_in "Description",    with: new_description
		                	click_button "Confirm"
		              	end

		              	it { should have_title("Categories: #{genre_1.description}") }
		              	it { should have_selector('div.alert.alert-success', text: "Updated to '#{new_description}'") }
		              	specify { expect(changed_category.reload.description).to eq new_description }
		            end

		            describe "unsuccessfully" do

		            	before do
		                	fill_in "Description",    with: "  "
		                	click_button "Confirm"
		              	end

		              	it { should have_title("#{genre_1.description}: edit category")}
		              	it { should have_content('error') }
		              	specify { expect(changed_category.reload.description).to eq old_description }
		            end
		        end
		    end
        end

        describe "working with Topics" do

        	let!(:genre_1) 		{ FactoryGirl.create(:genre, status: 1) }
        	let!(:category_1) 	{ FactoryGirl.create(:category, status: 1, genre: genre_1) }

        	describe "Index" do
        		
        		let!(:approved_topic) {FactoryGirl.create(:topic, category: category_1, status: 1) }
				let!(:unapproved_topic) {FactoryGirl.create(:topic, category: category_1, status: 2) }
				let!(:rejected_topic) {FactoryGirl.create(:topic, category: category_1, status: 3) }

				before { visit category_topics_path(category_1) }

	            it { should have_title("Topics: #{category_1.description}") }
	            it { should have_content("Topics") }
	            it { should have_selector('h2', 
	            	text: "for the '#{category_1.description}' category (#{genre_1.description} genre)")}
	            it { should have_link("<- All categories", href: genre_categories_path(genre_1)) }
	            it { should have_selector('li', text: approved_topic.description) }
	            it { should_not have_selector('li', text: unapproved_topic.description) }
	            it { should_not have_selector('li', text: rejected_topic.description) }
	            it { should have_link('edit', href: edit_topic_path(approved_topic)) }
	            it { should have_link('delete', href: topic_path(approved_topic)) }
	            it { should have_link('Add a topic', href: new_category_topic_path(category_1)) }
		        
		        pending "No delete link when the topic has been used by providers."
		        pending "Include link to Topics awaiting approval."

		        it "should be able to delete a topic" do
		            expect do
		              click_link('delete', href: topic_path(approved_topic))
		            end.to change(category_1.topics, :count).by(-1)
		            expect(page).to have_title("Topics: #{category_1.description}")
		            expect(page).not_to have_selector('li', text: approved_topic.description)
		        end
        	end

        	describe "visit the New page" do

		        before { visit new_category_topic_path(category_1) }

		        it { should have_title("#{category_1.description}: new topic") }
		        it { should have_content("New topic") }
		        it { should have_selector('h2', 
		        	 text: "for the '#{category_1.description}' category (#{genre_1.description} genre)")}
		        it { should_not have_field("Status") }
		        it { should have_link("<- All topics for '#{category_1.description}'", 
		        							href: category_topics_path(category_1)) }

		        describe "then create a new approved Topic successfully" do
		            before do
		               	fill_in "Description",    with: "New Topic"
		            end

		            it "should create a Category" do
		              	expect { click_button "Create" }.to change(category_1.topics, :count).by(1) 
		            end

		            describe "and redirect to the Topic index for this Category" do
		              	before { click_button 'Create' }

		              	it { should have_title("Topics: #{category_1.description}") }
		              	it { should have_selector('li', text: 'New Topic') }   #because approved
		              	it { should have_selector('div.alert.alert-success', 
		              		     text: "'New Topic' added to the '#{category_1.description}' category") } 
		            
		              	describe "then updating (and pluralizing) the Topics count on the Category index" do

		              		before { visit genre_categories_path(genre_1) }
		              		it { should have_link("1 topic ->", href: category_topics_url(category_1)) }
		              	end
		            end
		        end

		        describe "then fail to create a new Topic successfully" do
		            
		            it "should not create a Topic" do    #no parameters
		              	expect { click_button 'Create' }.not_to change(category_1.topics, :count)
		            end

		            describe "continue to show the New page with an error message" do

		              	before do
		                	fill_in "Description",    with: "   "
		                	click_button "Create"
		              	end
		            
		              	it { should have_title("#{category_1.description}: new topic") }
		              	it { should have_content('error') }
		            end
		        end
		    end

		    describe "visit the Edit page" do

		        let!(:changed_topic) { FactoryGirl.create(:topic, category: category_1, status: 1) }
		        before do
		           	visit edit_topic_path(changed_topic) 
		        end

	          	it { should have_title("#{category_1.description}: edit topic") }
	          	it { should have_content('Edit topic') }
	          	it { should have_selector('h2', 
	          		text: "for the '#{category_1.description}' category (#{genre_1.description} genre)")}
	          	it { should_not have_field('Approved') }
	          	it { should have_link('<- Cancel', href: category_topics_path(category_1)) }

		        describe "and update the Topic" do

		            let(:old_description) { changed_topic.description }
		            describe "succesfully" do

		              	let(:new_description)   { "Updated description" }
		              	before do
		                	fill_in "Description",    with: new_description
		                	click_button "Confirm"
		              	end

		              	it { should have_title("Topics: #{category_1.description}") }
		              	it { should have_selector('div.alert.alert-success', 
		              		text: "Updated to '#{new_description}'") }
		              	specify { expect(changed_topic.reload.description).to eq new_description }
		            end

		            describe "unsuccessfully" do

		            	before do
		                	fill_in "Description",    with: "  "
		                	click_button "Confirm"
		              	end

		              	it { should have_title("#{category_1.description}: edit topic")}
		              	it { should have_content('error') }
		              	specify { expect(changed_topic.reload.description).to eq old_description }
		            end
		        end
		    end
        end
  	end

  	describe "deny access to non-admin users" do

  		let!(:existing_genre) { FactoryGirl.create(:genre, status: 1) }
  		let!(:existing_category) { FactoryGirl.create(:category, genre: existing_genre, status: 1) }
  		
  		describe "when not signed in" do

  			describe "in the Genre controller" do

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

	        describe "in the Categories controller"	do

	        	before { @genre_title = existing_genre.description }

	          	describe "GET requests" do

	            	describe "Index" do
	              		@title = "Categories: #{@genre_title}" 
	              		before { get genre_categories_path(existing_genre) }
	              		non_admin_illegal_get(@title)
	            	end

	            	describe "Edit" do
	              		@title = "#{@genre_title}: edit category"
	              		before { get edit_category_path(existing_category) }
	              		non_admin_illegal_get(@title)
	            	end

	            	describe "New" do
	              		@title = "#{@genre_title}: new category"
	              		before { get new_genre_category_path(existing_genre) }
	              		non_admin_illegal_get(@title)
	            	end
	          	end

	          	describe "attempting to manipulate the Category data" do
	            
	            	describe "Create" do

	              		let(:params) do
	                		{ category: { genre: existing_genre, description: "New category", status: 1 } }
	              		end
	              
	              		it "should not create a new category" do
	                		expect do
	                  			post genre_categories_path(existing_genre, params)
	                		end.not_to change(Category, :count)
	              		end

	              		describe "should redirect to root" do

	                		before { post genre_categories_path(existing_genre, params) }
	                		not_administrator
	              		end
	            	end

	            	describe "Update" do

	              		let(:new_category)  { "Changed description"}
	              		let(:params) do
	                		{ category: { description: new_category } }
	              		end
	              
	              		describe "should not modify the existing category" do
	                
	                		before { patch category_path(existing_category), params } 
	                		specify { expect(existing_category.reload.description).not_to eq new_category }
	              		end

	              		describe "should redirect to root" do

	                		before { patch category_path(existing_category), params }
	                		not_administrator
	              		end
	            	end

	            	describe "Destroy" do

	              		it "should not delete the existing Category" do
	                		expect do
	                  			delete category_path(existing_category)
	                		end.not_to change(Category, :count)
	              		end

	              		describe "should redirect to root" do

	                		before { delete category_path(existing_category) }
	                		not_administrator
	                	end
	              	end
	          	end
	        end

	        describe "in the Topics controller" do

	        	let!(:existing_topic) { FactoryGirl.create(:topic, category: existing_category, status: 1) }
	        	before { @category_title = existing_category.description }

	          	describe "GET requests" do

	            	describe "Index" do
	              		@title = "Topics: #{@category_title}" 
	              		before { get category_topics_path(existing_category) }
	              		non_admin_illegal_get(@title)
	            	end

	            	describe "Edit" do
	              		@title = "#{@category_title}: edit topic"
	              		before { get edit_topic_path(existing_topic) }
	              		non_admin_illegal_get(@title)
	            	end

	            	describe "New" do
	              		@title = "#{@category_title}: new topic"
	              		before { get new_category_topic_path(existing_category) }
	              		non_admin_illegal_get(@title)
	            	end
	          	end

	          	describe "attempting to manipulate the Topic data" do
	            
	            	describe "Create" do

	              		let(:params) do
	                		{ topic: { category: existing_category, description: "New topic", status: 1 } }
	              		end
	              
	              		it "should not create a new topic" do
	                		expect do
	                  			post category_topics_path(existing_category, params)
	                		end.not_to change(Topic, :count)
	              		end

	              		describe "should redirect to root" do

	                		before { post category_topics_path(existing_category, params) }
	                		not_administrator
	              		end
	            	end

	            	describe "Update" do

	              		let(:new_topic)  { "Changed description"}
	              		let(:params) do
	                		{ topic: { description: new_topic } }
	              		end
	              
	              		describe "should not modify the existing topic" do
	                
	                		before { patch topic_path(existing_topic), params } 
	                		specify { expect(existing_topic.reload.description).not_to eq new_topic }
	              		end

	              		describe "should redirect to root" do

	                		before { patch topic_path(existing_topic), params }
	                		not_administrator
	              		end
	            	end

	            	describe "Destroy" do

	              		it "should not delete the existing Topic" do
	                		expect do
	                  			delete topic_path(existing_topic)
	                		end.not_to change(Topic, :count)
	              		end

	              		describe "should redirect to root" do

	                		before { delete topic_path(existing_topic) }
	                		not_administrator
	                	end
	              	end
	          	end
	        end
  		end

  		describe "when signed in as non-admin" do

  			let(:user) { FactoryGirl.create(:user) }
  			before { sign_in user, no_capybara: true }

  			describe "in the Genre controller" do

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

	        describe "in the Categories controller"	do

	        	let!(:existing_category) { FactoryGirl.create(:category, genre: existing_genre, status: 1) }
	        	before { @genre_title = existing_genre.description }

	          	describe "GET requests" do

	            	describe "Index" do
	              		@title = "Categories: #{@genre_title}"    #set_genre.description}"
	              		before { get genre_categories_path(existing_genre) }
	              		non_admin_illegal_get(@title)
	            	end

	            	describe "Edit" do
	              		@title = "#{@genre_title}: edit category"
	              		before { get edit_category_path(existing_category) }
	              		non_admin_illegal_get(@title)
	            	end

	            	describe "New" do
	              		@title = "#{@genre_title}: new category"
	              		before { get new_genre_category_path(existing_genre) }
	              		non_admin_illegal_get(@title)
	            	end
	          	end

	          	describe "attempting to manipulate the Category data" do
	            
	            	describe "Create" do

	              		let(:params) do
	                		{ category: { genre: existing_genre, description: "New category", status: 1 } }
	              		end
	              
	              		it "should not create a new category" do
	                		expect do
	                  			post genre_categories_path(existing_genre, params)
	                		end.not_to change(Category, :count)
	              		end

	              		describe "should redirect to root" do

	                		before { post genre_categories_path(existing_genre, params) }
	                		not_administrator
	              		end
	            	end

	            	describe "Update" do

	              		let(:new_category)  { "Changed description"}
	              		let(:params) do
	                		{ category: { description: new_category } }
	              		end
	              
	              		describe "should not modify the existing category" do
	                
	                		before { patch category_path(existing_category), params } 
	                		specify { expect(existing_category.reload.description).not_to eq new_category }
	              		end

	              		describe "should redirect to root" do

	                		before { patch category_path(existing_category), params }
	                		not_administrator
	              		end
	            	end

	            	describe "Destroy" do

	              		it "should not delete the existing Category" do
	                		expect do
	                  			delete category_path(existing_category)
	                		end.not_to change(Category, :count)
	              		end

	              		describe "should redirect to root" do

	                		before { delete category_path(existing_category) }
	                		not_administrator
	                	end
	              	end
	          	end
	        end

	        describe "in the Topics controller" do

	        	let!(:existing_topic) { FactoryGirl.create(:topic, category: existing_category, status: 1) }
	        	before { @category_title = existing_category.description }

	          	describe "GET requests" do

	            	describe "Index" do
	              		@title = "Topics: #{@category_title}" 
	              		before { get category_topics_path(existing_category) }
	              		non_admin_illegal_get(@title)
	            	end

	            	describe "Edit" do
	              		@title = "#{@category_title}: edit topic"
	              		before { get edit_topic_path(existing_topic) }
	              		non_admin_illegal_get(@title)
	            	end

	            	describe "New" do
	              		@title = "#{@category_title}: new topic"
	              		before { get new_category_topic_path(existing_category) }
	              		non_admin_illegal_get(@title)
	            	end
	          	end

	          	describe "attempting to manipulate the Topic data" do
	            
	            	describe "Create" do

	              		let(:params) do
	                		{ topic: { category: existing_category, description: "New topic", status: 1 } }
	              		end
	              
	              		it "should not create a new topic" do
	                		expect do
	                  			post category_topics_path(existing_category, params)
	                		end.not_to change(Topic, :count)
	              		end

	              		describe "should redirect to root" do

	                		before { post category_topics_path(existing_category, params) }
	                		not_administrator
	              		end
	            	end

	            	describe "Update" do

	              		let(:new_topic)  { "Changed description"}
	              		let(:params) do
	                		{ topic: { description: new_topic } }
	              		end
	              
	              		describe "should not modify the existing topic" do
	                
	                		before { patch topic_path(existing_topic), params } 
	                		specify { expect(existing_topic.reload.description).not_to eq new_topic }
	              		end

	              		describe "should redirect to root" do

	                		before { patch topic_path(existing_topic), params }
	                		not_administrator
	              		end
	            	end

	            	describe "Destroy" do

	              		it "should not delete the existing Topic" do
	                		expect do
	                  			delete topic_path(existing_topic)
	                		end.not_to change(Topic, :count)
	              		end

	              		describe "should redirect to root" do

	                		before { delete topic_path(existing_topic) }
	                		not_administrator
	                	end
	              	end
	          	end
	        end
  		end
  	end
end
