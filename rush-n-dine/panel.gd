extends Panel


@onready var lb_atenciones = $LbAtenciones
@onready var lb_no_atencion = $LbNoAtencion
@onready var lb_agua = $LbAgua
@onready var lb_error_platillo = $LbErrorPlatillo

func _process(_delta):
	lb_atenciones.text = "Atenciones: %d" % NocheData.atenciones_completas
	lb_no_atencion.text = "No Atendidos: %d" % NocheData.atenciones_incompletas
	lb_agua.text = "Agua Servida: %d" % NocheData.aguas_servidas
	lb_error_platillo.text = "Errores Platillo: %d" % NocheData.pedidoserroneos
