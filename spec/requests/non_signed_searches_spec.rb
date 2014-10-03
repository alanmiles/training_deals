require 'spec_helper'

describe "NonSignedSearches" do
  
  subject { page }

	before(:each) do 
 		Business.any_instance.stub(:geocode).and_return([1,1]) 
	end

	build_product_list

	describe "visit the Home page" do

		before { visit root_path }

		it { should have_content("5 ways to learn.") }
		it { should_not have_content("(5 found)") }
		it { should have_selector("#genre_select", text: "#{genre_1.description}") }
		it { should have_selector("#genre_select", text: "#{genre_2.description}") }
		it { should have_button("View results") }

		describe "select a Genre", js: true do

			before { select "#{genre_1.description}", from: 'genre_select' }

			it { should have_content("5 ways to learn.") }
			it { should have_content("4 found)") }
			it { should have_selector("#cat_select", text: "#{genre_1_cat_1.description}") }
			it { should have_selector("#cat_select", text: "#{genre_1_cat_2.description}") }
			it { should_not have_selector("#cat_select", text: "#{genre_2_cat_1.description}") }
			it { should_not have_selector("#cat_select", text: "#{genre_1_pending_cat.description}") }
			it { should_not have_selector("#cat_select", text: "#{genre_1_no_topic_cat.description}") }

			describe  "select a Category" do

				before { select "#{genre_1_cat_1.description}", from: 'cat_select' }

				it { should have_content("3 found)") }
				it { should have_selector("#topic_select", text: "#{genre_1_cat_1_topic_2.description}") }
				it { should_not have_selector("#topic_select", text: "#{genre_1_cat_2_topic_1.description}") }
			
				describe "select a Topic with Products found" do

					before { select "#{genre_1_cat_1_topic_1.description}", from: 'topic_select' }

					it { should have_content("3 found)") }
				end

				describe "select a Topic with no Products found" do

					before { select "#{genre_1_cat_1_topic_2.description}", from: 'topic_select' }

					it { should have_content("0 found)") }
				
					describe "deselect genre_1" do

						before { select "Please select", from: 'genre_select' }

						it { should_not have_content("5 found)") }
						it { should_not have_selector("#cat_select", text: "#{genre_1_cat_1.description}") }
						it { should_not have_selector("#cat_select", text: "#{genre_1_cat_2.description}") }
						it { should_not have_selector("#topic_select", text: "#{genre_1_cat_1_topic_2.description}") }

					end
				end
			end
		end
	end

	describe "Conduct a search" do

		before { visit root_path }

		describe "Without selecting a genre" do

			before { click_button "View results" }

			pending "can't test because of modal dialog - should not pass to results controller"

		end

		describe "When genre is selected, but not category or topic" do

			before do
				select "#{genre_1.description}", from: 'genre_select'
				click_button "View results"
			end

			it { should have_title("Search results") }


		end
	end
end
