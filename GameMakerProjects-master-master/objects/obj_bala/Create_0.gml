/// CREATE — obj_bala

// direction e speed são definidos por quem cria a bala
dano = 1;
vida = 0; // contador de frames
debug_bala = false; // mostra o ponto de nascimento (coloque false no final)

// Origem automática: a cabeça da bala fica na ponta direita, no centro vertical
var b_esq = sprite_get_bbox_left(spr_bala);
var b_dir = sprite_get_bbox_right(spr_bala);
var b_top = sprite_get_bbox_top(spr_bala);
var b_bot = sprite_get_bbox_bottom(spr_bala);

var raio = min((b_bot - b_top) / 2, (b_dir - b_esq) / 2);
sprite_set_offset(spr_bala, b_dir - raio, (b_top + b_bot) / 2);

sprite_index = spr_bala;
image_speed = 1;
image_xscale = 1;
image_yscale = 1;
visible = true;