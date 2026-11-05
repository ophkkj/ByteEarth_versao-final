hp = 3;
estado = "vivo";
vsp = 0;
grav = 0.5;
vel = 1.2;
facing = 1;
lado_original = 1; // se ele andar de costas, troque para -1
dano_timer = 0;
morte_timer = 0;
gemido_timer = irandom_range(30, 240); // frames até o próximo gemido
global.tutorial_zumbi_morto = false;

sprite_index = spr_zumbi_idle;
mask_index = spr_zumbi_idle;
image_speed = 0.12;

// mesma altura do David (escala 0.5 dele)
var h_david = sprite_get_bbox_bottom(spr_alien_idle) - sprite_get_bbox_top(spr_alien_idle) + 1;
var h_zumbi = sprite_get_bbox_bottom(spr_zumbi_idle) - sprite_get_bbox_top(spr_zumbi_idle) + 1;
escala = (h_david * 0.5) / h_zumbi;