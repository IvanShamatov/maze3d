module RLHelpers
  include Raylib

  module_function

  def window(...)
    InitWindow(...)
    yield if block_given?
    CloseWindow()
  end

  def drawing(...)
    BeginDrawing(...)
    yield if block_given?
    EndDrawing()
  end

  def mode_3d(...)
    BeginMode3D(...)
    yield if block_given?
    EndMode3D()
  end

  def window_should_close?(...) = WindowShouldClose(...)
  def disable_cursor(...) = DisableCursor(...)
  def is_key_pressed(...) = IsKeyPressed(...)
  def update_camera(...) = UpdateCamera(...)
  def fade(...) = Fade(...)
  def clear_background(...) = ClearBackground(...)
  def set_target_fps(...) = SetTargetFPS(...)
  def set_config_flags(...) = SetConfigFlags(...)

  def draw_text(...) = DrawText(...)
  def draw_cube(...) = DrawCube(...)
  def draw_cube_wires(...) = DrawCubeWires(...)
  def draw_rectangle(...) = DrawRectangle(...)
  def draw_rectangle_lines(...) = DrawRectangleLines(...)
  def draw_plane(...) = DrawPlane(...)

  def camera_yaw(...) = CameraYaw(...)
  def camera_pitch(...) = CameraPitch(...)
end
