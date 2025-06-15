extends Node2D  # o Area2D según tu diseño

var sucia := false


func esperar_limpieza():
	sucia = true

func interactuar():
	if sucia==true:
		sucia = false
		$Plato.visible = false  # ocultar el plato
		var gestor_mesas = get_tree().get_root().get_node("Noche/Mesas")  # Ajusta la ruta según tu escena
		if gestor_mesas:
			gestor_mesas.liberar_mesa(self)
