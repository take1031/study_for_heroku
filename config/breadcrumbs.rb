crumb :root do
    link "Home", store_path
end

crumb :products do
	link "商品一覧", products_path
	parent :root
end 

crumb :product do |product|
	link "@#{product.title}", product_path(product)
	parent :products
end

crumb :categories do |category|
	link "@#{category.c_name}"
	parent :root
end

crumb :user do |user|
	link "@#{user.name}" ,user_path(user)
	parent :root
end

crumb :order do
	link "注文詳細"
	# parent :user , @order.user
end

# crumb :projects do
#   link "Projects", projects_path
# end

# crumb :project do |project|
#   link project.name, project_path(project)
#   parent :projects
# end

# crumb :project_issues do |project|
#   link "Issues", project_issues_path(project)
#   parent :project, project
# end

# crumb :issue do |issue|
#   link issue.title, issue_path(issue)
#   parent :project_issues, issue.project
# end

# If you want to split your breadcrumbs configuration over multiple files, you
# can create a folder named `config/breadcrumbs` and put your configuration
# files there. All *.rb files (e.g. `frontend.rb` or `products.rb`) in that
# folder are loaded and reloaded automatically when you change them, just like
# this file (`config/breadcrumbs.rb`).