extends Node2D

class_name GestorMesas

var mesas : Array = []


func _ready():
	for nodo in get_children():
		# Solo agregamos nodos que sean mesas, asumiendo que sus nombres contienen "Mesa"
		if nodo.name.begins_with("Mesa"):
			mesas.append({
				"nodo": nodo,
				"ocupada": false
			})

func obtener_mesa_libre() -> Node:
	for mesa in mesas:
		if not mesa["ocupada"]:
			mesa["ocupada"] = true
			return mesa["nodo"]
	return null

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
