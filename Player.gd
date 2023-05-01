extends KinematicBody

export(float) var SPEED := 100.0
export(float) var TILT_SENSITIVITY := 9.5
export(float) var Step_Length = 100.0

#keep track of number of steps
var counter := 0

#declaring neural nets


var WIP_net := Network.new()


#for recording data
var writefile := File.new()

#for use in verlocity caculation
var v_pos := Vector3(0,0,0)
var v_rot := Vector3(0,0,0)

var pos_prev := Vector3(0,0,0)
var rot_prev := Vector3(0,0,0)

#for speed caculation
var step_distance := 1.358 #male 20-29
var force_multiplier := 2.0

var is_moving = false
var new_speed := 0.0


func _ready(): #load neural networks, has to be done here once as putting it in the physics process causes massive lag
	
	var file = File.new()
	file.open("res://networks/WIP_net.nn", File.READ)
	var content = file.get_as_text()
	file.close()
	WIP_net.scan(content)
	

func _physics_process(delta):
	#print($ARVROrigin/ARVRCamera.translation-pos_prev/delta)
	v_pos = ($ARVROrigin/ARVRCamera.translation-pos_prev)/delta
	v_rot = ($ARVROrigin/ARVRCamera.rotation_degrees-rot_prev)/delta
	pos_prev = $ARVROrigin/ARVRCamera.translation
	rot_prev = $ARVROrigin/ARVRCamera.rotation_degrees
	#print(v_pos)
	
#	print($ARVROrigin/ARVRController.rotation_degrees)
#	print($ARVROrigin/ARVRController2.translation.y)

	var step      = $StepDetector.detect_step(v_pos,v_rot,WIP_net) 
	
	var direction = $StepDetector.get_direction($ARVROrigin/ARVRController.rotation_degrees, $ARVROrigin/ARVRController2.rotation_degrees,$ARVROrigin/ARVRController.translation,$ARVROrigin/ARVRController2.translation)
	
	var speed     = $StepDetector.get_speed(v_pos.y,$ARVROrigin/ARVRCamera.translation.y)
	
	
	if speed > 0.01:
		new_speed = speed
	
	if step:     #makes a gliding movement rather than steps
		 is_moving = true
		 counter = 0
	else:
		counter += 1
		if counter > 40:
			is_moving = false
			counter = 0
#	print(new_speed)
	if is_moving and new_speed < .2:
		move_and_slide(-$ARVROrigin/ARVRCamera.get_global_transform().basis.z*1000*new_speed)	
#		move_and_slide(direction*new_speed*400)
#	if step:
#		move_and_slide(-$ARVROrigin/ARVRCamera.get_global_transform().basis.z*50)
	$HUD/Viewport/Label.text = "step=%s" % step
		
		
	



