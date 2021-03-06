require_relative 'shelves'
require_relative 'crate'

class SimpleWarehouse

  def run
    @live = true
    puts 'Type `help` for instructions on usage'
    while @live
      print '> '
      command = gets.chomp
      case command
        when 'help'
          show_help_message
        when /init\s(.*)\s(.*)/
          shelves = Shelves.new($1.to_i, $2.to_i)
        when /store\s(.*)\s(.*)\s(.*)\s(.*)\s(.)/
          store(shelves, $1.to_i, $2.to_i, $3.to_i, $4.to_i, $5)
        when /locate\s(.)/
          locate(shelves, $1)
        when /remove\s(.*)\s(.*)/
          remove(shelves, $1.to_i, $2.to_i)
        when 'view'
          view(shelves)
        when 'exit'
          exit
        else
          show_unrecognized_message
      end
    end
  end

  private

  def show_help_message
    puts 'help             Shows this help message
init W H         (Re)Initialises the application as a W x H warehouse, with all spaces empty.
store X Y W H P  Stores a crate of product number P and of size W x H at position X,Y.
locate P         Show a list of positions where product number can be found.
remove X Y       Remove the crate at positon X,Y.
view             Show a representation of the current state of the warehouse, marking each position as filled or empty.
exit             Exits the application.'
  end

  def show_unrecognized_message
    puts 'Command not found. Type `help` for instructions on usage'
  end

  def store(shelves, x, y, width, height, product_code)
    shelves.store(x, y, Crate.new(width, height, product_code))
  rescue => e
    puts e.message
  end

  def locate(shelves, product_code)
    shelves.locate(product_code).each do |position|
      print position
      puts "\n"
    end
  end

  def remove(shelves, x, y)
    shelves.remove(x, y)
  rescue => error
    puts error.message
  end

  def view(shelves)
    (shelves.height - 1).downto(0) do |i|
      0.upto(shelves.width - 1) do |j|
        print shelves.state[i][j]
      end
      puts "\n"
    end
  end

  def exit
    puts 'Thank you for using simple_warehouse!'
    @live = false
  end

end
