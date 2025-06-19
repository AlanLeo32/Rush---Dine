extends Control
var catch_bar: ProgressBar
var timer_label: Label
var timeout_timer: Timer

var onCatch := false
var catchSpeed := 0.1
var catchingValue := 0.0
var gameEnded := false
var total_time = 10
var remaining_seconds: float
var cant_recurso: int

func _ready() -> void:
	catch_bar = %CatchBar  
	timer_label = $PanelContainer/MarginContainer/VBoxContainer/TimeoutTimer/TimerLabel
	timeout_timer = $PanelContainer/MarginContainer/VBoxContainer/TimeoutTimer
	timeout_timer.stop()
	timeout_timer.wait_time = total_time
	timeout_timer.timeout.connect(_on_timeout_timer_timeout)
	#timer_label.text = "Tiempo: %d" % total_time
	


func _physics_process(delta: float) -> void:
	timer_label.visible = true
	if gameEnded:
		return
	if timer_label and timeout_timer and not timeout_timer.is_stopped():
		remaining_seconds = timeout_timer.time_left
		timer_label.text = "Tiempo: %d" % remaining_seconds
	
			
	if onCatch: catchingValue += catchSpeed
	else: catchingValue -= catchSpeed

	if catchingValue < 0.0: catchingValue = 0
	elif catchingValue >= 100:
		cant_recurso = 1
		_game_end()

	catch_bar.value = catchingValue

func _game_end() -> void:
	if gameEnded:
		return
	gameEnded = true

	var tween = get_tree().create_tween()
			
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(self, "global_position", global_position + Vector2(0, 700), 0.5)

	await tween.finished

	get_tree().paused = false
	queue_free()
	var recurso = "pescado"
	ManejoMinijuegos.actualizar_recursos(recurso, cant_recurso)
	ManejoMinijuegos.volver_a_dia()

func _on_target_target_entered() -> void:
	onCatch = true

func _on_target_target_exited() -> void:
	onCatch = false


func _on_timeout_timer_timeout() -> void:
	if not gameEnded:
		cant_recurso = 0
		_game_end() # El jugador perdió porque se acabó el tiempo
