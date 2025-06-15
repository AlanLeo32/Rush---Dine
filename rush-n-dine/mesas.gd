extends Node2D

class_name GestorMesas

var mesas : Array = []


func _ready():
	randomize()
	for nodo in get_children():
		# Solo agregamos nodos que sean mesas, asumiendo que sus nombres contienen "Mesa"
		if nodo.name.begins_with("Mesa"):
			mesas.append({
				"nodo": nodo,
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
