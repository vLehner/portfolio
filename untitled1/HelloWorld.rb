#GLOBAL VARIABLES
#  Global variables are declared with a $ character.

$name = ""

$creature = Array ["Tarrasque", "Fairy", "Gnome", "Orc", "Goblin", "Hobgoblin",
                   "Lich", "Werewolf", "Jackal", "Kobold", "Grung", "Troglodyte", "Skeleton",
                   "Wyrmling", "Dragon", "Imp", "Centaur", "Gargoyle", "Basilisk", "Scion",
                   "Minotaur", "Mummy", "Banshee", "Gorgon", "Troll", "Wraith", "Chimera",
                   "Cyclops", "Drow", "Oni"]
$item = Array ["Claw", "Blood", "Horn", "Hoof", "Eye", "Sword", "Shield", "Soul",
               "Leg", "Arm", "Head", "Scale", "Skin", "Stew", "Brain", "Wing",
               "Husk", "Antenna", "Tail", "Tooth", "Gold", "Dagger", "Bow", "Axe",
               "Armor", "Quiver", "Poop"]
$action = Array["killed", "slayed", "stomped", "smashed", "decapitated", "defeated", "dueled",
                "destroyed", "befriended", "placated", "danced with", "exorcised", "exercised with", "enthralled"]

$charRace = ""
$races = Array ["Erhan", "Eastern Dwarf", "Neo-Bay Elf", "Forest Sage",
                "Old-Order Elf", "Plains Walker", "Skel-tal", "Night Goblin", "Horse",
                "Child of the Mist", "Emancipated Necrophage", "Land Squid", "Cat Girl",
                "Nowhere Man", "Starman", "Canadiadian", "*ROLL*"]
$charClass = ""
$classes = Array ["Druid", "Ranger", "Mage", "Rogue", "Warlock", "Cleric",
                  "Paladin", "Monk", "Horse", "*ROLL*"]

$stat = Array[]
$statName = Array["Strength", "Dexterity", "Willpower", "Intelligence",
                  "Ensorcellment", "Luck"]

$numEvents = 0
$entryNum = 1
$EVENT_CAP = 5
$eventLog = Array[]
$logWidth = 0

$lvl = 1
$curXP = 0
$maxXP = 10
$g = 0

$bag = Array[]
$CARRY_CAP = 20

# chooseRace -
#  allows the player to choose their race, or ROLL for a random race. Race has no bearing on ability,
#  and is completely cosmetic.
def chooseRace

  textBox 1, "~ Races of Akanna ~"

  for i in 1..$races.length
    print "#{i}). #{$races[i-1]}\n"
  end

  print "\nEnter the number of your race: "
  n = gets.chomp.to_i - 1

  #If roll, choose a random race not including roll.
  if (n >= $races.length - 1)
    n = rand($races.length-2)
  end

  $charRace = $races[n]
end

#chooseClass -
# allows the player to pick a specific class. Class has no bearing on ability either :P
def chooseClass

  textBox 1, "~ Classes of Akanna ~"

  for i in 1..$classes.length
    print "#{i}). #{$classes[i-1]}\n"
  end

  print "\nEnter the number of your class: "
  n = gets.chomp.to_i - 1
  if (n >= $classes.length - 1)
    n = rand($classes.length-2)
  end
  $charClass = $classes[n]
end

#statRoll -
# The player decides their stats here.
def statRoll
  for i in 1..$statName.length()
    $stat[i-1] = (rand(20))
  end
  textBox 1, "YOUR STATS: "
  for j in 0..($stat.length-1)
    puts $statName[j].to_s + ": " + $stat[j].to_s
  end
  textBox 1, "Do you want to re-roll your stats? (Y or N) "
  choice = gets.chomp
  if choice == "Y" or choice == "y"
    system("cls")
    statRoll()
  end
end
#encounter -
# Creates an encounter, and randomized loot using global arrays.
def encounter
  enemy = $creature[rand($creature.length)]
  object = $item[rand($item.length)]
  item = "#{enemy} #{object}"
  str = "~   Entry ##{$entryNum}- You #{$action[rand($action.length)]} a " + (enemy.to_s) + ", and received a "+ (item.to_s) + "."
  $entryNum = $entryNum + 1
  if(str.length > $logWidth) #Increase max log width. Shouldn't ever have to decrease??
    $logWidth = str.length
  end
  $curXP += 2
  $bag << item #Ruby arrays are DYNAMIC. Add elements using the << operator.

  #The eventLog at most displays the last $EVENT_CAP encounters. (For window formatting purposes.)
  if($numEvents < $EVENT_CAP)
    $eventLog << str
    $numEvents = $numEvents + 1 # NO ++ OPERATOR?? D:
  else
    $eventLog.delete_at(0) #Shift up and add new event.
    $eventLog << str
  end

  #DEV SHITE: print "eventLog length: #{$eventLog.length} event_cap: #{$EVENT_CAP} numEvents: #{$numEvents} \n"

  #Print last $EVENT_CAP encounters.
  #for i in 0..$logWidth
  #  print "~"
  #end
  print "\n"
  print " ~ QUEST LOG: \n"
  for i in 0..$EVENT_CAP-1
    print "#{$eventLog[i]} \n"
  end
  #for i in 0..$logWidth
  #  print "~"
  #end
  print "\n"
