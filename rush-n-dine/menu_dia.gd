extends Node2D

var cantidad_acciones := [1,2,2,3,3,4,4]
var costo_apertura_por_mesas := [20,50,100, 150,200, 250,300]
@onready var panel_anuncio = $PanelAnuncioSimulado
@onready var boton_cerrar = $PanelAnuncioSimulado/BotonCerrar
var timer_anuncio: Timer = null
var tiempo_restante_anuncio := 10
var recompensa_pendiente := false

func _ready():
	if not DiaData.dia_iniciado:
		DiaData.dia_iniciado=true
		DiaData.acciones_disponibles = cantidad_acciones[Globales.mesas-1]
	elif DiaData.acciones_disponibles ==0:
		$TextureRect/BotonPesca.visible=false
		$TextureRect/BotonCosecha.visible=false
		$TextureRect/BotonDelivery.visible=false
		$TextureRect/BotonRuleta.visible=false
		$TextureRect/PanelAdvertencia.visible=true
		$TextureRect/PanelAdvertencia/BotonNoAbrir/Label2.text= "Evitaras abrir el restaurante esta noche\ndescontara de tu dinero: $" + str(costo_apertura_por_mesas[Globales.mesas-1])
		DiaData.bloqueoPesca=false
		DiaData.bloqueoCosecha=false
		DiaData.bloqueoRuleta=false
		DiaData.bloqueoDelivery=false
	if DiaData.bloqueoPesca:
		$TextureRect/BotonPesca.visible=false
	if DiaData.bloqueoCosecha:
		$TextureRect/BotonCosecha.visible=false
	if DiaData.bloqueoRuleta:
		$TextureRect/BotonRuleta.visible=false
	if DiaData.bloqueoDelivery:
		$TextureRect/BotonDelivery.visible=false
	
	var nodo = get_node("TextureRect/Panel/Reloj/ColorRect")
	var horas_a_pintar: int = cantidad_acciones[Globales.mesas - 1] * 2
	var angulo_inicio := 150
	var angulo_fin := 150+ (horas_a_pintar) * 30.0
	nodo.actualizar_sector(150, angulo_fin)
	var rotacion_en_grados : int = (cantidad_acciones[Globales.mesas - 1]-DiaData.acciones_disponibles)* 60.0
	var rotacion_en_radianes := deg_to_rad(240+rotacion_en_grados)
	$TextureRect/Panel/Reloj/Aguja.rotation = rotacion_en_radianes
	cargar_recursos()
	$TextureRect/Panel/CantidadDinero.text= "Dinero: $"+ str(Globales.dinero)


func _on_boton_tienda_pressed() -> void:
	DiaData.acciones_disponibles -= 1
	ManejoMinijuegos.abre_tienda()

func _on_boton_ruleta_pressed() -> void:
	DiaData.acciones_disponibles -= 1
	ManejoMinijuegos.minijuego_ruleta()

func _on_boton_cosecha_pressed() -> void:
	DiaData.acciones_disponibles -= 1
	ManejoMinijuegos.minijuego_verdura_random()

func _on_boton_pesca_pressed() -> void:
	DiaData.acciones_disponibles -= 1
	ManejoMinijuegos.minijuego_pescado()

func _on_boton_abrir_pressed() -> void:
	DiaData.dia_iniciado=false
	if DiaData.mejoranivel:
		Globales.mesas+=1
		DiaData.mejoranivel=false
	if DiaData.bajarnivel:
		Globales.mesas-=1
		DiaData.bajarnivel=false
	Globales.dia=false
	Globales.guardar_estado()
	get_tree().change_scene_to_file("res://noche.tscn")

func _on_boton_no_abrir_pressed() -> void:
	Globales.dinero-=costo_apertura_por_mesas[Globales.mesas-1]
	if DiaData.mejoranivel:
		Globales.mesas+=1
		DiaData.mejoranivel=false
	if DiaData.bajarnivel:
		Globales.mesas-=1
		DiaData.bajarnivel=false
	if Globales.dinero>=0:
		Globales.guardar_estado()
		DiaData.acciones_disponibles = cantidad_acciones[Globales.mesas-1]
		$TextureRect/BotonPesca.visible=true
		$TextureRect/BotonCosecha.visible=true
		$TextureRect/BotonDelivery.visible=true
		$TextureRect/BotonRuleta.visible=true
		$TextureRect/PanelAdvertencia.visible=false
		_ready()
	else:
		$TextureRect/PanelAdvertencia2.show()


