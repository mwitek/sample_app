module ApplicationHelper
	#return the page title base page action name
	def title(new_title)
		if new_title.empty?
			"Ruby on Rails Tutorial Sample App | #{params[:action].capitalize}"
		else
			"#{new_title}"
		end
	end

	def page_title(override = "Page")
		 "#{params[:action].capitalize} #{override}"
	end
end