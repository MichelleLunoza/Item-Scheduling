# Mask password input
require 'highline/import'
# Mysql 
require 'mysql2'

# admin accoount login function
def admin_account_login()
  # prompt password function
  def password_prompt(message, mask='*')
    ask(message) { |q| q.echo = mask}
  end

  password = '1234'
  passwordEntry = password_prompt('Enter passcode: ')


  if(passwordEntry == password)
  	# call admin menu
  	admin_menu
  else
  	# call invalid password message
  	invalid_password
  end

end

# show globally ivnvalid message
def invalid_message()
	press = ""
	puts "Invalid Input !!! \n\nPress ENTER to continue . . . "
	gets
	main_program
end

# show invalid password
def invalid_password()
	puts "\n\nInvalid Password !!!\n\nPress ENTER to continue ..."
	gets
	main_program
end

# function for displaying menu admin
def admin_menu()
	system 'clear'
	cmd  = ""
	menu_choice = ""
	puts "\n\n*** Welcome to Item Scheduling System *** \n\n"
	puts "What would you like? Add, Update, Delete, View Items, View Schedule?"
	menu_choice = gets.chomp
	
	case menu_choice.upcase 

	when "ADD"

		
	end

end

# Main System Function()
def main_program()
	# better to see isolated program
	system 'clear'
	cmd  = ""
	menu_choice = ""
	puts "\n\n*** Welcome to Item Scheduling System *** \n\n"
	puts "What would you like? Admin User, View Schedule, Exit?"
	menu_choice = gets.chomp

	# verify menu input
	case menu_choice.upcase
		when 'ADMIN USER'
			# call login function
			admin_account_login

		else
			# call invalid message
			invalid_message
	end
end



# Make clinet variable  global
$client = Mysql2::Client.new(:host => "localhost", :username => "root", :database => "ruby_db")
$client.query("CREATE TABLE IF NOT EXISTS records_tb 
			(id INTEGER NOT NULL PRIMARY KEY AUTO_INCREMENT, 
			b_name VARCHAR(50) NOT NULL,
			b_date DATE NOT NULL,
			b_time TIME NOT NULL,
			b_item VARCHAR(50) NOT NULL,
			b_pieces VARCHAR(50) NOT NULL
			)")

$client.query("CREATE TABLE IF NOT EXISTS items_tb 
			(id INTEGER NOT NULL PRIMARY KEY AUTO_INCREMENT,
			 item_name VARCHAR(50) NOT NULL,
			 item_count INTEGER 
			)")


# call the main program function
#main_program

admin_menu


