#L Exemplo de Uso: PhysRigidBody2DContract e PhysVector2DContract
use PhysStdLib as Phys

program (ExampleOfUsePhysStdLib_PhysRigidBody2DContract) {
      println("==================================================")
      println("  Exemplo: PhysRigidBody2DContract (Simulacao 2D) ")
      println("==================================================")

      #L 1. Operacoes Vetoriais 2D
      mut as list of data: v1 = physVec2New(3.0, 4.0)
      mut as float64: len = physVec2Length(v1)
      mut as float64: len_fmt = ((len * 10000.0 + 0.5) as int64) /f 10000.0
      println("1. Vetor [3, 4] modulo: " + len_fmt)

      mut as list of data: norm = physVec2Normalize(v1)
      mut as float64: nx_fmt = (((norm[1] as float64) * 10000.0 + 0.5) as int64) /f 10000.0
      mut as float64: ny_fmt = (((norm[2] as float64) * 10000.0 + 0.5) as int64) /f 10000.0
      println("2. Vetor normalizado: [" + nx_fmt + ", " + ny_fmt + "]")

      mut as list of data: v2 = physVec2New(6.0, 8.0)
      mut as float64: dist = physVec2Distance(v1, v2)
      mut as float64: dist_fmt = ((dist * 10000.0 + 0.5) as int64) /f 10000.0
      println("3. Distancia entre [3,4] e [6,8]: " + dist_fmt)

      #L 2. Criacao de Mundo Fisico 2D
      #L Gravidade: [0.0, -9.8], Coeficiente de arrasto: 0.02
      mut as list of data: grav = [0.0, -9.8]
      mut as map: world = physCreateWorld(grav, 0.02)
      println("4. Mundo Criado: gx=" + (world["gx"] as float64) + ", gy=" + (world["gy"] as float64))

      #L 3. Criacao de Corpos Rigidos
      #L Corpo 1: Circulo (id=1, m=2kg, pos=[0, 10], vel=[4, 0], raio=1.5)
      mut as list of data: pos1 = [0.0, 10.0]
      mut as list of data: vel1 = [4.0, 0.0]
      mut as map: b1 = physCreateBodyCircle(1.0, 2.0, pos1, vel1, 1.5)

      #L Corpo 2: Caixa (id=2, m=5kg, pos=[3, 10], vel=[-2, 0], w=2, h=2)
      mut as list of data: pos2 = [3.0, 10.0]
      mut as list of data: vel2 = [-2.0, 0.0]
      mut as map: b2 = physCreateBodyBox(2.0, 5.0, pos2, vel2, 2.0, 2.0)

      #L 4. Deteccao de Colisao
      mut as bool: collided = physCheckCollision(b1, b2)
      println("5. Colisao detectada entre b1 e b2: " + collided)

      #L 5. Resolucao de Colisao (Momento linear e restituicao)
      mut as list of data: resolved = physResolveCollision(b1, b2)
      mut as map: b1_pos = resolved[1] as map
      mut as map: b2_pos = resolved[2] as map
      mut as float64: b1_vx = (((b1_pos["vx"] as float64) * 10000.0) as int64) /f 10000.0
      mut as float64: b2_vx = (((b2_pos["vx"] as float64) * 10000.0) as int64) /f 10000.0
      println("6. Pos-colisao vx_b1: " + b1_vx + ", vx_b2: " + b2_vx)

      #L 6. Passo de Simulacao no Tempo (delta_time = 0.1s)
      mut as list of data: bodies = [b1, b2]
      mut as list of data: step_result = physStepSimulation(world, bodies, 0.1)
      mut as map: b1_step = step_result[1] as map
      mut as float64: b1_py = (((b1_step["py"] as float64) * 10000.0) as int64) /f 10000.0
      mut as float64: b1_vy = (((b1_step["vy"] as float64) * 10000.0) as int64) /f 10000.0
      println("7. Passo de 0.1s - b1 py: " + b1_py + ", vy: " + b1_vy)

      #L 7. Raycast 2D (Linha de Visao / Sensor)
      #L Raio disparado de [0, 0] na direcao [0, 1] com alcance de 20m
      mut as list of data: ray_orig = [0.0, 0.0]
      mut as list of data: ray_dir = [0.0, 1.0]
      mut as map: hit = physRaycast(bodies, ray_orig, ray_dir, 20.0)
      mut as float64: h_dist = (((hit["distance"] as float64) * 10000.0) as int64) /f 10000.0
      println("8. Raycast atingiu corpo id: " + (hit["body_id"] as float64) + " na distancia: " + h_dist)
}
