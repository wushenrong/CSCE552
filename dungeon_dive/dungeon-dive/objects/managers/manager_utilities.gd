class_name ManagerUtilities


static func get_highest_z_index_collider(areas):
    var highest_z_collider = areas[0].collider

    for area in areas:
        var current_collider = area.collider

        if current_collider.get_parent().z_index > highest_z_collider.get_parent().z_index:
            highest_z_collider = current_collider

    return highest_z_collider
