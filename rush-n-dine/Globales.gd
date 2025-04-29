extends Node

# Variables globales del jugador
var nivel = 0
var dinero = 0
var reputacion = 0
var dia= false
#Demas variables...


func agregar_dinero(cantidad: int):
	dinero += cantidad

func subir_nivel():
	nivel += 1

func subir_reputacion():
	reputacion += 1
