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
	    	it { should have_link('Duration units', href: durations_path) }

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
        
          pending "No delete link when the Method is in use"

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

      describe "working with Durations" do

        describe "viewing the Durations list" do
          
          let!(:unit_1) { FactoryGirl.create(:duration) }
          before do
           visit durations_path 
          end

          it { should have_title('Duration units') }
          it { should have_content('Duration units') }
          it { should have_link("Framework menu", href: framework_path) }
          it { should have_selector('li', text: unit_1.time_unit) }
          it { should have_link('edit', href: edit_duration_path(unit_1)) }
          it { should have_link('delete', href: duration_path(unit_1)) }
          it { should have_link('Add a duration unit', href: new_duration_path) }
        
          pending "No delete link when the Duration Unit is in use"

          it "should be able to delete a Unit" do

            expect do
              click_link('delete', href: duration_path(unit_1))
            end.to change(Duration, :count).by(-1)
            expect(page).to have_title('Duration units')
            expect(page).not_to have_selector('li', text: unit_1.time_unit)
          end
        end

        describe "visit the New page" do

          before { visit new_duration_path }

          it { should have_title("New duration unit") }
          it { should have_content("New duration unit") }
          it { should have_link("<- All units", href: durations_path) }

          describe "then create a new Unit successfully" do
            before do
              fill_in "Time unit",    with: "Aeon"
            end

            it "should create a Unit" do
              expect { click_button "Create" }.to change(Duration, :count).by(1) 
            end

            describe "and redirect to the Duration index" do
              before { click_button 'Create' }

              it { should have_title('Duration units') }
              it { should have_selector('li', text: 'Aeon') }
              it { should have_selector('div.alert.alert-success', text: "'Aeon' added") } 
            end
          end

          describe "then fail to create a new Unit successfully" do
            
            it "should not create a Unit" do
              expect { click_button 'Create' }.not_to change(Duration, :count)
            end

            describe "continue to show the New page with an error message" do

              before do
                fill_in "Time unit",    with: "   "
                click_button "Create"
              end
            
              it { should have_title('New duration unit') }
              it { should have_content('error') }
            end
          end
        end

        describe "visit the Edit page" do

          let!(:changed_unit) { FactoryGirl.create(:duration, time_unit: 'Changed unit') }
          before do
           visit edit_duration_path(changed_unit) 
          end

          it { should have_title('Edit duration unit') }
          it { should have_content('Edit duration unit') }
          it { should have_link('<- Cancel change', href: durations_path) }

          describe "and update the Duration Unit" do

            let(:old_unit) { changed_method.time_unit }
            describe "succesfully" do

              let(:new_unit)   { "Updated unit" }
              before do
                fill_in "Time unit",    with: new_unit
                click_button "Confirm"
              end

              it { should have_title('Duration units')}
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

        describe "in the Duration controller" do

          let!(:existing_unit) { FactoryGirl.create(:duration) }

          describe "GET requests" do

            describe "Index" do
              @title = "Duration units"
              before { get durations_path }
              non_admin_illegal_get(@title)
            end

            describe "Edit" do
              @title = "Edit duration unit"
              before { get edit_duration_path(existing_unit) }
              non_admin_illegal_get(@title)
            end

            describe "New" do
              @title = "New duration unit"
              before { get new_duration_path }
              non_admin_illegal_get(@title)
            end
          end

          describe "attempting to manipulate the Duration data" do
            
            describe "Create" do

              let(:params) do
                { duration: { time_unit: "New unit" } }
              end
              
              it "should not create a new unit" do
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
              
              describe "should not modify the existing Unit" do
                
                before { patch duration_path(existing_unit), params } 
                specify { expect(existing_unit.reload.time_unit).not_to eq new_unit }
              end

              describe "should redirect to root" do

                before { patch duration_path(existing_unit), params }
                not_administrator
              end
            end

            describe "Destroy" do

              it "should not delete the existing Unit" do
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

        describe "in the Duration controller" do

          let!(:existing_unit) { FactoryGirl.create(:duration) }

          describe "GET requests" do

            describe "Index" do
              @title = "Duration units"
              before { get durations_path }
              non_admin_illegal_get(@title)
            end

            describe "Edit" do
              @title = "Edit duration unit"
              before { get edit_duration_path(existing_unit) }
              non_admin_illegal_get(@title)
            end

            describe "New" do
              @title = "New duration unit"
              before { get new_duration_path }
              non_admin_illegal_get(@title)
            end
          end

          describe "attempting to manipulate the Duration data" do
            
            describe "Create" do

              let(:params) do
                { duration: { time_unit: "New unit" } }
              end
              
              it "should not create a new unit" do
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
              
              describe "should not modify the existing Unit" do
                
                before { patch duration_path(existing_unit), params } 
                specify { expect(existing_unit.reload.time_unit).not_to eq new_unit }
              end

              describe "should redirect to root" do

                before { patch duration_path(existing_unit), params }
                not_administrator
              end
            end

            describe "Destroy" do

              it "should not delete the existing Unit" do
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
