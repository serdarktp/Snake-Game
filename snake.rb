# coding : UTF-8

require 'ruby2d'

set width: 640, height: 400, title: "Snake", diagnostics: true, fps_cap: 20 , background: 'navy'

GRID_SIZE = 20
GRID_WIDTH = Window.width / GRID_SIZE
GRID_HEIGHT = Window.height / GRID_SIZE


class Snake
  attr_writer :direction

  def initialize
    @positions = [[0,Window.height/40], [1,Window.height/40], [2, Window.height/40], [3, Window.height/40]]
    @direction = 'right'
    @growing = false
    
  end

  def draw
    @positions.each do |i|
      Square.new(x: i[0] * GRID_SIZE, y: i[1]  * GRID_SIZE, size:GRID_SIZE - 1, color: 'yellow' )
    end

  end

  
  def move
    #groving snake
    unless @growing
      @positions.shift
    end

    #moving snake
    case @direction
    when 'down'
      @positions.push(new_coords(head[0], head[1] +1 ))
    when 'up'
      @positions.push(new_coords(head[0], head[1] -1 ))
    when 'left'
      @positions.push(new_coords(head[0] -1, head[1] ))
    when 'right'
      @positions.push(new_coords(head[0] +1, head[1] ))
    end

    @growing = false

  end


  def new_coords(x,y)
    [x % GRID_WIDTH,y % GRID_HEIGHT]
  end

  def can_change_direction_to?(new_direction)
    case @direction
    when 'up'   then new_direction != 'down'
    when 'down' then new_direction != 'up'
    when 'left' then new_direction != 'right'
    when 'right' then new_direction != 'left'
    end

  end

  def grow
    @growing = true
  end

  # x coordinate of snake's head
  def x
    head[0]
  end

  # y coordinate of snake's head
  def y
    head[1]
  end

  # head coordinates of snake
  def head
    @positions.last
  end


  def hit_itself?
    @positions.size != @positions.uniq.size
  end

end


class Game

  def initialize
    @points = 0
    @finished = false

    @food_X = rand(GRID_WIDTH)
    @food_Y = rand(GRID_HEIGHT)
  end


  def draw
    unless @finished
      Square.new(x: @food_X * GRID_SIZE, y: @food_Y * GRID_SIZE, size: GRID_SIZE, color: 'red')
    end
    Text.new(game_text, x: 10, y: 10)

  end



  def snake_eat_food?(x,y)
    @food_X == x && @food_Y == y
  end


  def record_hit
    @points += 1
    @food_X = rand(GRID_WIDTH)
    @food_Y = rand(GRID_HEIGHT)

  end

  def game_text()
    if is_finish?
      @game_text = "Game over. Your score is : #{@points} Press 'R' to restart, 'Q' to quit"
    else
      @game_text = "Score : #{@points}"
    end

  end

  def is_finish?
    @finished
  end

  def finish
    @finished = true
  end


end


snake = Snake.new
game = Game.new

update do
  clear

  unless game.is_finish?
    snake.move
  end

  snake.draw
  game.draw

  if game.snake_eat_food?(snake.x, snake.y)
    game.record_hit
    snake.grow
  end


  if snake.hit_itself?
    game.finish
  end


end



on :key_down do |event|
  if ['down', 'up', 'left', 'right'].include?(event.key)
    if snake.can_change_direction_to?(event.key)
      snake.direction = event.key
    end
  end

  if game.is_finish?
    if event.key.downcase == 'r'
      snake = Snake.new
      game = Game.new
    elsif event.key.downcase == 'q'
      exit
    end
  end
end


show



