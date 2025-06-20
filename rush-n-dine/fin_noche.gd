extends Node2D
# --- BLOQUE ANUNCIO SIMULADO ---
@onready var panel_anuncio = $PanelAnuncioSimulado
@onready var boton_cerrar = $PanelAnuncioSimulado/BotonCerrar
var timer_anuncio: Timer = null
var tiempo_restante_anuncio := 10
var recompensa_pendiente := false
# --- FIN BLOQUE ANUNCIO SIMULADO ---
var costo_apertura_por_mesas := {
	1: 30,
	2: 75,
	3: 150,
	4: 250,
	5: 340,
	6: 475,
	7: 550
}

# Factores que afectan reputación por nivel (pesos por evento)
# Se espera que todos los valores sumen a un rango lógico (-100 a 100)
var factores_reputacion := {
	"1": {
		"atendidos": 5.0,
		"aguas_servidas": -1.0,
		"no_atendidos": -4.0,
		"entregas_erroneas": -6.0
	},
	"2": {
		"atendidos": 4.5,
		"aguas_servidas": -0.9,
		"no_atendidos": -3.6,
		"entregas_erroneas": -5.4
	},
	"3": {
		"atendidos": 4.0,
		"aguas_servidas": -0.8,
		"no_atendidos": -3.2,
		"entregas_erroneas": -4.8
	},
	"4": {
		"atendidos": 3.5,
		"aguas_servidas": -0.7,
		"no_atendidos": -2.8,
		"entregas_erroneas": -4.2
	},
	"5": {
		"atendidos": 3.0,
		"aguas_servidas": -0.6,
		"no_atendidos": -2.4,
		"entregas_erroneas": -3.6
	},
	"6": {
		"atendidos": 2.5,
		"aguas_servidas": -0.5,
		"no_atendidos": -2.0,
		"entregas_erroneas": -3.0
	},
	"7": {
		"atendidos": 2.0,
		"aguas_servidas": -0.4,
		"no_atendidos": -1.6,
		"entregas_erroneas": -2.4
	}
}




func _ready():
	for n in $TextureRect/Panel.get_children():
		n.hide()
	mostrar_resultado()


func mostrar_resultado():
	var pesos: Dictionary = factores_reputacion.get(str(Globales.mesas), {})
	# Mostrar título
	$TextureRect/Panel/Titulo.show()
	await get_tree().create_timer(0.5).timeout

	# Mostrar subtítulos
	$TextureRect/Panel/LabelDinero.show()
	$TextureRect/Panel/LabelReputacion.show()
	$TextureRect/Panel/CantDinero.text = "$" + str(Globales.dinero)
	$TextureRect/Panel/CantReputacion.text = Globales.reputacion_categoria + ", %" + str(Globales.reputacion_progreso)
	$TextureRect/Panel/CantDinero.show()
	$TextureRect/Panel/CantReputacion.show()
	
	
	await get_tree().create_timer(0.4).timeout

	# Mostrar elementos intermedios
	$TextureRect/Panel/LabelGanancia.show()
	$TextureRect/Panel/CantGanancia.text = str(NocheData.dinero_ganado)
	$TextureRect/Panel/CantGanancia.show()

	await get_tree().create_timer(0.3).timeout

	$TextureRect/Panel/LabelCosto.show()
	$TextureRect/Panel/CantCosto.text = str(costo_apertura_por_mesas[Globales.mesas])  # ejemplo de costo
	$TextureRect/Panel/CantCosto.show()

	await get_tree().create_timer(0.3).timeout

	$TextureRect/Panel/LabelClientesAtendidos.show()
	$TextureRect/Panel/CantAtendidos.text = str(NocheData.atenciones_completas) +"x" + str(pesos.get("atendidos", 0))
	$TextureRect/Panel/CantAtendidos.show()

	await get_tree().create_timer(0.3).timeout

	$TextureRect/Panel/LabelAgua.show()
	$TextureRect/Panel/CantAguas.text = str(NocheData.aguas_servidas)+"x" + str(pesos.get("aguas_servidas", 0))
	$TextureRect/Panel/CantAguas.show()

	await get_tree().create_timer(0.3).timeout

	$TextureRect/Panel/LabelClientesAtendidos2.show()
	$TextureRect/Panel/CantNoAtendidos.text = str(NocheData.atenciones_incompletas) +"x" + str(pesos.get("no_atendidos", 0))
	$TextureRect/Panel/CantNoAtendidos.show()

	await get_tree().create_timer(0.3).timeout

	$TextureRect/Panel/LabelClientesAtendidos4.show()
	$TextureRect/Panel/CantEntregasErroneas.text = str(NocheData.pedidoserroneos)+"x" + str(pesos.get("entregas_erroneas", 0))
	$TextureRect/Panel/CantEntregasErroneas.show()

	await get_tree().create_timer(0.3).timeout

	# Mostrar totales
	$TextureRect/Panel/LabelTotal.show()
	Globales.dinero=Globales.dinero + NocheData.dinero_ganado - costo_apertura_por_mesas[Globales.mesas]
	$TextureRect/Panel/CantDineroTotal.text = "$" + str(Globales.dinero )
	$TextureRect/Panel/CantDineroTotal.show()

	$TextureRect/Panel/LabelTotal2.show()
	calcular_reputacion()
	$TextureRect/Panel/CantReputacionTotal.text = Globales.reputacion_categoria + ", %" + str(Globales.reputacion_progreso)
	$TextureRect/Panel/CantReputacionTotal.show()

	await get_tree().create_timer(0.4).timeout

	# Finalmente mostrar botón continuar
	$TextureRect/Panel/TextureButton.show()


