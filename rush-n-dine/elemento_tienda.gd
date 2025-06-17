extends Control

signal boton_resta(receta_id)

var producto
var nombre
var tipo

var start_pos := Vector2.ZERO
var moved := false
var threshold := 10

func set_data(tipoi,nombrei, productoi):
	producto=productoi
	tipo=tipoi
	nombre=nombrei
	print("actualiza data")
	$CanvasLayer/Nombre.text= nombre
	if (tipo=="recursos"):
		$CanvasLayer/Nombre.text+= " x "+str(producto.datos.cantidad[Globales.mesas-1])
	elif (tipo=="sillas"):
		$CanvasLayer/Nombre.text+=" "+ str(Globales.mesas+1)
	if  producto.precio is Array:
		$CanvasLayer/Precio.text="$"+str(producto.precio[Globales.mesas-1])
	else:
		$CanvasLayer/Precio.text="$"+ str(producto.precio)
	$CanvasLayer/ImagenSeleccion.texture=producto.datos.imagen

func _gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			start_pos = event.position
			moved = false
		else:
			var tienda=self.get_parent().get_parent().get_parent().get_parent().get_parent().get_parent()
			if not moved:
				print("ejecuta accion")
				var costo
				if  producto.precio is Array:
					costo=producto.precio[Globales.mesas-1]
				else:
					costo=producto.precio
				if Globales.dinero>=costo:
					Globales.dinero-=costo
					match tipo:
						"sillas":
							DiaData.mejoranivel=true
						"recetas":
							Globales.recetas_desbloqueadas[producto.datos.nombre] = producto.datos
						"recursos":
							if Globales.recursos_disponibles.has(producto.datos.nombre):
								Globales.recursos_disponibles[producto.datos.nombre].cantidad += producto.datos.cantidad[Globales.mesas-1]
							else:
								Globales.recursos_disponibles[producto.datos.nombre] =  {
										"nombre": producto.datos.nombre,
										"cantidad": producto.datos.cantidad[Globales.mesas-1],
										"imagen": producto.datos.imagen
									}
					tienda.actualizar()
				else:
					tienda.fondos_insuficientes()
	elif event is InputEventMouseMotion:
		if (event.position - start_pos).length() > threshold:
			moved = true
