extends Node2D

var manteniendo_suma := false
var manteniendo_resta := false

var _tiempo := 0.0
var _hold_time_suma := 0.0
var _hold_time_resta := 0.0

var _intervalo_base := 0.3
var _intervalo_actual := _intervalo_base

var _factor_incremento := 1  # cuánto se suma por paso

var iniciada=false


@export var _roullete_initial_speed: float = 1000.0  # velocidad inicial real
@export var _deceleration_rate: float = 150.0         # más alto = frena más rápido
@export var _min_speed_threshold: float = 10.0        # debajo de esto se frena
@export var apuesta: int = 0

var _roullete_speed: float = 0.0
var _can_move_roullete: bool = false
var _selected_area: Area2D = null
var _extra_rotation: float = 0.0

# Multiplicadores por nombre de área
var efectos_ruleta := {
	"1": 10,
	"2": 0,
	"3": 3,
	"4": 1,
	"5": 0,
	"6": 2,
	"7": 5,
	"8": 0,
	"9": 1,
	"10": 3,
	"11": 0,
	"12": 2
}

func _ready():
	randomize()
	# Colocar texto en cada label de cada sector
	for area in $SpriteRuleta.get_children():
		if area is Area2D and efectos_ruleta.has(area.name):
			var multiplicador = efectos_ruleta[area.name]
			for child in area.get_children():
				if child is Label:
					child.text = "x" + str(multiplicador)


func _process(delta: float) -> void:
	$Saldo.text="Saldo: $"+str(Globales.dinero)
	$Panel/Apuesta.text="$"+str(apuesta)

	if manteniendo_suma:
		_hold_time_suma += delta
		_tiempo += delta

		# Aceleración progresiva: cada segundo baja el intervalo y sube el factor
		if int(_hold_time_suma) % 1 == 0:
			_intervalo_actual = max(0.05, _intervalo_base - (_hold_time_suma * 0.05))
			_factor_incremento = 1 + int(_hold_time_suma / 1.5)

		if _tiempo >= _intervalo_actual:
			apuesta += _factor_incremento
			_tiempo = 0.0

	elif manteniendo_resta:
		_hold_time_resta += delta
		_tiempo += delta

		if int(_hold_time_resta) % 1 == 0:
			_intervalo_actual = max(0.05, _intervalo_base - (_hold_time_resta * 0.05))
			_factor_incremento = 1 + int(_hold_time_resta / 1.5)

		if _tiempo >= _intervalo_actual:
			apuesta = max(0, apuesta - _factor_incremento)
			_tiempo = 0.0

	else:
		# Reset si no se mantiene nada
		_hold_time_suma = 0.0
		_hold_time_resta = 0.0
		_intervalo_actual = _intervalo_base
		_factor_incremento = 1
		_tiempo = 0.0
	if _can_move_roullete:
		if _roullete_speed > 0:
			_speed_up_roullete(delta)
			# Aplicar desaceleración
			_roullete_speed -= _deceleration_rate * delta

			# Forzar parada si es muy baja
			if _roullete_speed < _min_speed_threshold:
				_roullete_speed = 0
		else:
			_can_move_roullete = false
			_aplicar_resultado()


func _speed_up_roullete(delta: float):
	$SpriteRuleta.rotation_degrees += _roullete_speed * delta


func _start_roullete() -> void:
	_roullete_speed = _roullete_initial_speed
	_selected_area = null
	_can_move_roullete = true

	# Reset colisiones (por si estaban desactivadas)
	for node in $SpriteRuleta.get_children():
		for child in node.get_children():
			if child is CollisionPolygon2D:
				child.disabled = false

	# Rota aleatoriamente desde una posición inicial
	_extra_rotation = randf_range(0.0, 360.0)
	$SpriteRuleta.rotation_degrees = _extra_rotation


func _on_AreaManecilla_area_entered(area: Area2D) -> void:
	_selected_area = area

func _aplicar_resultado():
	if _selected_area:
		var nombre = _selected_area.name
		if efectos_ruleta.has(nombre):
			var multiplicador = efectos_ruleta[nombre]
			var ganancia = apuesta * multiplicador
			Globales.dinero += ganancia
			if(ganancia==0):
				$PanelNotificacion/LabelResultado.text= "¡Buen intento!
				Suerte la proxima"
			else:
				$PanelNotificacion/LabelResultado.text= "¡Ganaste! Premio: $" + str(ganancia)
		$PanelNotificacion.visible=true
	iniciada=false

func _on_button_button_downSUMA() -> void:
	apuesta += 1
	manteniendo_suma = true

func _on_button_button_upSUMA() -> void:
	manteniendo_suma = false

func _on_button_button_downRESTA() -> void:
	if apuesta >0:
		apuesta -= 1
	manteniendo_resta = true

func _on_button_button_upRESTA() -> void:
	manteniendo_resta = false

func _on_boton_inicia_pressed() -> void:
	if apuesta<=Globales.dinero :
		if not (iniciada) and 0<apuesta :
			Globales.dinero-=apuesta
			iniciada=true
			_start_roullete()
	else:
		$ErrorPopup.show()


func _on_cancelar_pressed() -> void:
	if not iniciada:
		get_tree().change_scene_to_file("res://MenuDia.tscn")


func _on_boton_confirma_pressed() -> void:
	$PanelNotificacion.visible=false
