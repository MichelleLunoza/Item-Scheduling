# Mask password input
require 'highline/import'
# Mysql 
require 'mysql2'

# admin accoount login function ===============================================================
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

# show globally ivnvalid message ===============================================================
def invalid_message()
	press = ""
	puts "Invalid Input !!! \n\nPress ENTER to continue . . . "
	gets
	main_program
end

# show invalid password ========================================================================
def invalid_password()
	puts "\n\nInvalid Password !!!\n\nPress ENTER to continue ..."
	gets
	main_program
end

# function for displaying menu admin ===========================================================
def admin_menu()
	system 'clear'
	cmd  = ""
	menu_choice = ""
	puts "\n\n*** Welcome to Item Scheduling System *** \n\n"
	puts "What would you like? (a) Manage Items,  (b) Manage Schedule?"
	menu_choice = gets.chomp
	
	case menu_choice.upcase
		when "A"
			# call manage items function
			manage_items
		when "B"

		else
			# call invalid message
			invalid_message
	end

end


# Manage Items function ========================================================================
def manage_items()
	system "clear"
	cmd  = ""
	menu_choice = ""
	puts "\n\n*** Welcome to Item Scheduling System *** \n\n"
	puts "What would you like?  (a)Add, (b)Update, (c)Delete , (d)View Items"
	menu_choice = gets.chomp
	
	case menu_choice.upcase
		when 'A'
			item_name = ""
			item_count = ""
			puts "\nEnter Item Name:"
			item_name = gets.chomp
			puts "\nEnter Item Count:"
			item_count = gets.chomp
			$client.query("INSERT INTO items_tb (item_name, item_count) VALUES ('#{item_name}','#{item_count}')")
			puts "\nSuccessfully Added \n\nPress Enter to continue . . ."
			gets
			# call manageg items
			manage_items
	end

end

# Main System Function() =======================================================================
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



# Make clinet variable  global ===================================================================
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


