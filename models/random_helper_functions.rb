def set_user_to_agent
  f = File.open('/Users/amy/Documents/Migration/TripAdvisor/20140619_sample/my_mod/agents.txt','r')
  agent_list = []
  f.each do |u|
    agent_list << u.gsub("\n","")
  end

  puts "make sure these guys are all agents: #{agent_list}"
  puts "number in agent_list: #{agent_list.count}"

  count = 0

  agent_list.each do |e|
    count += 1
    a = User.find_by_email e
    if !a.nil?
      puts "#{count} -- user #{e} has type #{a.type}"

      # only work on it if it's an end user
      if a.type.nil?
        puts "are you sure you want to change user type to agent?"
        user_input = gets.chomp

        if (user_input.downcase == 'b' || user_input.downcase == 'break')
          break
        end

        if !(user_input.downcase == 'y' || user_input.downcase == 'yes')
          next
        end
        # go ahead and change user type
        a.type = "User::Agent"
        a.save!
        puts "user #{e} now has type #{a.type}"
      end
    else
      puts "#{count} -- cannot find user #{e}"
    end
  end
end


def set_light_agents_to_agents
  f = File.open('/Users/amy/Documents/Migration/TripAdvisor/20140619_sample/my_mod/lightagents.txt','r')
  lagent_list = []
  f.each do |u|
    lagent_list << u.gsub("\n","")
  end
  puts "number in lagent_list: #{lagent_list.count}"

  count = 0

  lagent_list.each do |e|
    count += 1
    a = User.find_by_email e
    if !a.nil?
      puts "#{count} -- user #{e} has type #{a.type}"

      # only work on it if it's an end user
      if a.type.nil?
        puts "are you sure you want to change user type to agent?"
        user_input = gets.chomp

        if (user_input.downcase == 'b' || user_input.downcase == 'break')
          break
        end

        if !(user_input.downcase == 'y' || user_input.downcase == 'yes')
          next
        end
        # go ahead and change user type
        a.type = "User::Agent"
        a.save!
        puts "user #{e} now has type #{a.type}"
      end
    else
      puts "#{count} -- cannot find user #{e}"
    end
  end
end