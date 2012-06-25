module ApplicationHelper
	#return the page title base page action name
	def title
		"Ruby on Rails Tutorial Sample App | #{params[:action].capitalize}"
	end
end