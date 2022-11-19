# require 'pry-byebug'
# Knight object
class Knight
    attr_accessor :knight_location, :moves, :next_moves

    def initialize(knight_location)
        @knight_location = knight_location
        @moves = possible_moves(knight_location)
        @next_moves = []
    end
    # create possible moves from the node loacations.
    def possible_moves(knight_location, record = [])
        moves = [[-1, -2], [1, 2], [-1, 2], [1, -2], [-2, -1], [2, 1], [-2, 1], [2, -1]]
        moves.each do |move|
            x = knight_location[0] + move[0]
            y = knight_location[1] + move[1]
            record << [x, y] if x.between?(0, 7) && y.between?(0, 7)
        end
        record
    end
end


# board game
class Board
  # pass in knights starting position and final position to output 
  # minimum moves to reach the location
  def knight_moves(start, final_dest)
      @horse_loc = Knight.new(start)
      create_head_array(final_dest)
      path = find_path(final_dest)
      puts "It took you #{path.size - 1} moves:"
      path.reverse.each_with_index { |move, inx| puts "#{inx}: #{move}"}
  end
  
  # Create nodes for mossible moves if the move do not equal to final destination.
  def create_head_array(final_dest, queue = [@horse_loc], inx = 0)
      # select the Node where the knight can make moves
      present_horse = queue[inx]
      create_sub_array(present_horse)
      # append created nodes to queue
      present_horse.next_moves.each do |child|
          next if queue.include?(child)
          queue << child
      end
      # return if a node is equal to the final destination
      return if present_horse == find_child(final_dest)
      return if inx >=65

      inx += 1
      create_head_array(final_dest, queue, inx)
  end
  # create nodes for the possible moves
  def create_sub_array(present_horse)
      present_horse.moves.each do |move|
          child = find_child(move).nil? ? Knight.new(move) : find_child(move)
          present_horse.next_moves << child
      end
  end
  # search for a match to final destination
  def find_child(move, queue = [@horse_loc], inx = 0)
      found_knight = nil
      present_horse = queue[inx]
      return if present_horse.nil?
      present_horse.next_moves.each do |child|
          queue << child unless queue.include?(child)
          found_knight = child if child.knight_location == move
      end
      return found_knight unless found_knight.nil?
      inx += 1
      find_child(move, queue, inx)
  end

  # Create the path that was taken to reach the final destination
  def find_path(final_dest, path = [final_dest])
      parent = find_parent(final_dest)
      path << parent.knight_location
      return path if @horse_loc == parent
      find_path(parent.knight_location, path)
  end


  def find_parent(final_dest, queue = [@horse_loc], inx = 0)
      # binding.pry
      present_horse = queue[inx]
      parent = present_horse.moves.any?(final_dest)
      return if present_horse.nil?
      return present_horse if parent == true
      present_horse.next_moves.each do |child|
        queue << child unless queue.include?(child)
      end
      inx += 1
      find_parent(final_dest, queue, inx)
  end
end









  
  game = Board.new
  game.knight_moves([2, 1], [1, 0])
  puts ''
  game.knight_moves([0, 0], [3, 3])
  puts ''
  game.knight_moves([0, 0], [7, 7])
  