end

#display Inventory
#  Prints the players current inventory, organized in a box.
def displayInventory
  for i in 0..70
    print "@"
  end
  print "\n@ #{$name}'s INVENTORY: \n@"
  for i in 0..$CARRY_CAP
    if i > 1 and i % 4 == 0 ##Rows of 4
      print "\n@"
    end
    print "  %-13s " % $bag[i]
  end
  print "\n@"
  for i in 0..70
    print "@"
  end
  print "\n"
end

#market
# The player takes a break from battle to visit the market. Their inventory items are sold for gold.
# Ideally in the future, the market will by dynamic. (Different objects are worth a certain amount.
# Different typings will act as multipliers for gold.) For now though, I guess Akanna is communist
# or something and everybody makes the same amount of gold regardless of the quality of work they do.
def market
  print " %%%%%%%%%%%%%%%%%%%%%%%%%%%%\n"
  print " %% WELCOME TO THE MARKET! %%\n"
  print " %%%%%%%%%%%%%%%%%%%%%%%%%%%%\n\n"
  ttl = 0
  for i in 0..$CARRY_CAP-1
    amt = 10 + rand($stat[5])
    print "#{$name} sold their #{$bag[i]} and got #{amt} gold!\n"
    ttl = ttl + amt
    $g = $g + amt
    sleep(0.5)
  end
  $bag.clear
  print "\n #{$name} received #{ttl} gold in total!\n"
end

#lvlup -
# when a predetermined amount of xp is hit the character levels up and
# gets a stat boost
def lvlUp
  print "\n"
  $lvl += 1
  r = rand(6)
  textBox 1, "#{$name} has leveled up! #{$statName[r]} increased: #{$stat[r]} -> #{$stat[r] + 1}!"
  $stat[r] += 1
  $curXP = 0
  $maxXP = ($maxXP * (2 - $stat[3] / 21)).floor(0)
  print"\n"
end
# game-
# this is the main game loop that will run forever
def game
  sleep(3)
  system("cls")
  if($bag.length > $CARRY_CAP - 1)
    statBox()
    market()
    game()
  elsif ($curXP < $maxXP) #Ruby has wonky else-ifs.
    statBox()
    encounter()
    displayInventory()
    game()
  else
    statBox()
    lvlUp()
    game()
  end
end
#textBox - Prints a string in a pretty text box. Type 0 is for dialogue. Type 1 is for instruction.
#Ruby does not have parameter types.
# It is up to the programmer to ensure the correct type is being passed within the body of the function.
def textBox(type, str)

  case type
  when 0
    t = '~'
  when 1
    t = '#'
  end

  for i in 0..str.length+5
    print t
  end
  print "\n#{t}#{t} #{str} #{t}#{t}\n"
  for i in 0..str.length+5
    print t
  end
  print "\n\n"
  sleep(1)
end

#statBox -
# formats the name, race, class, level, experience, and gold of the character
# and outputs it
def statBox
  header1 = "NAME: #{$name}  RACE: #{$charRace}   CLASS: #{$charClass}"
  header2 = "Level: #{$lvl}   Experience: #{$curXP} / #{$maxXP}   GOLD: #{$g}"
  if header1.length > header2.length
    headerLength = header1.length
  else
    headerLength = header2.length
  end

  for i in 0..headerLength+5
    print "*"
  end
  print"\n** #{header1} \n"
  print"** #{header2} \n**\n"
  for j in 0..($stat.length-1)
    puts "** " + $statName[j].to_s + ": " + $stat[j].to_s
  end
  for i in 0..headerLength+5
    print "*"
  end
  print"\n"
end

#main -
# Main program execution goes here.
def main()
  textBox 0, "Greetings Chosen One. What is your name?"
  $name = gets.chomp
  system("cls")
  textBox 0, "Very well, #{$name}. And what is your race?"
  chooseRace()
  system("cls")
  textBox 0, "A #{$charRace}? Interesting..."
  textBox 0, "And what do you do for a living, #{$name}?"
  chooseClass()
  system("cls")
  textBox 0, "So you are a #{$charClass.upcase} #{$charRace}? Quite the profession."
  textBox 0, "Let us decide which powers we shall imbue you with, hero..."
  statRoll()
  system("cls")
  textBox 0, "You are ready to embark on your quest. Do not lose faith, #{$name}."
  sleep(3)
  game()
end

main()
