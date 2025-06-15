extends Node
var platos_seleccionables : Dictionary = {}   # recetas seleccionadas para esta noche
var disponibles_cocinar : Dictionary = {}        # de los seleccionados cuantos se pueden cocinar
var platillos_mesada: Array = []
var tiempo

var aguas_servidas=0
var atenciones_completas=0
var atenciones_incompletas=0
var pedidoserroneos = 0 
