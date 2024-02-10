require 'bundler'
Bundler.require

require_relative 'utils/setup_dll'
require_relative 'utils/helpers'

SCREEN_WIDTH = 1600
SCREEN_HEIGHT = 1000
DEG2RAD = Math::PI/180.0

# include Raylib

class Window
  include RLHelpers

  attr_accessor :camera

  def initialize
    @camera = Camera.new
            .with_position(0.0, 2.0, 4.0)
            .with_target(0.0, 2.0, 0.0)
            .with_up(0.0, 1.0, 0.0)
            .with_fovy(60.0)
            .with_projection(CAMERA_PERSPECTIVE)
  end

  def run
    set_target_fps(60)
    SetConfigFlags(FLAG_MSAA_4X_HINT)

    window(SCREEN_WIDTH, SCREEN_HEIGHT, "Maze") do
      disable_cursor
      # Main game loop
      @shader = LoadShader(nil, "assets/shaders/light.fs")

      until window_should_close? do # Detect window close button or ESC key
        update
        draw
      end
    end
  end

  def update
    update_camera(camera, CAMERA_FIRST_PERSON)
  end

  def draw_camera_state
    draw_rectangle(300, 5, 400, 80, fade(SKYBLUE, 0.5))
    draw_rectangle_lines(300, 5, 400, 80, BLUE)

    draw_text("Camera status:", 310, 15, 10, BLACK)
    draw_text("- Position: (#{camera.position.x}, #{camera.position.y}, #{camera.position.z})", 310, 30, 10, BLACK)
    draw_text("- Target: (#{camera.target.x}, #{camera.target.y}, #{camera.target.z})", 310, 45, 10, BLACK)
    draw_text("- Up: (#{camera.up.x}, #{camera.up.y}, #{camera.up.z})", 310, 60, 10, BLACK)
  end

  def draw_map
    rect_size = 250
    offset = 5
    draw_rectangle(offset, offset, rect_size, rect_size, fade(LIGHTGRAY, 0.7))
    DrawLine(offset, offset, rect_size+offset, offset, RED)
    DrawLine(offset, offset, offset, rect_size+offset, BLUE)
    DrawLine(rect_size+offset, offset, rect_size+offset, rect_size+offset, LIME)
    DrawLine(offset, rect_size+offset, rect_size+offset, rect_size+offset, GOLD)
    x = Remap(camera.position.x, -10, 10, offset, rect_size+offset)
    z = Remap(camera.position.z, -10, 10, offset, rect_size+offset)
    tx = Remap(camera.target.x, -10, 10, offset, rect_size+offset)
    tz = Remap(camera.target.z, -10, 10, offset, rect_size+offset)
    DrawCircle(x, z, 4, RED)
    DrawLine(x, z, tx, tz, RED)

    tar = Vector2Normalize(Vector2Subtract(Vector2.create(tx, tz), Vector2.create(x, z)))
    ang = Vector2Angle(tar, Vector2.create(1, 0)) / DEG2RAD
    DrawCircleSector(Vector2.create(x,z), 40, -30-ang, 30-ang, 6, fade(RED, 0.5))
  end

  def draw
    drawing do
      clear_background(BLACK)
      BeginShaderMode(@shader)
      mode_3d(camera) do
        # draw_plane(Vector3.create(0.0, 0.0, 0.0), Vector2.create(32.0, 32.0), LIGHTGRAY); # Draw ground
        draw_cube(Vector3.create(-10.0, 2.5, 0.0), 1.0, 5.0, 20.0, BLUE)           # Draw a blue wall
        draw_cube(Vector3.create(10.0, 2.5, 0.0), 1.0, 5.0, 20.0, LIME)            # Draw a green wall
        draw_cube(Vector3.create(0.0, 2.5, 10.0), 20.0, 5.0, 1.0, GOLD)            # Draw a yellow wall
        draw_cube(Vector3.create(0.0, 2.5, -10.0), 20.0, 5.0, 1.0, RED)            # Draw a yellow wall
        DrawGrid(20, 1.0)
      end
      EndShaderMode()

      draw_map
      draw_camera_state
    end
  end
end

Window.new.run
