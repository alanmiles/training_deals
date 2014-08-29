module ApplicationHelper

	# Returns the full title on a per-page basis.
	def full_title(page_title)
		base_title = "HROOMPH"
		if page_title.empty?
			base_title
		else
			"#{base_title} | #{page_title}".html_safe
		end
	end

	def sortable(column, title = nil)
		title ||= column.titleize
		#css_class = (column == sort_column) ? "current #{sort_direction}" : nil
		#direction =  (column == sort_column && sort_direction == "asc") ? "desc" : "asc"
		#link_to title, { :sort => column, :direction => direction }, { class: css_class }
		#css_class = (column == sort_column) ? "current &crarr;
		#	 #{sort_direction}" : nil
		#direction =  (column == sort_column && sort_direction == &crarr;
		#	 "asc") ? "desc" : "asc"
		css_class = (column == sort_column) ? "current #{sort_direction}" : nil
		direction =  (column == sort_column && sort_direction == "asc") ? "desc" : "asc"
		link_to title, params.merge(:sort => column, :direction => direction, :page => nil), { :class => css_class }
	end

	def formatted_daydate(field)
		field.strftime('%a %d %b, %Y')
	end

	def formatted_shortdate(field)
		field.strftime('%d-%b-%Y')
	end

	def formatted_time(field)
		field.strftime('%l:%M %P')
	end
end
