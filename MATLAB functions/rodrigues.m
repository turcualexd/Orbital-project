function v_rot = rodrigues(v, u, delta)

v_rot = v * cos(delta) + cross(u, v) * sin(delta) + u * dot(u, v);