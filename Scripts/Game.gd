class_name Game
extends Node

signal level_changed()

var keyboard_mode: bool
var joypad_mode: bool

var panel: PackedScene
var game_started: bool
var ui: CanvasLayer
var tutorial_text_count: int = 0
var a_just_pressed: bool
var ui_panel: Control
var scene: int
var on_cutscene: bool
var scene_1_seen: bool
var on_ui: bool
@onready var level_manager: LevelManager = get_node("LevelManager")

func _ready():
	panel = preload("res://TSCN/UI/cannot_pick_trash.tscn")
	ui_panel = panel.instantiate()
	ui_panel.reason = "Olá LIMPA-I-989, seja bem vindo ao treinamento. "
	ui = get_node("/root/Game/UI")
	ui.add_child(ui_panel)
	Soundtrack.stream = preload("res://Assets/Audio/Stream Loops 2024-05-29.ogg")
	Soundtrack.play()

func _process(_delta):
	if !game_started:
		start_scene()
	if scene == 1 && !scene_1_seen:
		first_scene()
	if scene == 10:
		level_finished()
	if scene == 15:
		tutorial_can_buy()

func tutorial_can_buy():
	Input.action_press("Rise")
	on_cutscene = true
	if tutorial_text_count == 0:
		change_text("Note que a cada lixo que coletava, ganhou-se dinheiro.")
		a_just_pressed = false
		tutorial_text_count += 1
	elif a_just_pressed && tutorial_text_count == 1:
		change_text("Com essa quantia de dinheiro, você pode comprar um aprimoramento.")
		a_just_pressed = false
		tutorial_text_count += 1
	elif a_just_pressed && tutorial_text_count == 2:
		change_text("Você pode ir até o ponto de entrega de lixo para comprar um aprimoramento.")
		a_just_pressed = false
		tutorial_text_count += 1
	elif a_just_pressed && tutorial_text_count == 3:
		ui.get_node("CannotPickTrash").queue_free()
		tutorial_text_count = 0
		a_just_pressed = false
		scene = 0
		on_cutscene = false
		Input.action_release("Rise")

func level_finished():
	Input.action_press("Rise")
	on_cutscene = true
	match(level_manager.current_level):
		0:
			if tutorial_text_count == 0:
				change_text("Muito bem, ótimo trabalho.")
				tutorial_text_count += 1
				a_just_pressed = false
				pass
			if a_just_pressed && tutorial_text_count == 1:
				change_text("Vamos ver como se sai em um lago de verdade.")
				tutorial_text_count += 1
				a_just_pressed = false
				pass
			if a_just_pressed && tutorial_text_count == 2:
				ui.get_node("CannotPickTrash").queue_free()
				level_manager.load_level(preload("res://TSCN/Levels/level_1.tscn"), 35)
				tutorial_text_count = 0
				a_just_pressed = false
				scene = 0
				on_cutscene = false
				pass
		1:
			if tutorial_text_count == 0:
				change_text("Muito bem, ótimo trabalho.")
				tutorial_text_count += 1
				a_just_pressed = false
				pass
			if a_just_pressed && tutorial_text_count == 1:
				change_text("Vamos ver como se sai em um lago maior, com mais peixes, e maiores problemas.")
				tutorial_text_count += 1
				a_just_pressed = false
				pass
			if a_just_pressed && tutorial_text_count == 2:
				ui.get_node("CannotPickTrash").queue_free()
				level_manager.load_level(preload("res://TSCN/Levels/level_2.tscn"), 55)
				tutorial_text_count = 0
				a_just_pressed = false
				scene = 0
				on_cutscene = false
				pass
		2:
			level_manager.end_game()
	pass

func start_scene():
	on_cutscene = true
	Input.action_press("Rise")
	if a_just_pressed && tutorial_text_count == 0:
		change_text("Colete todos os lixos para começarmos o verdadeiro trabalho.")
		tutorial_text_count += 1
		a_just_pressed = false
		pass
	elif a_just_pressed && tutorial_text_count == 1:
		change_text("Você deve coletar e entregar os lixos sempre em um ponto específico. Neste caso, aqui mesmo.")
		tutorial_text_count += 1
		a_just_pressed = false
		pass
	elif a_just_pressed && tutorial_text_count == 2:
		change_text("Nos lagos de verdade, você deverá entregar nos pontos de coleta.")
		tutorial_text_count += 1
		a_just_pressed = false
		pass
	elif a_just_pressed && tutorial_text_count == 3:
		change_text("Quando você coletar todos os lixos, iremos para o próximo local.")
		a_just_pressed = false
		tutorial_text_count += 1
	elif a_just_pressed && tutorial_text_count == 4:
		change_text("Boa sorte!")
		a_just_pressed = false
		tutorial_text_count += 1
	elif a_just_pressed && tutorial_text_count == 5:
		ui.get_node("CannotPickTrash").queue_free()
		game_started = true
		tutorial_text_count = 0
		on_cutscene = false
		Input.action_release("Rise")

func first_scene():
	on_cutscene = true
	Input.action_press("Rise")
	if tutorial_text_count == 0:
		change_text("Note que agora estamos em um lago.")
		a_just_pressed = false
		tutorial_text_count += 1
	elif a_just_pressed && tutorial_text_count == 1:
		change_text("Haverão peixes aqui, tente não causar problemas.")
		a_just_pressed = false
		tutorial_text_count += 1
	elif a_just_pressed && tutorial_text_count == 2:
		change_text("Mas eles podem acabar vendo-o como comida. Tente não ser avistado.")
		a_just_pressed = false
		tutorial_text_count += 1
	elif a_just_pressed && tutorial_text_count == 3:
		change_text("Os peixes normalmente não chegam até a superficie, então use isso se precisar fugir.")
		a_just_pressed = false
		tutorial_text_count += 1
	elif a_just_pressed && tutorial_text_count == 4:
		a_just_pressed = false
		tutorial_text_count = 0
		ui.get_node("CannotPickTrash").queue_free()
		scene = 0
		on_cutscene = false
		scene_1_seen = true
		Input.action_release("Rise")

func cutscene():
	ui = get_node("/root/Game/UI")
	ui_panel = panel.instantiate()
	ui.add_child(ui_panel)

func change_text(reason: String):
	ui_panel = ui.get_node("CannotPickTrash/Background/Label")
	ui_panel.set_text(reason)

func _unhandled_key_input(event):
	if event is InputEventKey:
		if event.physical_keycode == KEY_A && event.is_pressed() && !a_just_pressed:
			a_just_pressed = true
		elif event.physical_keycode == KEY_A && event.is_pressed() && a_just_pressed:
			a_just_pressed = false

func _input(event):
	if event is InputEventMouse:
		keyboard_mode = true
		joypad_mode = false
	if event is InputEventKey:
		keyboard_mode = true
		joypad_mode = false
	if event is InputEventJoypadButton || event is InputEventJoypadMotion:
		joypad_mode = true
		keyboard_mode = false
	if event is InputEventJoypadButton && on_cutscene:
		if event.button_index == JOY_BUTTON_A && event.is_pressed() && !a_just_pressed:
			a_just_pressed = true
		elif event.button_index == JOY_BUTTON_A && event.is_pressed() && a_just_pressed:
			a_just_pressed = false


func _on_level_manager_level_completed():
	if level_manager.current_level == 0 || level_manager.current_level == 1:
		scene = 10
		cutscene()
	pass # Replace with function body.


func _on_level_manager_can_buy_something():
	scene = 15
	cutscene()
	pass # Replace with function body.
