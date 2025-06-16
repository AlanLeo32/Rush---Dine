extends Node2D

class_name GestorMesas

var mesas : Array = []


func _ready():
	randomize()
	for nodo in get_children():
		if nodo.name.begins_with("Mesa"):
			nodo.visible = false  # Ocultar visualmente

			# Desactivar colisión (si existe)
			var col := nodo.get_node_or_null("CollisionShape2D")
			if col:
				col.disabled = true

	# Mostrar solo las mesas activas según Globales.mesas
	for i in range(1, Globales.mesas + 1):
		var mesa := get_node_or_null("Mesa%d" % i)
		if mesa:
			mesa.visible = true  # Mostrar visualmente

			# Reactivar colisión
			var col := mesa.get_node_or_null("CollisionShape2D")
			if col:
				col.disabled = false

			mesas.append({
				"nodo": mesa,
				"ocupada": false
			})


func obtener_mesa_libre() -> Node:
	var mesas_libres := []
	for mesa in mesas:
		if not mesa["ocupada"]:
			mesas_libres.append(mesa)

	if mesas_libres.size() == 0:
		return null

	
	var mesa_random: Dictionary = mesas_libres[randi() % mesas_libres.size()]
	mesa_random["ocupada"] = true
	return mesa_random["nodo"]


func hay_mesa_libre() -> bool:
	for mesa in mesas:
		if not mesa["ocupada"]:
			return true
	return false

	
func liberar_mesa(mesa_nodo: Node) -> void:
	for mesa in mesas:
		if mesa["nodo"] == mesa_nodo:
			mesa["ocupada"] = false
			print("Mesa liberada:", mesa_nodo.name)
			return


func esta_mesa_ocupada(mesa_nodo: Node) -> bool:
	for mesa in mesas:
		if mesa["nodo"] == mesa_nodo:
			return true
	return false  # o lanzar error si no se encontró
