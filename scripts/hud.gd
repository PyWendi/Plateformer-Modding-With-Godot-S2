@tool
extends CanvasLayer

@onready var ending_labels = {
	Global.Endings.WIN: %WinEnding,
	Global.Endings.LOSE: %LoseEnding,
}

@onready var quit_button = %QuitButton
@onready var restart_button = %RestartButton


func _process(_delta):
	%TimeLeft.text = "%.1f" % Global.timer.time_left


func _ready():
	set_process(false)
	set_physics_process(false)
	
	hide_ending_button()
	
	%Keys.visible = false
	Global.lives_changed.connect(_on_lives_changed)
	# Check the change in the keys
	Global.keys_collected.connect(_keys_collected)
	Global.keys_used.connect(_keys_used)

	if Engine.is_editor_hint():
		return

	Global.coin_collected.connect(_on_coin_collected)
	Global.game_ended.connect(_on_game_ended)
	Global.timer_added.connect(_on_timer_added)

	Input.joy_connection_changed.connect(_on_joy_connection_changed)
	if DisplayServer.is_touchscreen_available():
		%Start.hide()
		hide_ending_button()
		Global.game_started.emit()


func _on_joy_connection_changed(index: int, connected: bool):
	match index:
		0:
			%PlayerOneJoypad.visible = connected
		1:
			%PlayerTwoJoypad.visible = connected


func _unhandled_input(event):
	if (
		(
			event is InputEventKey
			or event is InputEventJoypadButton
			or event is InputEventJoypadMotion
			or event is InputEventScreenTouch
		)
		and %Start.is_visible_in_tree()
	):
		%Start.hide()
		hide_ending_button()
		
		Global.game_started.emit()


func _on_coin_collected():
	set_collected_coins(Global.coins)


func set_collected_coins(coins: int):
	#%CollectedCoins.text = "Coins: " + str(coins)
	%CollectedCoins.text = str(coins)


func _on_timer_added():
	%TimeLeft.visible = true
	set_process(true)


func _on_lives_changed():
	set_lives(Global.lives)


func set_lives(lives: int):
	%Lives.offset_right = %Lives.offset_left + lives * %Lives.texture.get_width()


func _on_game_ended(ending: Global.Endings):
	ending_labels[ending].visible = true
	show_ending_button()

func _keys_collected():
	%Keys.visible = true

func _keys_used():
	%Keys.visible = false

func _quit_game():
	get_tree().quit()
	
func _restart_game():
	# Trigger the restart button to global script
	Global._restart_the_game()

func show_ending_button():
	restart_button.show()
	quit_button.show()

func hide_ending_button():
	restart_button.hide()
	quit_button.hide()
