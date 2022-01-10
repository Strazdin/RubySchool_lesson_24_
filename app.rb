#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'pony'

get '/' do
	erb "Hello! <a href=\"https://github.com/bootstrap-ruby/sinatra-bootstrap\">Original</a> pattern has been modified for <a href=\"http://rubyschool.us/\">Ruby School</a>"			
end

get '/about' do
	@error = 'something wrong'
	erb :about
end

get '/contacts' do
	erb :contacts
end

get '/visit' do
	erb :visit
end

get '/admin' do
	erb :admin
end

def error_message hh
	return hh.select {|key,_| params[key] == ''}.values.join(", ")
end

post '/visit' do

	@user_name   = params[:user_name]
    @phone       = params[:phone]
    @date_time   = params[:date_time]
	@hairdresser = params[:hairdresser]
	@color		 = params[:color]
	# Хеш
	hh = { :user_name => 'Enter name',
	   :phone => 'Enter phone number',
	   :date_time => 'Enter time and day' }

	 @error = error_message hh

	if @error != ''
		return erb :visit
	end

	@title   = 'Thank you!'
    @message = "Dear #{@user_name}, we'll be wating for you at #{@date_time} at the selected hairdresser #{@hairdresser}.Color: #{@color}"

    f = File.open './public/contacts.txt', 'a'
    f.write "User: #{@user_name}, Phone: #{@phone}, Date and time: #{@date_time}, Hairdresser: #{@hairdresser}, Color: #{@color}\n"
    f.close


	erb :visit

end


post '/admin' do

	@admins     = params[:admin]
    @admin_pas = params[:admin_pas]
	if @admins == "admin" && @admin_pas == "barber" 
		@message = 'message ....'
	else
		@error = 'Access denied'
	end
	erb :admin
end

post '/contacts' do

	@contacts_name = params[:contacts_name].capitalize
	@contacts_mail = params[:contacts_mail]
	@contacts_text = params[:contacts_text]
	@error=''

	hh = { :contacts_name => 'Enter your name',
		   :contacts_mail => 'Enter your mail' }

	@error = error_message hh

	if @error != ''
		return erb :contacts
	else
		Pony.mail({
			:to => "#{@contacts_mail}",
			:via => :smtp,
			:via_options => {
			  :address              => 'smtp.gmail.com',
			  :port                 => '587',
			  :enable_starttls_auto => true,
			  :user_name            => 'xxxxxx@gmail.com',
			  :password             => 'xxxxxx',
			  :domain               => "localhost.localdomain"
			},
			:subject => "Message from #{@contacts_name}",
			:body    => "#{@contacts_text}" 
		    })
		  @success = "Thank you, #{@contacts_name}, we will receive your request!"
	end
end


