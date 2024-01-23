extends Node

#' TODO: change thickness parameter
func line(node: Node3D, pos1: Vector3, pos2: Vector3, color = Color.WHITE_SMOKE, persist_ms = 0):
	var mesh_instance := MeshInstance3D.new()
	var immediate_mesh := ImmediateMesh.new()
	var material := ORMMaterial3D.new()

	mesh_instance.mesh = immediate_mesh
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	
	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)
	immediate_mesh.surface_add_vertex(pos1)
	immediate_mesh.surface_add_vertex(pos2)
	immediate_mesh.surface_end()
	
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = color

	return await final_cleanup(node, mesh_instance, persist_ms)

## -1 -> Lasts ONLY for current physics frame
## <=0 -> Stays indefinitely
## >0 -> Lasts X time duration.
func final_cleanup(node, mesh_instance: MeshInstance3D, persist_ms: float):
	node.add_child(mesh_instance)
	if persist_ms == -1:
		await get_tree().physics_frame
		mesh_instance.queue_free()
	elif persist_ms <= 0:
		return mesh_instance
	else:
		await get_tree().create_timer(persist_ms).timeout
		mesh_instance.queue_free()
