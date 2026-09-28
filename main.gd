extends Node2D
## Neon Wastes - offline mobile loot-shooter vertical slice.
## All gameplay and art in this starter project are original.

const PLAYER_SPEED := 310.0
const ENEMY_SPEED := 95.0
const FIRE_COOLDOWN := 0.16
const MAX_ENEMIES := 8

var player := Vector2(640, 360)
var hp := 100
var max_hp := 100
var ammo := 24
var reserve := 120
var score := 0
var level := 1
var fire_timer := 0.0
var spawn_timer := 0.0
var enemies: Array[Dictionary] = []
var bullets: Array[Dictionary] = []
var pickups: Array[Dictionary] = []
var rng := RandomNumberGenerator.new()
var hud: Label
var banner: Label
var touch_fire := false
var touch_dir := Vector2.ZERO

func _ready() -> void:
    rng.randomize()
    _make_hud()
    for i in 5:
        _spawn_enemy()

func _process(delta: float) -> void:
    fire_timer -= delta
    spawn_timer -= delta
    _move_player(delta)
    _aim_and_fire()
    _update_bullets(delta)
    _update_enemies(delta)
    _update_pickups(delta)
    if spawn_timer <= 0.0 and enemies.size() < MAX_ENEMIES:
        _spawn_enemy()
        spawn_timer = max(0.35, 1.2 - level * 0.04)
    _draw()
    _update_hud()

func _move_player(delta: float) -> void:
    var v := Input.get_vector("move_left", "move_right", "move_up", "move_down")
    if touch_dir.length() > 0.1:
        v = touch_dir
    player += v * PLAYER_SPEED * delta
    player.x = clamp(player.x, 45.0, 1235.0)
    player.y = clamp(player.y, 95.0, 675.0)

func _aim_and_fire() -> void:
    var mouse := get_viewport().get_mouse_position()
    var wants_fire := Input.is_action_pressed("fire") or touch_fire
    if wants_fire and fire_timer <= 0.0 and ammo > 0:
        var dir := (mouse - player).normalized()
        if touch_fire and dir.length() < 0.1:
            dir = Vector2.RIGHT
        bullets.append({"p": player + dir * 28.0, "v": dir * 900.0, "life": 0.8})
        ammo -= 1
        fire_timer = FIRE_COOLDOWN
        queue_redraw()

func _update_bullets(delta: float) -> void:
    for i in range(bullets.size() - 1, -1, -1):
        bullets[i].p += bullets[i].v * delta
        bullets[i].life -= delta
        var remove := bullets[i].life <= 0.0
        for e in range(enemies.size() - 1, -1, -1):
            if bullets[i].p.distance_to(enemies[e].p) < enemies[e].r + 6.0:
                enemies[e].hp -= 34
                remove = true
                if enemies[e].hp <= 0:
                    score += 100
                    if rng.randf() < 0.25:
                        pickups.append({"p": enemies[e].p, "kind": "ammo"})
                    elif rng.randf() < 0.45:
                        pickups.append({"p": enemies[e].p, "kind": "med"})
                    enemies.remove_at(e)
                break
        if remove:
            bullets.remove_at(i)

func _update_enemies(delta: float) -> void:
    for i in range(enemies.size()):
        var d := player - enemies[i].p
        if d.length() > 42.0:
            enemies[i].p += d.normalized() * ENEMY_SPEED * (1.0 + level * 0.025) * delta
        else:
            hp -= int(18.0 * delta)
            if hp <= 0:
                hp = max_hp
                ammo = min(24, ammo + 12)
                score = max(0, score - 250)
                banner.text = "DOWNED — KEEP MOVING"

func _update_pickups(_delta: float) -> void:
    for i in range(pickups.size() - 1, -1, -1):
        if player.distance_to(pickups[i].p) < 32:
            if pickups[i].kind == "ammo":
                reserve += 36
                banner.text = "+36 AMMO"
            else:
                hp = min(max_hp, hp + 30)
                banner.text = "+30 HP"
            pickups.remove_at(i)

func _spawn_enemy() -> void:
    var side := rng.randi_range(0, 3)
    var p := Vector2.ZERO
    if side == 0: p = Vector2(rng.randf_range(40,1240), 100)
    elif side == 1: p = Vector2(rng.randf_range(40,1240), 680)
    elif side == 2: p = Vector2(40, rng.randf_range(100,680))
    else: p = Vector2(1240, rng.randf_range(100,680))
    enemies.append({"p":p, "hp":70 + level * 5, "r":22.0})

