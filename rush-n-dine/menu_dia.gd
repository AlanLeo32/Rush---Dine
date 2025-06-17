extends Node2D

var cantidad_acciones := [1,2,3,3,4,4,4]
var costo_apertura_por_mesas := [20,50,100, 150,200, 250,300]

func _ready():
	if not DiaData.dia_iniciado:
		DiaData.dia_iniciado=true
		DiaData.acciones_disponibles = cantidad_acciones[Globales.mesas-1]
	elif DiaData.acciones_disponibles ==0:
		$TextureRect/BotonPesca.visible=false
		$TextureRect/BotonCosecha.visible=false
		$TextureRect/BotonTienda.visible=false
		$TextureRect/BotonMinijuego3.visible=false
		$TextureRect/PanelAdvertencia.visible=true
		$TextureRect/PanelAdvertencia/BotonNoAbrir/Label2.text= "Evitaras abrir el restaurante esta noche
descontara de tu dinero: $" + str(costo_apertura_por_mesas[Globales.mesas-1])
		
	var nodo = get_node("TextureRect/Panel/Reloj/ColorRect")
	var hora_inicio := 8
	var horas_a_pintar: int = cantidad_acciones[Globales.mesas - 1] * 2
	var angulo_inicio := 150
	var angulo_fin := 150+ (horas_a_pintar) * 30.0
	nodo.actualizar_sector(150, angulo_fin)
	nodo._draw()
	var rotacion_en_grados : int = (cantidad_acciones[Globales.mesas - 1]-DiaData.acciones_disponibles)* 60.0
	var rotacion_en_radianes := deg_to_rad(240+rotacion_en_grados)
	$TextureRect/Panel/Reloj/Aguja.rotation = rotacion_en_radianes
	cargar_recursos()
	$TextureRect/Panel/CantidadDinero.text= "Dinero: $"+ str(Globales.dinero)


func _on_boton_tienda_pressed() -> void:
	DiaData.acciones_disponibles -= 1
	#cambio de escena minijuego, el minijuego para volver solo tiene que llamar a esta escena (antes tiene que modificar los recursos segun el que afecte... verdura o pescado)
	_ready() #cuando se conecte el minijuego sacar esto...

func _on_boton_ruleta_pressed() -> void:
	DiaData.acciones_disponibles -= 1
	#cambio de escena minijuego, el minijuego para volver solo tiene que llamar a esta escena (antes tiene que modificar los recursos segun el que afecte... verdura o pescado)
	_ready() #cuando se conecte el minijuego sacar esto...

func _on_boton_cosecha_pressed() -> void:
	DiaData.acciones_disponibles -= 1
	#cambio de escena minijuego, el minijuego para volver solo tiene que llamar a esta escena (antes tiene que modificar los recursos segun el que afecte... verdura o pescado)
	_ready() #cuando se conecte el minijuego sacar esto...

func _on_boton_pesca_pressed() -> void:
	DiaData.acciones_disponibles -= 1
	#cambio de escena minijuego, el minijuego para volver solo tiene que llamar a esta escena (antes tiene que modificar los recursos segun el que afecte... verdura o pescado)
	_ready() #cuando se conecte el minijuego sacar esto...

func _on_boton_abrir_pressed() -> void:
	DiaData.dia_iniciado=false
	Globales.dia=false
	Globales.guardar_estado()
	get_tree().change_scene_to_file("res://noche.tscn")

func _on_boton_no_abrir_pressed() -> void:
	Globales.dinero-=costo_apertura_por_mesas[Globales.mesas-1]
	if Globales.dinero>=0:
		Globales.guardar_estado()
		DiaData.acciones_disponibles = cantidad_acciones[Globales.mesas-1]
		$TextureRect/BotonPesca.visible=true
		$TextureRect/BotonCosecha.visible=true
		$TextureRect/BotonTienda.visible=true
		$TextureRect/BotonMinijuego3.visible=true
		$TextureRect/PanelAdvertencia.visible=false
		_ready()
	else:
		$TextureRect/PanelAdvertencia2.show()


func _on_boton_confirma_add_pressed() -> void:
	
	#logica para mostrar el anuncio
	
	Globales.dinero=0
	Globales.guardar_estado()
	DiaData.acciones_disponibles = cantidad_acciones[Globales.mesas-1]
	$TextureRect/BotonPesca.visible=true
	$TextureRect/BotonCosecha.visible=true
	$TextureRect/BotonTienda.visible=true
	$TextureRect/BotonMinijuego3.visible=true
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
