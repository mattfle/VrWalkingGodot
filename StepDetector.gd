extends Node
class_name WIPEstimator


var data := []
var stepsize_data := []
var omni := 0
var WIP_input_layer_size = 150

func detect_step(v_pos,v_rot,WIP_net) -> bool:

	#builds data for neural net to look at for WIP
	data.append(abs(v_pos.x)-abs(v_pos.z))
	data.append(v_pos.y)
	data.append(v_rot.x)
	data.append(v_rot.y)
	data.append(v_rot.z)
	#removes old data
	if data.size() > WIP_input_layer_size:
		data.erase(data[0])
		data.erase(data[0])
		data.erase(data[0])
		data.erase(data[0])
		data.erase(data[0])
		
	#detects WIP
	if data.size() == WIP_input_layer_size:
		if WIP_net.feedforward(data)[0] > .5:
			return true
		else:
			return false
	else: 
		return false
	
	
var x_value := 0.0
var z_value := 0.0
func get_direction(LHO, RH0,LHP,RHP) -> Vector3:
	#look at data and determine direction of walking
	x_value = LHP.x-RHP.x
	z_value = LHP.z-RHP.z
	return Vector3(-z_value,0,x_value).normalized()
	
	
var v_pos_y_prev := 0.0 
var last_position :=0.0
var stepsize := 0.0

func get_speed(v_pos_y,position_y) -> float:
	if v_pos_y_prev < 0:
		if v_pos_y > 0:
			stepsize = abs(position_y-last_position)
			last_position = position_y
	else: 
		if v_pos_y <0:
			stepsize = abs(position_y-last_position)
			last_position = position_y
			
	v_pos_y_prev = v_pos_y	
	return stepsize