func _make_hud() -> void:
    hud = Label.new()
    hud.position = Vector2(28, 22)
    hud.add_theme_font_size_override("font_size", 24)
    add_child(hud)
    banner = Label.new()
    banner.position = Vector2(480, 22)
    banner.add_theme_font_size_override("font_size", 22)
    add_theme_color_override("font_color", Color(1,0.85,0.25))
    add_child(banner)
    banner.text = "NEON WASTES"
    _make_touch_ui()

func _make_touch_ui() -> void:
    # Simple large touch controls; desktop keyboard/mouse remains supported.
    var hint := Label.new()
    hint.position = Vector2(28, 650)
    hint.text = "WASD / arrows = move    •    hold mouse = fire    •    touch: left/right zones"
    hint.add_theme_font_size_override("font_size", 16)
    add_child(hint)

func _update_hud() -> void:
    hud.text = "HP %03d/%03d    AMMO %02d/%03d    SCORE %06d    LV %02d" % [hp,max_hp,ammo,reserve,score,level]
    if score >= level * 1500:
        level += 1
        banner.text = "LEVEL %02d — THREAT RISING" % level

func _draw() -> void:
    # Original graphic language: hard ink contours, flat cel fills, distressed geometry.
    draw_rect(Rect2(0,0,1280,720), Color("#120d1b"))
    for x in range(0, 1280, 64):
        draw_line(Vector2(x,95), Vector2(x,720), Color(0.20,0.16,0.24,0.32), 1.0)
    for y in range(96, 721, 64):
        draw_line(Vector2(0,y), Vector2(1280,y), Color(0.20,0.16,0.24,0.32), 1.0)
    # debris / angular silhouettes
    for i in range(14):
        var xx := float((i * 179) % 1200 + 40)
        var yy := float(130 + (i * 97) % 520)
        draw_colored_polygon(PackedVector2Array([
            Vector2(xx,yy), Vector2(xx+22,yy-10), Vector2(xx+34,yy+12), Vector2(xx+8,yy+26)
        ]), Color("#2a2033"))
    for p in pickups:
        if p.kind == "ammo":
            draw_circle(p.p, 12, Color("#f1c83b"))
            draw_circle(p.p, 6, Color("#5c4110"))
        else:
            draw_circle(p.p, 12, Color("#6be08c"))
            draw_line(p.p-Vector2(7,0), p.p+Vector2(7,0), Color("#143d24"), 3)
            draw_line(p.p-Vector2(0,7), p.p+Vector2(0,7), Color("#143d24"), 3)
    for b in bullets:
        draw_line(b.p, b.p - b.v.normalized()*18, Color("#ffd45a"), 6)
        draw_line(b.p, b.p - b.v.normalized()*18, Color("#fff3c1"), 2)
    for e in enemies:
        _draw_enemy(e.p, e.r, e.hp)
    _draw_player(player)

func _draw_player(p: Vector2) -> void:
    var outline := Color("#08070b")
    draw_circle(p, 27, outline)
    draw_circle(p, 21, Color("#38a8a0"))
    draw_colored_polygon(PackedVector2Array([
        p+Vector2(-16,-5), p+Vector2(17,-12), p+Vector2(28,-2), p+Vector2(15,9), p+Vector2(-17,7)
    ]), Color("#d6dfd0"))
    draw_circle(p+Vector2(7,-7), 4, Color("#e6b83e"))
    draw_line(p+Vector2(16,0), p+Vector2(38,0), outline, 8)
    draw_line(p+Vector2(18,0), p+Vector2(39,0), Color("#9c9fa4"), 4)

func _draw_enemy(p: Vector2, r: float, hpv: int) -> void:
    draw_circle(p, r+5, Color("#08070b"))
    draw_circle(p, r, Color("#c84c52"))
    draw_colored_polygon(PackedVector2Array([
        p+Vector2(-18,-8), p+Vector2(-5,-20), p+Vector2(16,-14), p+Vector2(20,5), p+Vector2(2,18), p+Vector2(-17,12)
    ]), Color("#d76b56"))
    draw_line(p+Vector2(-10,-2), p+Vector2(12,-5), Color("#21131a"), 5)
    draw_line(p+Vector2(-r,-r-10), p+Vector2(r,-r-10), Color("#08070b"), 5)
    draw_line(p+Vector2(-r,-r-10), p+Vector2(-r + (2*r*clamp(float(hpv)/100.0,0,1)),-r-10), Color("#78dc78"), 5)

func _input(event: InputEvent) -> void:
    if event is InputEventScreenTouch:
        touch_fire = event.pressed and event.position.x > 720
        if not event.pressed:
            touch_dir = Vector2.ZERO
    elif event is InputEventScreenDrag:
        if event.position.x < 640:
            var center := Vector2(180, 520)
            touch_dir = (event.position - center).normalized()
        else:
            touch_fire = true
