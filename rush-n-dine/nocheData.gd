extends Node
var platos_seleccionables : Dictionary = {}   # recetas seleccionadas para esta noche
var disponibles_cocinar : Dictionary = {}        # de los seleccionados cuantos se pueden cocinar
var platillos_mesada: Array = []
var tiempo

var aguas_servidas=0
var atenciones_completas=0
var atenciones_incompletas=0
var pedidoserroneos = 0 
var dinero_ganado=0

func resetear():
	platos_seleccionables.clear()
	disponibles_cocinar.clear()
	platillos_mesada.clear()
	tiempo = null  # o 0 si querés inicializarlo explícitamente

	aguas_servidas = 0
	atenciones_completas = 0
	atenciones_incompletas = 0
	pedidoserroneos = 0
	
	dinero_ganado = 0
