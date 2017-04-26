require 'highline/import'

cmd = ""
choice1=""
choice2=""
passcode="admin"
passwordEntry=""
idContent=""
puts "\n\n***Welcome to Chuchu Scheduling***\n\n\n"
puts "What would you like? Admin User, View Schedule, Exit?"
choice1 = gets.chomp


case choice1.upcase
when "ADMIN USER"
  puts "\n\n"
  def password_prompt(message, mask='*')
    ask(message) { |q| q.echo = mask}
  end

  passwordEntry = password_prompt('Enter passcode: ')
    if passwordEntry != passcode
      puts "Invalid passcode. Now exiting"
    else
      puts"Welcome Admin!\n\n"
      puts"What would you like? Update/Add/Delete Schedule."
      choice2=gets.chomp
      case choice2.upcase

      when "UPDATE SCHEDULE"
        File.open("Data.txt").each do |firstline|
        puts "Enter User ID:"
        UserID = gets.to_i
        if firstline != UserID
        puts "Invalid ID"
        else
        puts "Vaid ID"
        end
      end
    when "ADD SCHEDULE"
      puts "Enter User ID:"
      AddUserID = gets.to_i
      puts "Enter Lastname:"
      AddLastname = gets.chomp
      puts "Enter Firstname:"
      AddFirstname = gets.chomp
      puts "Enter Middlename:"
      AddMiddlename = gets.chomp
      puts "Enter Program:"
      AddProgram = gets.chomp
      puts "Enter Year:"
      AddYear = gets.chomp
      puts "Enter Section:"
      AddSection = gets.chomp
      puts "Borrowed equipment:"
      AddBorrowed = gets.chomp
      puts "Time (Borrowed):"
      AddTimeBorrowed = gets.chomp


      File.open("Data.txt", "w+") do |f|
      f.puts("UserID: #{AddUserID}")
      f.puts("Lastname: #{AddLastname}")
      f.puts("Firstname: #{AddFirstname}")
      f.puts("Middlename: #{AddMiddlename}")
      f.puts("Program #{AddProgram}")
      f.puts("Year: #{AddYear}")
      f.puts("Section: #{AddSection}")
      f.puts("Time(Borrowed): #{AddTimeBorrowed}")
      puts"Data Save"
    end
      else
        puts"Didnt understand command."
      end
    end
  when "VIEW SCHEDULE"
    #example : name : chuchu ganern
    File.open("Data.txt").each do |firstline|
      puts firstline
    end
    when "EXIT"
      puts "Goodbye."
    else
      puts"Didnt understand command."
    end
