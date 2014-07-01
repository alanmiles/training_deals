require 'spec_helper'

describe "AdminPages" do 
  
  	subject { page }

  	describe "signed in as Admin" do 
  
  		let(:admin) { FactoryGirl.create(:admin) }
  		before {sign_in admin }

  		describe "accessing the Framework menu" do

  			before { click_link "Framework" }

	  		it { should have_selector('h1', text: "Framework menu") }
	    	it { should have_title(full_title("Framework menu")) }
	    	it { should have_link('Training methods', href: training_methods_path) }
	    	it { should have_link('Time periods', href: durations_path) }
        it { should have_link('Content lengths', href: content_lengths_path) }
        it { should have_link('Genres / categories / topics', href: genres_path) }
        it { should have_link('Return to main admin menu', href: root_path) }
  		end

      describe "working with TrainingMethods" do

        describe "viewing the Methods list" do
          
          let!(:method_1) { FactoryGirl.create(:training_method) }
          before do
           visit training_methods_path 
          end

          it { should have_title('Training methods') }
          it { should have_content('Training methods') }
          it { should have_link("Framework menu", href: framework_path) }
          it { should have_selector('li', text: method_1.description) }
          it { should have_link('edit', href: edit_training_method_path(method_1)) }
          it { should have_link('delete', href: training_method_path(method_1)) }
          it { should have_link('Add a method', href: new_training_method_path) }
        
          pending "No test for sortable list yet."
          pending "No delete link when the Method is in use."

          it "should be able to delete a method" do

            expect do
              click_link('delete', href: training_method_path(method_1))
            end.to change(TrainingMethod, :count).by(-1)
            expect(page).to have_title('Training methods')
            expect(page).not_to have_selector('li', text: method_1.description)
          end
        end

        describe "visit the New page" do

          before { visit new_training_method_path }

          it { should have_title("New training method") }
          it { should have_content("New training method") }
          it { should have_link("<- All methods", href: training_methods_path) }

          describe "then create a new Method successfully" do
            before do
              fill_in "Description",    with: "Audio-visual"
            end

            it "should create a Method" do
              expect { click_button "Create" }.to change(TrainingMethod, :count).by(1) 
            end

            describe "and redirect to the TrainingMethod index" do
              before { click_button 'Create' }

              it { should have_title('Training methods') }
              it { should have_selector('li', text: 'Audio-visual') }
              it { should have_selector('div.alert.alert-success', text: "'Audio-visual' added") } 
            end
          end

          describe "then fail to create a new Method successfully" do
            
            it "should not create a Method" do
              expect { click_button 'Create' }.not_to change(TrainingMethod, :count)
            end

            describe "continue to show the New page with an error message" do

              before do
                fill_in "Description",    with: "   "
                click_button "Create"
              end
            
              it { should have_title('New training method') }
              it { should have_content('error') }
            end
          end
        end

        describe "visit the Edit page" do

          let!(:changed_method) { FactoryGirl.create(:training_method) }
          before do
           visit edit_training_method_path(changed_method) 
          end

          it { should have_title('Edit training method') }
          it { should have_content('Edit training method') }
          it { should have_link('<- Cancel', href: training_methods_path) }

          describe "and update the Training Method" do

            let(:old_description) { changed_method.description }
            describe "succesfully" do

              let(:new_description)   { "Updated description" }
              before do
                fill_in "Description",    with: new_description
                click_button "Confirm"
              end

              it { should have_title('Training methods')}
              it { should have_selector('div.alert.alert-success', text: "Updated to '#{new_description}'") }
              specify { expect(changed_method.reload.description).to eq new_description }
            end
          end
        end
      end

      describe "working with ContentLengths" do

        describe "viewing the index" do
          
          let!(:length_1) { FactoryGirl.create(:content_length) }
          before do
           visit content_lengths_path 
          end

          it { should have_title('Content lengths') }
          it { should have_content('Content lengths') }
          it { should have_link("Framework menu", href: framework_path) }
          it { should have_selector('li', text: length_1.description) }
          it { should have_link('edit', href: edit_content_length_path(length_1)) }
          it { should have_link('delete', href: content_length_path(length_1)) }
          it { should have_link('Add a content length', href: new_content_length_path) }
        
          pending "No test for sortable list yet."
          pending "No delete link when the Description is in use."

          it "should be able to delete a Length" do

            expect do
              click_link('delete', href: content_length_path(length_1))
            end.to change(ContentLength, :count).by(-1)
            expect(page).to have_title('Content lengths')
            expect(page).not_to have_selector('li', text: length_1.description)
          end
        end

        describe "visit the New page" do

          before { visit new_content_length_path }

          it { should have_title("New content length") }
          it { should have_content("New content length") }
          it { should have_link("<- All content lengths", href: content_lengths_path) }

          describe "then create a new Length successfully" do
            before do
              fill_in "Description",    with: "Chapter"
            end

            it "should create a Length" do
              expect { click_button "Create" }.to change(ContentLength, :count).by(1) 
            end

            describe "and redirect to the ContentLength index" do
              before { click_button 'Create' }

              it { should have_title('Content lengths') }
              it { should have_selector('li', text: 'Chapter') }
              it { should have_selector('div.alert.alert-success', text: "'Chapter' added") } 
            end
          end

          describe "then fail to create a new Length successfully" do
            
            it "should not create a Length" do
              expect { click_button 'Create' }.not_to change(ContentLength, :count)
            end

            describe "continue to show the New page with an error message" do

              before do
                fill_in "Description",    with: "   "
                click_button "Create"
              end
            
              it { should have_title('New content length') }
              it { should have_content('error') }
            end
          end
        end

        describe "visit the Edit page" do

          let!(:changed_length) { FactoryGirl.create(:content_length) }
          before do
           visit edit_content_length_path(changed_length) 
          end

          it { should have_title('Edit content length') }
          it { should have_content('Edit content length') }
          it { should have_link('<- Cancel', href: content_lengths_path) }

          describe "and update the Content Length" do

            let(:old_description) { changed_length.description }
            describe "succesfully" do

              let(:new_description)   { "Updated description" }
              before do
                fill_in "Description",    with: new_description
                click_button "Confirm"
              end

              it { should have_title('Content lengths')}
              it { should have_selector('div.alert.alert-success', text: "Updated to '#{new_description}'") }
              specify { expect(changed_length.reload.description).to eq new_description }
            end
          end
        end
      end
      
      describe "working with Durations" do

        describe "viewing the Durations list" do
          
          let!(:unit_1) { FactoryGirl.create(:duration) }
          before do
           visit durations_path 
          end

          it { should have_title('Time periods') }
          it { should have_content('Time periods') }
          it { should have_link("Framework menu", href: framework_path) }
          it { should have_selector('li', text: unit_1.time_unit) }
          it { should have_link('edit', href: edit_duration_path(unit_1)) }
          it { should have_link('delete', href: duration_path(unit_1)) }
          it { should have_link('Add a time period', href: new_duration_path) }
        
          pending "No test for sortable list yet."
          pending "No delete link when the Duration Unit is in use."

          it "should be able to delete a Unit" do

            expect do
              click_link('delete', href: duration_path(unit_1))
            end.to change(Duration, :count).by(-1)
            expect(page).to have_title('Time periods')
            expect(page).not_to have_selector('li', text: unit_1.time_unit)
          end
        end

        describe "visit the New page" do

          before { visit new_duration_path }

          it { should have_title("New time period") }
          it { should have_content("New time period") }
          it { should have_link("<- All time periods", href: durations_path) }

          describe "then create a new Unit successfully" do
            before do
              fill_in "Time period",    with: "Aeon"
            end

            it "should create a Time_Unit" do
              expect { click_button "Create" }.to change(Duration, :count).by(1) 
            end

            describe "and redirect to the Duration index" do
              before { click_button 'Create' }

              it { should have_title('Time periods') }
              it { should have_selector('li', text: 'Aeon') }
              it { should have_selector('div.alert.alert-success', text: "'Aeon' added") } 
            end
          end

          describe "then fail to create a new Time_Unit successfully" do
            
            it "should not create a Unit" do
              expect { click_button 'Create' }.not_to change(Duration, :count)
            end

            describe "continue to show the New page with an error message" do

              before do
                fill_in "Time period",    with: "   "
                click_button "Create"
              end
            
              it { should have_title('New time period') }
              it { should have_content('error') }
            end
          end
        end

        describe "visit the Edit page" do

          let!(:changed_unit) { FactoryGirl.create(:duration, time_unit: 'Changed unit') }
          before do
           visit edit_duration_path(changed_unit) 
          end

          it { should have_title('Edit time period') }
          it { should have_content('Edit time period') }
          it { should have_link('<- Cancel change', href: durations_path) }

          describe "and update the Duration Time_Unit" do

            let(:old_unit) { changed_method.time_unit }
            describe "succesfully" do

              let(:new_unit)   { "Updated unit" }
              before do
                fill_in "Time period",    with: new_unit
                click_button "Confirm"
              end

              it { should have_title('Time periods')}
              it { should have_selector('div.alert.alert-success', text: "Updated to '#{new_unit}'") }
              specify { expect(changed_unit.reload.time_unit).to eq new_unit }
            end
          end
        end
      end
  	end

  	describe "deny access to non-admin users" do

  		describe "when not signed in" do

  			describe "submitting a GET request to the Framework menu" do
          @title = "Framework menu"
  				before { get framework_path }
          non_admin_illegal_get(@title)
	    	end





        describe "in the TrainingMethod controller" do

          let!(:existing_method) { FactoryGirl.create(:training_method) }

          describe "GET requests" do

            describe "Index" do
              @title = "Training methods"
              before { get training_methods_path }
              non_admin_illegal_get(@title)
            end

            describe "Edit" do
              @title = "Edit training method"
              before { get edit_training_method_path(existing_method) }
              non_admin_illegal_get(@title)
            end

            describe "New" do
              @title = "New training method"
              before { get new_training_method_path }
              non_admin_illegal_get(@title)
            end
          end

          describe "attempting to manipulate the TrainingMethod data" do
            
            describe "Create" do

              let(:params) do
                { training_method: { description: "New description" } }
              end
              
              it "should not create a new method" do
                expect do
                  post training_methods_path(params)
                end.not_to change(TrainingMethod, :count)
              end

              describe "should redirect to root" do

                before { post training_methods_path(params) }
                not_administrator
              end
            end

            describe "Update" do

              let(:new_method)  { "Changed description"}
              let(:params) do
                { training_method: { description: new_method } }
              end
              
              describe "should not modify the existing method" do
                
                before { patch training_method_path(existing_method), params } 
                specify { expect(existing_method.reload.description).not_to eq new_method }
              end

              describe "should redirect to root" do

                before { patch training_method_path(existing_method), params }
                not_administrator
              end
            end

            describe "Destroy" do

              it "should not delete the existing Method" do
                expect do
                  delete training_method_path(existing_method)
                end.not_to change(TrainingMethod, :count)
              end

              describe "should redirect to root" do

                before { delete training_method_path(existing_method) }
                not_administrator
              end
            end
          end
        end

        describe "in the ContentLength controller" do

          let!(:existing_length) { FactoryGirl.create(:content_length) }

          describe "GET requests" do

            describe "Index" do
              @title = "Content lengths"
              before { get content_lengths_path }
              non_admin_illegal_get(@title)
            end

            describe "Edit" do
              @title = "Edit content length"
              before { get edit_content_length_path(existing_length) }
              non_admin_illegal_get(@title)
            end

            describe "New" do
              @title = "New content length"
              before { get new_content_length_path }
              non_admin_illegal_get(@title)
            end
          end

          describe "attempting to manipulate the ContentLength data" do
            
            describe "Create" do

              let(:params) do
                { content_length: { description: "New length" } }
              end
              
              it "should not create a new length" do
                expect do
                  post content_lengths_path(params)
                end.not_to change(ContentLength, :count)
              end

              describe "should redirect to root" do

                before { post content_lengths_path(params) }
                not_administrator
              end
            end

            describe "Update" do

              let(:new_length)  { "Changed length"}
              let(:params) do
                { content_length: { description: new_length } }
              end
              
              describe "should not modify the existing Length" do
                
                before { patch content_length_path(existing_length), params } 
                specify { expect(existing_length.reload.description).not_to eq new_length }
              end

              describe "should redirect to root" do

                before { patch content_length_path(existing_length), params }
                not_administrator
              end
            end

            describe "Destroy" do

              it "should not delete the existing Length" do
                expect do
                  delete content_length_path(existing_length)
                end.not_to change(ContentLength, :count)
              end

              describe "should redirect to root" do

                before { delete content_length_path(existing_length) }
                not_administrator
              end
            end
          end
        end

        describe "in the Duration controller" do

          let!(:existing_unit) { FactoryGirl.create(:duration) }

          describe "GET requests" do

            describe "Index" do
              @title = "Time periods"
              before { get durations_path }
              non_admin_illegal_get(@title)
            end

            describe "Edit" do
              @title = "Edit time period"
              before { get edit_duration_path(existing_unit) }
              non_admin_illegal_get(@title)
            end

            describe "New" do
              @title = "New time period"
              before { get new_duration_path }
              non_admin_illegal_get(@title)
            end
          end

          describe "attempting to manipulate the Duration data" do
            
            describe "Create" do

              let(:params) do
                { duration: { time_unit: "New unit" } }
              end
              
              it "should not create a new Time_Unit" do
                expect do
                  post durations_path(params)
                end.not_to change(Duration, :count)
              end

              describe "should redirect to root" do

                before { post durations_path(params) }
                not_administrator
              end
            end

            describe "Update" do

              let(:new_unit)  { "Changed unit"}
              let(:params) do
                { duration: { time_unit: new_unit } }
              end
              
              describe "should not modify the existing Time_Unit" do
                
                before { patch duration_path(existing_unit), params } 
                specify { expect(existing_unit.reload.time_unit).not_to eq new_unit }
              end

              describe "should redirect to root" do

                before { patch duration_path(existing_unit), params }
                not_administrator
              end
            end

            describe "Destroy" do

              it "should not delete the existing Time_Unit" do
                expect do
                  delete duration_path(existing_unit)
                end.not_to change(Duration, :count)
              end

              describe "should redirect to root" do

                before { delete duration_path(existing_unit) }
                not_administrator
              end
            end
          end
        end
  		end

  		describe "when signed in as non-admin" do

  			let(:user) { FactoryGirl.create(:user) }
  			before { sign_in user, no_capybara: true }

  			describe "submitting a GET request to the Framework menu" do

          @title = "Framework updates"
  				before { get framework_path }
          non_admin_illegal_get(@title)
	    	end

        describe "in the TrainingMethod controller" do

          let!(:existing_method) { FactoryGirl.create(:training_method) }

          describe "GET requests" do

            describe "Index" do
              @title = "Training methods"
              before { get training_methods_path }
              non_admin_illegal_get(@title)
            end

            describe "Edit" do
              @title = "Edit training method"
              before { get edit_training_method_path(existing_method) }
              non_admin_illegal_get(@title)
            end

            describe "New" do
              @title = "New training method"
              before { get new_training_method_path }
              non_admin_illegal_get(@title)
            end
          end

          describe "attempting to manipulate the TrainingMethod data" do
            
            describe "Create" do

              let(:params) do
                { training_method: { description: "New description" } }
              end
              
              it "should not create a new method" do
                expect do
                  post training_methods_path(params)
                end.not_to change(TrainingMethod, :count)
              end

              describe "should redirect to root" do

                before { post training_methods_path(params) }
                not_administrator
              end
            end

            describe "Update" do

              let(:new_method)  { "Changed description"}
              let(:params) do
                { training_method: { description: new_method } }
              end
              
              describe "should not modify the existing method" do
                
                before { patch training_method_path(existing_method), params } 
                specify { expect(existing_method.reload.description).not_to eq new_method }
              end

              describe "should redirect to root" do

                before { patch training_method_path(existing_method), params }
                not_administrator
              end
            end

            describe "Destroy" do

              it "should not delete the existing Method" do
                expect do
                  delete training_method_path(existing_method)
                end.not_to change(TrainingMethod, :count)
              end

              describe "should redirect to root" do

                before { delete training_method_path(existing_method) }
                not_administrator
              end
            end
          end
        end

        describe "in the ContentLength controller" do

          let!(:existing_length) { FactoryGirl.create(:content_length) }

          describe "GET requests" do

            describe "Index" do
              @title = "Content lengths"
              before { get content_lengths_path }
              non_admin_illegal_get(@title)
            end

            describe "Edit" do
              @title = "Edit content length"
              before { get edit_content_length_path(existing_length) }
              non_admin_illegal_get(@title)
            end

            describe "New" do
              @title = "New content length"
              before { get new_content_length_path }
              non_admin_illegal_get(@title)
            end
          end

          describe "attempting to manipulate the ContentLength data" do
            
            describe "Create" do

              let(:params) do
                { content_length: { description: "New length" } }
              end
              
              it "should not create a new length" do
                expect do
                  post content_lengths_path(params)
                end.not_to change(ContentLength, :count)
              end

              describe "should redirect to root" do

                before { post content_lengths_path(params) }
                not_administrator
              end
            end

            describe "Update" do

              let(:new_length)  { "Changed length"}
              let(:params) do
                { content_length: { description: new_length } }
              end
              
              describe "should not modify the existing Length" do
                
                before { patch content_length_path(existing_length), params } 
                specify { expect(existing_length.reload.description).not_to eq new_length }
              end

              describe "should redirect to root" do

                before { patch content_length_path(existing_length), params }
                not_administrator
              end
            end

            describe "Destroy" do

              it "should not delete the existing Length" do
                expect do
                  delete content_length_path(existing_length)
                end.not_to change(ContentLength, :count)
              end

              describe "should redirect to root" do

                before { delete content_length_path(existing_length) }
                not_administrator
              end
            end
          end
        end

        describe "in the Duration controller" do

          let!(:existing_unit) { FactoryGirl.create(:duration) }

          describe "GET requests" do

            describe "Index" do
              @title = "Time periods"
              before { get durations_path }
              non_admin_illegal_get(@title)
            end

            describe "Edit" do
              @title = "Edit time period"
              before { get edit_duration_path(existing_unit) }
              non_admin_illegal_get(@title)
            end

            describe "New" do
              @title = "New time period"
              before { get new_duration_path }
              non_admin_illegal_get(@title)
            end
          end

          describe "attempting to manipulate the Duration data" do
            
            describe "Create" do

              let(:params) do
                { duration: { time_unit: "New unit" } }
              end
              
              it "should not create a new Time_Unit" do
                expect do
                  post durations_path(params)
                end.not_to change(Duration, :count)
              end

              describe "should redirect to root" do

                before { post durations_path(params) }
                not_administrator
              end
            end

            describe "Update" do

              let(:new_unit)  { "Changed unit"}
              let(:params) do
                { duration: { time_unit: new_unit } }
              end
              
              describe "should not modify the existing Time_Unit" do
                
                before { patch duration_path(existing_unit), params } 
                specify { expect(existing_unit.reload.time_unit).not_to eq new_unit }
              end

              describe "should redirect to root" do

               before { patch duration_path(existing_unit), params }
                not_administrator
              end
            end

            describe "Destroy" do

              it "should not delete the existing Time_Unit" do
                expect do
                  delete duration_path(existing_unit)
                end.not_to change(Duration, :count)
              end

              describe "should redirect to root" do

                before { delete duration_path(existing_unit) }
                not_administrator
              end
            end
          end
        end
  		end
  	end
end
