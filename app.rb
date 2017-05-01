# database: ruby_db
# just create the database in mysql

# Mask password input
require 'highline/import'
# Mysql 
require 'mysql2'
# pretty table
require 'text-table'
# date
require 'date'

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
	puts "What would you like? (a) Manage Items,  (b) Manage Records? ,(c) Main Menu"
	menu_choice = gets.chomp
	
	case menu_choice.upcase
		when "A"
			# call manage items function
			manage_items
		when "B"
			# call manage records function
			manage_records
		when "C"
			# call admin menu function
			main_program
		else
			# call invalid message
			invalid_message
			admin_menu
	end

end





# Manage records function =====================================================================
def manage_records()
	system "clear"
	cmd  = ""
	menu_choice = ""
	puts "\n\n*** Welcome to Borrowing Record System *** \n\n"
	puts "What would you like?  (a) Add Record, (b) Update Record, (c) Delete Record, (d) View Record, (e) Main Menu"
	menu_choice = gets.chomp

	case menu_choice.upcase 
		when 'A'
			# intialize variables and date with time
			b_name = ""
			strdate = Time.now.to_s
			b_return = ""#DateTime.parse(strdate).strftime("%H:%M:%S")
			b_date = DateTime.parse(strdate).strftime("%Y-%m-%d %I:%M:%S")
			b_count = ""
			b_item = ""
			b_item_id = ""
			b_status = "INCOMPLETE"

			temp_bcount = ""
			temp_count = ""
			total = ""
			puts "\nEnter Name: (Last Name , First Name, Middle Initial)"
			b_name = gets.chomp
			b_name = b_name.upcase
			puts "\nDate:\n" +  b_date
			#puts "\nTime:\n" + b_time


			# display items table
			puts "\n"
			all_items = $client.query('SELECT * FROM items_tb');
			data = []
			header = ['ID', 'ITEM NAME' ,'ITEM COUNT','ITEM BORROWED']
			all_items.each do |row|
			 	temp = ["#{row['id']}","#{row['item_name']}","#{row['item_count']}","#{row['item_bcount']}"]
			 	data.push(temp)
			end
			data.unshift(header)
			puts data.to_table(:first_row_is_head => true, :last_row_is_foot => false)

			puts "\nEnter Item ID: "
			b_item_id = gets.chomp

			all_items.each do |row|
				if b_item_id == "#{row['id']}"
					b_item = "#{row['item_name']}"
					temp_bcount = "#{row['item_bcount']}"
					temp_count = "#{row['item_count']}"
				end
			end

			if b_item == ""
				puts "\nItem not found !!!"
				puts "\n\nPress Enter to continue . . ."
				gets 
				# call manage records function
				manage_records
			end

			puts "\nItem Name: \n" + b_item
			puts "\nEnter Count: "
			b_count = gets.chomp

			total = temp_count.to_i - temp_bcount.to_i
			
			if b_count.to_i > total.to_i	
				puts "\nItem is currently unavailable"
				puts "\n\nPress Enter to continue . . ."
				gets 
				# call manage records function
				manage_records
			end

			# Update current total item_bcount
			total = temp_bcount.to_i + b_count.to_i 
			puts "\nStatus: \n" + b_status 

			# add data to records_tb
			$client.query("INSERT INTO records_tb 
			  			(b_name, b_date,  b_item, b_item_id, b_count, b_status) 
			   			VALUES 
			  			('#{b_name}','#{b_date}','#{b_item}','#{b_item_id}','#{b_count}','#{b_status}')")

			# subtract borrower count from items_tb
			$client.query("UPDATE items_tb SET item_bcount = '#{total}' WHERE id = '#{b_item_id}'")
			# Successfully Added New record			
			puts "\nSuccessfully Added \n\nPress Enter to continue . . ."
			gets
			# call manage_records function to back to its menu
			manage_records
	when 'B'
			# Get all items from records_tb
			all_items = $client.query('SELECT * FROM records_tb');
			 
			# Initialize array  for displaying the data to table
			data = []

			# Initialize header array for table
			header = ['ID', 'BORROWER' ,'DATE BORROWED','DATE RETURNED','ITEM BORROWED','ITEM ID','ITEM COUNT','ITEM STATUS']
			all_items.each do |row|
			 	# Once we query all the data from items_tb
			 	# We need to format the data to array, because the data from array is in JSON like format
			 	# But in PHP usage format
			 	# Line below is the formatting the data to ruby readable array
			 	temp = ["#{row['id']}","#{row['b_name']}","#{row['b_date']}","#{row['b_return']}","#{row['b_item']}","#{row['b_item_id']}","#{row['b_count']}","#{row['b_status']}"]
			 	data.push(temp)
			 end
			 data.unshift(header)
			 puts data.to_table(:first_row_is_head => true, :last_row_is_foot => false)
			 strdate = Time.now.to_s
			 b_return = DateTime.parse(strdate).strftime("%Y-%m-%d %I:%M:%S")
			 input_id = ""
			 b_status = ""
			 b_count = ""
			 puts "\n\nEnter ID:"
			 input_id = gets.chomp

			 result = $client.query("SELECT * FROM records_tb WHERE id = '#{input_id}'")
			 if result.count == 0
			 	puts "\n\nNo record found !!!"
			 	gets
				# call manageg items
				manage_records
			else
				temp_item_id = ""
				temp_total = ""

				puts "\nReturned Item Count: "
				b_count =  gets.chomp
				
				result.each do |row|
					if "#{row['id']}" == input_id
						# get count of items in records table
						temp_bcount = "#{row['b_count']}"
						temp_item_id = "#{row['b_item_id']}"
					end
				end


				if b_count == temp_bcount
					b_status = "COMPLETE"
					# Display Status
					puts "\nStatus:\n" + b_status

					# Update records db
					$client.query("UPDATE records_tb SET b_status = '#{b_status}', b_return = '#{b_return}' WHERE id = '#{input_id}'")

					# Update items
					result = $client.query("SELECT * FROM items_tb WHERE id = '#{temp_item_id}'") 
					result.each do |row|
						# Get total borrowed count from items_tb
						temp_total =  "#{row['item_bcount']}"
					end

					temp_total = temp_total.to_i - b_count.to_i
					# Update items_tb
					$client.query("UPDATE items_tb SET item_bcount = '#{temp_total}' WHERE id = '#{temp_item_id}'")
					puts "\nSuccessfully Updated \n\nPress Enter to continue . . ."
					gets
					manage_records

				elsif b_count > temp_bcount || b_count < temp_bcount
					puts "\nReturned count is invalid"
					puts "\n\nPress Enter to continue . . ."
					gets 
					# call manage records function
					manage_records
				end

			end
	when 'C'
			# Get all items from records_tb
			all_items = $client.query('SELECT * FROM records_tb'); 
			# Initialize array  for displaying the data to table
			data = []
			# Initialize header array for table
			header = ['ID', 'BORROWER' ,'DATE BORROWED','DATE RETURNED','ITEM BORROWED','ITEM ID','ITEM COUNT','ITEM STATUS']
			all_items.each do |row|
			 	# Once we query all the data from items_tb
			 	# We need to format the data to array, because the data from array is in JSON like format
			 	# But in PHP usage format
			 	# Line below is the formatting the data to ruby readable array
			 	temp = ["#{row['id']}","#{row['b_name']}","#{row['b_date']}","#{row['b_return']}","#{row['b_item']}","#{row['b_item_id']}","#{row['b_count']}","#{row['b_status']}"]
			 	data.push(temp)
			 end
			 data.unshift(header)
			 puts data.to_table(:first_row_is_head => true, :last_row_is_foot => false)

			 input_id = ""
			 puts "\nEnter ID: "
			 input_id = gets.chomp

			 result = $client.query("SELECT * FROM records_tb WHERE id = '#{input_id}'")
			 if result.count == 0
			 	puts "\n\nNo record found !!!"
			 	gets
				# call manage recordss
				manage_records
			 else
			 	$client.query("DELETE FROM records_tb WHERE id = '#{input_id}'")
			 	# Condition for successful deletion
			 	puts "\nSuccessfully DELETED \n\nPress Enter to continue . . ."
			 	gets
				# call manageg records
				manage_records

			 end
	when 'D'
			# Get all items from records_tb
			all_items = $client.query('SELECT * FROM records_tb'); 
			# Initialize array  for displaying the data to table
			data = []
			# Initialize header array for table
			header = ['ID', 'BORROWER' ,'DATE BORROWED','DATE RETURNED','ITEM BORROWED','ITEM ID','ITEM COUNT','ITEM STATUS']
			all_items.each do |row|
			 	# Once we query all the data from items_tb
			 	# We need to format the data to array, because the data from array is in JSON like format
			 	# But in PHP usage format
			 	# Line below is the formatting the data to ruby readable array
			 	temp = ["#{row['id']}","#{row['b_name']}","#{row['b_date']}","#{row['b_return']}","#{row['b_item']}","#{row['b_item_id']}","#{row['b_count']}","#{row['b_status']}"]
			 	data.push(temp)
			 end
			 data.unshift(header)
			 puts data.to_table(:first_row_is_head => true, :last_row_is_foot => false)
			 puts "\n\nPress any key to continue . . ."
			 gets
			 # call manage records function
			 manage_records
	when 'E'
		 # call main progam function
		 main_program
	end

end





# Manage Items function ========================================================================
def manage_items()
	system "clear"
	cmd  = ""
	menu_choice = ""
	puts "\n\n*** Welcome to Borrowing Record System *** \n\n"
	puts "What would you like?  (a) Add, (b) Update, (c) Delete , (d) View Items ,(e) Main Menu"
	menu_choice = gets.chomp
	
	case menu_choice.upcase
		when 'A'
			item_name = ""
			item_count = ""
			item_bcount = 0
			puts "\nEnter Item Name:"
			item_name = gets.chomp
			puts "\nEnter Item Count:"
			item_count = gets.chomp

			# Add data to items_tb for new items to be borrowed
			$client.query("INSERT INTO items_tb (item_name, item_count, item_bcount) VALUES ('#{item_name}','#{item_count}','#{item_bcount}')")
			puts "\nSuccessfully Added \n\nPress Enter to continue . . ."
			gets
			# call manageg items
			manage_items
		when 'B'
			 # Get all items from items_tb
			 all_items = $client.query('SELECT * FROM items_tb');
			 
			 # Initialize array  for displaying the data to table
			 data = []

			 # Initialize header array for table
			 header = ['ID', 'ITEM NAME' ,'ITEM COUNT','ITEM BORROWED']
			 all_items.each do |row|
			 	# Once we query all the data from items_tb
			 	# We need to format the data to array, because the data from array is in JSON like format
			 	# But in PHP usage format
			 	# Line below is the formatting the data to ruby readable array
			 	temp = ["#{row['id']}","#{row['item_name']}","#{row['item_count']}","#{row['item_bcount']}"]
			 	data.push(temp)
			 end
			 data.unshift(header)
			 puts data.to_table(:first_row_is_head => true, :last_row_is_foot => false)

			 id = ""
			 puts "\n\nEnter ID:"
			 input_id = gets.chomp

			 # Check if the id exist in items_tb
			 result = $client.query("SELECT * FROM items_tb WHERE id = #{input_id}")
			 # verify if id exists
			 if result.count == 0
			 	puts "\n\nNo record found !!!"
			 	gets
				# call manageg items
				manage_items
			 else
			 	update_name = ""
			 	update_count = ""
			 	update_bcount = ""
			 	puts "\nEnter Item Name:"
			 	update_name = gets.chomp
			 	puts "\nEnter Item Count"
			 	update_count = gets.chomp
			 	puts "\nEnter Item Borrowed Count"
			 	update_bcount = gets.chomp

			 	puts "\nSuccessfully Updated \n\nPress Enter to continue . . ."
			 	# Update the record  from items_tb
			 	$client.query("UPDATE items_tb SET item_name = '#{update_name}', item_count = '#{update_count}', item_bcount = '#{update_bcount}' WHERE id = '#{input_id}' ")

			 	gets
				# call manageg items
				manage_items
			 end

		when 'C'
			 # Get all data from items-tb to display
			 all_items = $client.query('SELECT * FROM items_tb');
			 data = []
			 header = ['ID', 'ITEM NAME' ,'ITEM COUNT','ITEM BORROWED']
			 all_items.each do |row|
			 	temp = ["#{row['id']}","#{row['item_name']}","#{row['item_count']}","#{row['item_bcount']}"]
			 	data.push(temp)
			 end
			 data.unshift(header)
			 puts data.to_table(:first_row_is_head => true, :last_row_is_foot => false)

			 id = ""
			 puts "\n\nEnter ID:"
			 input_id = gets.chomp

			 # Verify if id exists in items_tb
			 result = $client.query("SELECT * FROM items_tb WHERE id = #{input_id}")
			 if result.count == 0
			 	puts "\n\nNo record found !!!"
			 	gets
				# call manage items
				manage_items
			 else
			 	# Condition for successful deletion
			 	puts "\nSuccessfully DELETED \n\nPress Enter to continue . . ."
			 	$client.query("DELETE FROM items_tb WHERE id = '#{input_id}'")
			 	gets
				# call manageg items
				manage_items
			 end
		when 'D'
			 # Get all data from items_db to display
			 all_items = $client.query('SELECT * FROM items_tb');
			 data = []
			 header = ['ID', 'ITEM NAME' ,'ITEM COUNT','ITEM BORROWED']
			 all_items.each do |row|
			 	temp = ["#{row['id']}","#{row['item_name']}","#{row['item_count']}","#{row['item_bcount']}"]
			 	data.push(temp)
			 end
			 data.unshift(header)
			 puts data.to_table(:first_row_is_head => true, :last_row_is_foot => false)
			 puts "\nPress Enter to continue . . ."
			 gets
			# call manageg items
			manage_items
		when 'E'
			# back to main program
			main_program
		else
			# call invalid message function
			invalid_message
	end

end







# Main System Function() =======================================================================
def main_program()
	# better to see isolated program with clear screens
	system 'clear'
	cmd  = ""
	menu_choice = ""
	puts "\n\n*** Welcome to Borrowing Record System *** \n\n"
	puts "What would you like? (a) Admin User, (b) View Records, (c) Exit?"
	menu_choice = gets.chomp

	# verify menu input
	case menu_choice.upcase
		when 'A'
			# call login function
			admin_account_login
		when 'B'
			# Get all items from records_tb
			all_items = $client.query('SELECT * FROM records_tb'); 
			# Initialize array  for displaying the data to table
			data = []
			# Initialize header array for table
			header = ['ID', 'BORROWER' ,'DATE BORROWED','DATE RETURNED','ITEM BORROWED','ITEM ID','ITEM COUNT','ITEM STATUS']
			all_items.each do |row|
			 	# Once we query all the data from items_tb
			 	# We need to format the data to array, because the data from array is in JSON like format
			 	# But in PHP usage format
			 	# Line below is the formatting the data to ruby readable array
			 	temp = ["#{row['id']}","#{row['b_name']}","#{row['b_date']}","#{row['b_return']}","#{row['b_item']}","#{row['b_item_id']}","#{row['b_count']}","#{row['b_status']}"]
			 	data.push(temp)
			 end
			 data.unshift(header)
			 puts data.to_table(:first_row_is_head => true, :last_row_is_foot => false)
			 puts "\n\nPress any key to continue . . ."
			 gets
			 # call main program function
			 main_program
		when 'C'
			system 'exit'
		else
			# call invalid message function
			invalid_message
	end
end





# Make clinet variable  global ===================================================================
# SQL connection
$client = Mysql2::Client.new(:host => "localhost", :username => "root", :database => "ruby_db")

# Create records_tb for borrowers record
$client.query("CREATE TABLE IF NOT EXISTS records_tb 
			(id INTEGER NOT NULL PRIMARY KEY AUTO_INCREMENT, 
			b_name VARCHAR(50) NOT NULL,
			b_date DATETIME NOT NULL,
			b_return DATETIME,
			b_item VARCHAR(50) NOT NULL,
			b_item_id VARCHAR(50) NOT NULL,
			b_count VARCHAR(50) NOT NULL,
			b_status VARCHAR(50) NOT NULL
			)")

# Create items_tb for items
$client.query("CREATE TABLE IF NOT EXISTS items_tb 
			(id INTEGER NOT NULL PRIMARY KEY AUTO_INCREMENT,
			 item_name VARCHAR(50) NOT NULL,
			 item_count INTEGER,
			 item_bcount INTEGER
			)")


# call the main program function
main_program


