/// DRAW — obj_david

var esc, ajuste_manual;

if (sprite_index == sprite_tiro) {
    esc = escala_tiro;
    ajuste_manual = ajuste_y_tiro;
} else if (sprite_index == spr_alien_andando) {
    esc = escala_andando;
    ajuste_manual = ajuste_y_andando;
} else if (sprite_index == spr_alien_pulo) {
    esc = escala_pulo;
    ajuste_manual = ajuste_y_pulo;
} else {
    esc = escala_idle;
    ajuste_manual = ajuste_y_idle;
}

// Distância da origem até a base do alien (pés), já na escala
var pe_idle  = (sprite_get_bbox_bottom(spr_alien_idle) - sprite_get_yoffset(spr_alien_idle)) * escala_idle;
var pe_atual = (sprite_get_bbox_bottom(sprite_index) - sprite_get_yoffset(sprite_index)) * esc;

// Ajuste automático + ajuste manual opcional
var ajuste_y = (pe_idle - pe_atual) + ajuste_manual;

// Pisca enquanto está invencível
var alpha = alfa_david;
if (invencivel && (tempo_invencivel div 4) mod 2 == 0) alpha = 0.3 * alfa_david;

draw_sprite_ext(
    sprite_index, image_index,
    x, y + ajuste_y,
    esc * direcao, esc,
    0, c_white, alpha
);