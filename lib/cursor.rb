require "io/console"

KEYMAP = {
  " " => :space,
  "s" => :save,
  "\r" => :return,
  "\e[A" => :up,
  "\e[B" => :down,
  "\e[C" => :right,
  "\e[D" => :left,
  "\u0003" => :ctrl_c,
}

MOVES = {
  left: [0, -1],
  right: [0, 1],
  up: [-1, 0],
  down: [1, 0]
}

class Cursor

  attr_reader :cursor_pos, :board, :selected, :selected_pos

  def initialize(cursor_pos, board)
    @cursor_pos = cursor_pos
    @board = board
    @selected = false
    @selected_pos = nil
  end

  def get_input
    key = KEYMAP[read_char]
    handle_key(key)
  end

  def read_char
    STDIN.echo = false # stops the console from printing return values

    STDIN.raw! # in raw mode data is given as is to the program--the system
                 # doesn't preprocess special characters such as control-c

    input = STDIN.getc.chr # STDIN.getc reads a one-character string as a
                             # numeric keycode. chr returns a string of the
                             # character represented by the keycode.
                             # (e.g. 65.chr => "A")

    if input == "\e" then
      input << STDIN.read_nonblock(3) rescue nil # read_nonblock(maxlen) reads
                                                   # at most maxlen bytes from a
                                                   # data stream; it's nonblocking,
                                                   # meaning the method executes
                                                   # asynchronously; it raises an
                                                   # error if no data is available,
                                                   # hence the need for rescue

      input << STDIN.read_nonblock(2) rescue nil
    end

    STDIN.echo = true # the console prints return values again
    STDIN.cooked! # the opposite of raw mode :)

    return input
  end

  private

  def handle_key(key)
    case key
    when :ctrl_c
      exit 0
    when :save
      :save
    when :return, :space
      toggle_selected
      cursor_pos
    when :left, :right, :up, :down
        update_pos(MOVES[key])
        nil
    else
      puts key
    end
  end

  def update_pos(diff)
    new_pos = [cursor_pos[0] + diff[0], cursor_pos[1] + diff[1]]
    @cursor_pos = new_pos if board.valid_pos?(new_pos)
  end

  def toggle_selected
    if @selected == false
      @selected = true
      @selected_pos = cursor_pos
    else
      @selected = false
      @selected_pos = nil
    end
  end
end