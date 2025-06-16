extends Node2D

var costo_apertura_por_mesas := {
	1: 0,
	2: 50,
	3: 100,
	4: 150,
	5: 200,
	6: 250,
	7: 300
}

# Factores que afectan reputación por nivel (pesos por evento)
# Se espera que todos los valores sumen a un rango lógico (-100 a 100)
var factores_reputacion := {
	"1": {
		"atendidos": 5,
		"aguas_servidas": -3,
		"no_atendidos": -8,
		"entregas_erroneas": -12
	},
	"2": {
		"atendidos": 4,
		"aguas_servidas": -2,
		"no_atendidos": -6,
		"entregas_erroneas": -10
	},
	"3": {
		"atendidos": 3,
		"aguas_servidas": -2,
		"no_atendidos": -5,
		"entregas_erroneas": -8
	},
	"4": {
		"atendidos": 2,
		"aguas_servidas": -1,
		"no_atendidos": -4,
		"entregas_erroneas": -6
	},
	"5": {
		"atendidos": 1,
		"aguas_servidas": -1,
		"no_atendidos": -2,
		"entregas_erroneas": -4
	},
	"6": {
		"atendidos": 1,
		"aguas_servidas": -1,
		"no_atendidos": -2,
		"entregas_erroneas": -4
	},
	"7": {
		"atendidos": 1,
		"aguas_servidas": -1,
		"no_atendidos": -2,
		"entregas_erroneas": -4
	}	
}


func _ready():
	for n in $TextureRect/Panel.get_children():
		n.hide()
	mostrar_resultado()


func mostrar_resultado():
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
	$TextureRect/Panel/CantAtendidos.text = str(NocheData.atenciones_completas)
	$TextureRect/Panel/CantAtendidos.show()

	await get_tree().create_timer(0.3).timeout

	$TextureRect/Panel/LabelAgua.show()
	$TextureRect/Panel/CantAguas.text = str(NocheData.aguas_servidas)
	$TextureRect/Panel/CantAguas.show()

	await get_tree().create_timer(0.3).timeout

	$TextureRect/Panel/LabelClientesAtendidos2.show()
	$TextureRect/Panel/CantNoAtendidos.text = str(NocheData.atenciones_incompletas)
	$TextureRect/Panel/CantNoAtendidos.show()

	await get_tree().create_timer(0.3).timeout

	$TextureRect/Panel/LabelClientesAtendidos4.show()
	$TextureRect/Panel/CantEntregasErroneas.text = str(NocheData.pedidoserroneos)
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
	if Globales.dinero>=0:
		Globales.guardar_estado()
		print("Ruta de guardado real: ", OS.get_user_data_dir())
		print("Guardado: ", FileAccess.file_exists("user://save_game.json"))
		get_tree().change_scene_to_file("res://dia.tscn")
	else:
		$TextureRect/PanelAdvertencia.show()
	Globales.dia=true



func _on_boton_confirma_add_pressed() -> void:
	#LOGICA DE MOSTRAR ANUNCIO...
	Globales.dinero=0 #Se deja el dinero en balance 0
	Globales.guardar_estado()
	#y luego se pasa al dia
	get_tree().change_scene_to_file("res://dia.tscn")