func _on_boton_confirma_add_pressed() -> void:
	# Mostrar anuncio simulado y marcar recompensa pendiente
	recompensa_pendiente = true
	mostrar_anuncio_simulado()

func otorgar_recompensa():
	Globales.dinero=0
	Globales.guardar_estado()
	DiaData.acciones_disponibles = cantidad_acciones[Globales.mesas-1]
	$TextureRect/BotonPesca.visible=true
	$TextureRect/BotonCosecha.visible=true
	$TextureRect/BotonDelivery.visible=true
	$TextureRect/BotonRuleta.visible=true
	$TextureRect/PanelAdvertencia.visible=false
	$TextureRect/PanelAdvertencia2.visible=false
	_ready()

func _on_boton_pausa_pressed() -> void:
	var textura = $LogicaPausa/BotonPausa.texture_pressed
	if $LogicaPausa/MenuPausa.visible:
		$LogicaPausa/MenuPausa.visible=false
	else:
		$LogicaPausa/MenuPausa.visible=true
	$LogicaPausa/BotonPausa.texture_pressed= $LogicaPausa/BotonPausa.texture_normal
	$LogicaPausa/BotonPausa.texture_normal=textura 

func _on_configuracion_pressed() -> void:
	get_tree().change_scene_to_file("res://pantalla_configuracion.tscn")

func _on_menu_principal_pressed() -> void:
	get_tree().change_scene_to_file("res://menu_principal.tscn")

func cargar_recursos():
	for child in $TextureRect/Panel/ScrollRecursos/HBoxRecursos.get_children():
		child.queue_free()
	# Mostrar recursos
	for recurso_id in Globales.recursos_disponibles.keys():
		var recurso_data = Globales.recursos_disponibles[recurso_id]
		var cantidad_disponible = recurso_data["cantidad"]
		var recurso_item = preload("res://RecursoItemDia.tscn").instantiate()
		recurso_item.set_data(recurso_data, cantidad_disponible)
		$TextureRect/Panel/ScrollRecursos/HBoxRecursos.add_child(recurso_item)

func mostrar_anuncio_simulado():
	panel_anuncio.visible = true
	boton_cerrar.disabled = true
	tiempo_restante_anuncio = 10
	boton_cerrar.icon = null
	boton_cerrar.text = "Espera... 10s"
	# Ocultar UI principal
	$LogicaPausa/BotonPausa.visible = false
	$TextureRect/Panel/Reloj.visible = false

	# Si ya hay un timer, lo eliminamos
	if timer_anuncio:
		timer_anuncio.queue_free()
	timer_anuncio = Timer.new()
	timer_anuncio.wait_time = 1
	timer_anuncio.one_shot = false
	timer_anuncio.timeout.connect(_on_timer_anuncio_timeout)
	add_child(timer_anuncio)
	timer_anuncio.start()

func _on_timer_anuncio_timeout():
	tiempo_restante_anuncio -= 1
	if tiempo_restante_anuncio > 0:
		boton_cerrar.icon = null
		boton_cerrar.text = "Espera... " + str(tiempo_restante_anuncio) + "s"
	else:
		boton_cerrar.disabled = false
		boton_cerrar.icon = preload("res://Sprites/Cruz.png") # Cambia la ruta por la de tu ícono real
		boton_cerrar.text = ""
		timer_anuncio.stop()

func _on_boton_cerrar_anuncio():
	print("Botón cerrar presionado. Estado:", boton_cerrar.disabled, tiempo_restante_anuncio)
	if boton_cerrar.disabled or tiempo_restante_anuncio > 0:
		return # No hacer nada si no pasaron los 10 segundos o si el botón está deshabilitado
	panel_anuncio.visible = false
	# Volver a mostrar la UI principal
	$LogicaPausa/BotonPausa.visible = true
	$TextureRect/Panel/Reloj.visible = true

	if timer_anuncio:
		timer_anuncio.queue_free()
		timer_anuncio = null
	# Solo otorgar recompensa si estaba pendiente
	if recompensa_pendiente:
		recompensa_pendiente = false
		otorgar_recompensa()
