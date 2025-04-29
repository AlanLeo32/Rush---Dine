extends Node2D

func _ready():
	cargar_datos_del_juego()

func cargar_datos_del_juego():
	print("Intentando cargar datos...")

	if FileAccess.file_exists("user://datos_guardados.save"):
		var archivo = FileAccess.open("user://datos_guardados.save", FileAccess.READ)
		if archivo:
			var datos = archivo.get_var()
			#Cargar datos en Globals (Autoload)
			Globales.nivel = datos.get("nivel", 0)
			Globales.dinero = datos.get("dinero", 0)
			Globales.reputacion = datos.get("reputacion", 0)
			Globales.dia = datos.get("dia", true)
			archivo.close()
			print("Datos cargados correctamente.")
		else:
			print("Error al abrir archivo.")
	else:
		print("No hay archivo de guardado. Usando valores por defecto.")

	# Espera opcional para dejar ver la pantalla
	await get_tree().create_timer(5).timeout

	# Ir al menú principal
	get_tree().change_scene_to_file("res://menu_principal.tscn")
