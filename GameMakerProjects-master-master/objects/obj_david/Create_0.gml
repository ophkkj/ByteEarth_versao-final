/// CREATE — obj_david

// Música das fases (controlador persistente; só cria se ainda não existir)
if (!instance_exists(obj_musica_fases)) instance_create_depth(0, 0, 0, obj_musica_fases);

// Animação inicial
sprite_index = spr_alien_idle;
image_speed = 0.12;
image_index = 0;

// Estado do alien
tempo_espera = 0;
estado_alien = 0;

// Movimento
velocidade_x = 4;
velocidade_y = 0;
gravidade = 0.5;
forca_pulo = -10;
no_chao = false;
direcao = 1; // 1 = direita, -1 = esquerda

// Controle das animações
andando = false;
pulando = false;
usando_arma = false;

// Escala de cada animação (ajuste até o alien ficar do mesmo tamanho)
escala_idle = 0.5;
escala_andando = 0.5;
escala_pulo = 0.5;

// Tiro
sprite_tiro = spr_tiro;        // sprite da animação de tiro
velocidade_anim_tiro = 0.25;   // velocidade da animação de tiro
atirando = false;
tempo_atirando = 0;            // frames restantes da animação de tiro
tempo_tiro = 0;                // contador do intervalo entre tiros
cadencia_tiro = 15;            // frames entre um tiro e outro
velocidade_bala = 12;

// Ponto de saída da bala, em pixels a partir do (x, y) do alien
saida_dx = 25;    // para a frente (inverte sozinho quando ele olha para a esquerda)
saida_dy = -40;   // negativo = para cima, positivo = para baixo

// Escala do tiro: calculada pela altura do alien em relação ao idle
var altura_idle = sprite_get_bbox_bottom(spr_alien_idle) - sprite_get_bbox_top(spr_alien_idle) + 1;
var altura_tiro = sprite_get_bbox_bottom(sprite_tiro) - sprite_get_bbox_top(sprite_tiro) + 1;
fator_tiro = 1; // ajuste fino: aumente se ainda diminuir, reduza se aumentar
escala_tiro = escala_idle * (altura_idle / altura_tiro) * fator_tiro;

// Ajuste vertical de cada animação (em pixels)
// Positivo = desce o desenho, negativo = sobe
ajuste_y_idle = 0;
ajuste_y_andando = 0;
ajuste_y_pulo = 0;
ajuste_y_tiro = 0;

// Colisão fixa: não muda quando a animação troca
mask_index = spr_alien_idle;
image_xscale = escala_idle;
image_yscale = escala_idle;

// Vida
vida_max = 3;
vida = vida_max;
invencivel = false;
tempo_invencivel = 0;
duracao_invencivel = 90; // frames sem levar dano depois de ser atingido (1,5 s)

// Morte
morrendo = false;
tempo_morte = 0;

// Controle por script (computador, diálogos, caminhada até o portal)
controle_travado = false;   // true = ignora teclado e mouse
auto_dir = 0;               // 1 / -1 = anda sozinho para a direita / esquerda
alfa_david = 1;             // transparência extra (usada ao entrar no portal)
global.pc_aberto = false;   // true enquanto a tela do computador está aberta

// Perde sempre 1 coração por dano
// forcar = true ignora a invencibilidade (usado na penalidade do puzzle de C++)
levar_dano = function(forcar = false) {
    if (morrendo) return;
    if (invencivel && !forcar) return;

    vida = max(0, vida - 1);
    invencivel = true;
    tempo_invencivel = duracao_invencivel;

    if (vida <= 0) {
        morrendo = true;
        tempo_morte = 60; // 1 segundo antes de reiniciar a fase
        audio_stop_sound(snd_david_andando);
        audio_play_sound(snd_david_morte, 2, false);
    }
};

// Cura 1 coração
curar = function() {
    vida = min(vida_max, vida + 1);
};

// Temporizador da arma
alarm[0] = game_get_speed(gamespeed_fps) * 45;

// Zumbi do tutorial de tiro: só na rm_fase_2
if (room == rm_fase_2 && !instance_exists(obj_zumbi)) {
    var zx = (x > room_width / 2) ? x - 400 : x + 400;
    instance_create_layer(zx, y, layer, obj_zumbi);
}
// Rua com zumbis (rm_fase_3) — horda maior
if (room == rm_fase_3 && !instance_exists(obj_zumbi)) {
    var xs = [450, 600, 750, 900, 1050, 1150, 1230, 1300];
    for (var i = 0; i < array_length(xs); i++) {
        if (abs(xs[i] - x) > 250) instance_create_layer(xs[i], y, layer, obj_zumbi);
    }
}
// Zumbis do início da rm_fase_4 (matar todos faz o código em C++ aparecer)
if (room == rm_fase_4 && !instance_exists(obj_zumbi)) {
    var xs4 = [520, 720, 920, 1120];
    for (var i = 0; i < array_length(xs4); i++) {
        instance_create_layer(xs4[i], y, layer, obj_zumbi);
    }
}
// Fases 1 a 4: sem portal. Seguir em frente até a borda direita avança de fase.
if ((room == rm_fase_1 || room == rm_fase_2 || room == rm_fase_3 || room == rm_fase_4) && !instance_exists(obj_avanca)) {
    var av = instance_create_layer(0, 0, layer, obj_avanca);
    if (room == rm_fase_1) av.destino = rm_fase_2;
    if (room == rm_fase_2) { av.destino = rm_fase_3; av.trancada = true; } // só depois de matar o zumbi
    if (room == rm_fase_3) av.destino = rm_fase_4;
    if (room == rm_fase_4) { av.destino = rm_fase_5; av.trancada = true; av.abrir_ao_limpar = true; } // só depois de matar todos os zumbis
}

// Fase 5: controlador da fase + computador gigante no meio
if (room == rm_fase_5 && !instance_exists(obj_fase5_ctrl)) {
    instance_create_layer(0, 0, layer, obj_fase5_ctrl);
    instance_create_layer(room_width / 2, y, layer, obj_computador);
}
