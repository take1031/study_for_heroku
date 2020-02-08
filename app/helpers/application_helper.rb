module ApplicationHelper
	def hidden_div_if(condition, attributes = {}, &block)
		if condition
			attributes["style"] = "display: none"
		end
		content_tag("div", attributes, &block)
	end
	def simple_time(time)
		time.strftime("%Y-%m-%d　%H:%M　")
    end
end