func calcular_reputacion() -> void:
	var categoria: String = Globales.reputacion_categoria
	var progreso: int = Globales.reputacion_progreso

	var clave: String = str(Globales.mesas)
	var pesos: Dictionary = factores_reputacion.get(clave, {})

	var avance: int = 0
	avance += pesos.get("atendidos", 0) * NocheData.atenciones_completas
	avance += pesos.get("aguas_servidas", 0) * NocheData.aguas_servidas
	avance += pesos.get("no_atendidos", 0) * NocheData.atenciones_incompletas
	avance += pesos.get("entregas_erroneas", 0) * NocheData.pedidoserroneos

	progreso += avance

	var orden := ["D", "C", "B", "A", "S"]
	var index := orden.find(categoria)

	while progreso >= 100 and index < orden.size() - 1:
		progreso -= 100
		index += 1

	while progreso < 0 and index > 0:
		progreso += 100
		index -= 1

	Globales.reputacion_categoria = orden[index]
	Globales.reputacion_progreso = clamp(progreso, 0, 100)


func _on_texture_button_pressed() -> void:
	Globales.dia=true
	DiaData.dia_iniciado=false
	if Globales.dinero>=0:
		Globales.guardar_estado()
		get_tree().change_scene_to_file("res://Eventos.tscn")
	else:
		$TextureRect/PanelAdvertencia.show()



func _on_boton_confirma_add_pressed() -> void:
	recompensa_pendiente = true
	mostrar_anuncio_simulado()

func mostrar_anuncio_simulado():
	panel_anuncio.visible = true
	boton_cerrar.disabled = true
	tiempo_restante_anuncio = 10
	boton_cerrar.icon = null
	boton_cerrar.text = "Espera... 10s"
	# Ocultá otros elementos de UI si querés, por ejemplo:
	#$TextureRect/Panel.visible = false

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
		boton_cerrar.icon = preload("res://Sprites/Cruz.png") # Cambia la ruta si es necesario
		boton_cerrar.text = ""
		timer_anuncio.stop()

func _on_boton_cerrar_anuncio():
	if boton_cerrar.disabled or tiempo_restante_anuncio > 0:
		return
	panel_anuncio.visible = false
	#$TextureRect/Panel.visible = true # Si ocultaste el panel principal, mostralo de nuevo

	if timer_anuncio:
		timer_anuncio.queue_free()
		timer_anuncio = null
	if recompensa_pendiente:
		recompensa_pendiente = false
		# Lógica de recompensa o pasar de escena
		Globales.dinero=0 #Se deja el dinero en balance 0
		Globales.guardar_estado()
		#y luego se pasa al dia
		get_tree().change_scene_to_file("res://Eventos.tscn")
