/// STEP — obj_david

// Invencibilidade temporária
if (invencivel) {
    tempo_invencivel--;
    if (tempo_invencivel <= 0) invencivel = false;
}

// Dano: encostou em qualquer objeto perigoso (inimigo, espinho...)
if (place_meeting(x, y, obj_perigo)) levar_dano();

// Reinicia a fase depois de morrer
if (morrendo) {
    tempo_morte--;
    if (tempo_morte <= 0) room_restart();
}

// TESTE: H perde um coração, J recupera (apague depois de testar)
if (keyboard_check_pressed(ord("H"))) levar_dano();
if (keyboard_check_pressed(ord("J"))) curar();

var direita = keyboard_check(ord("D")) || keyboard_check(vk_right);
var esquerda = keyboard_check(ord("A")) || keyboard_check(vk_left);
var tecla_pulo = keyboard_check_pressed(ord("W"))
              || keyboard_check_pressed(vk_up);

// Controle travado (computador aberto, diálogo...) ou caminhada automática
if (controle_travado) {
    direita = false;
    esquerda = false;
    tecla_pulo = false;
    if (auto_dir != 0) {
        direita = (auto_dir > 0);
        esquerda = (auto_dir < 0);
    }
}

var movimento = direita - esquerda;

// Chão
no_chao = place_meeting(x, y + 1, obj_solido);

// Movimento horizontal (pixel a pixel)
var _x_antes = x;
if (movimento != 0) {
    direcao = movimento;

    repeat (abs(velocidade_x)) {
        if (!place_meeting(x + movimento, y, obj_solido)) {
            x += movimento;
        } else {
            break;
        }
    }
}

// Pulo
if (tecla_pulo && no_chao) {
    velocidade_y = forca_pulo;
    no_chao = false;
    var _som_pulo = audio_play_sound(snd_david_pulo, 1, false);
    audio_sound_pitch(_som_pulo, random_range(0.96, 1.04));
}

// Gravidade
if (no_chao && velocidade_y > 0) {
    velocidade_y = 0;
}
velocidade_y += gravidade;
velocidade_y = clamp(velocidade_y, -10, 12);

// Movimento vertical (pixel a pixel)
var sinal_y = sign(velocidade_y);
repeat (ceil(abs(velocidade_y))) {
    if (!place_meeting(x, y + sinal_y, obj_solido)) {
        y += sinal_y;
    } else {
        velocidade_y = 0;
        break;
    }
}

// Atualizar estado do chão
no_chao = place_meeting(x, y + 1, obj_solido);

// Som de passos: em loop só enquanto ele realmente anda no chão
if (x != _x_antes && no_chao && !morrendo) {
    if (!audio_is_playing(snd_david_andando)) audio_play_sound(snd_david_andando, 1, true);
} else {
    audio_stop_sound(snd_david_andando);
}

// Tiro: cria a bala e liga a animação
if (tempo_tiro > 0) tempo_tiro--;

if (mouse_check_button_pressed(mb_left) && tempo_tiro <= 0 && !morrendo && !controle_travado) {
    tempo_tiro = cadencia_tiro;
    var _som_tiro = audio_play_sound(snd_tiro_arma, 1, false);
    audio_sound_pitch(_som_tiro, random_range(0.95, 1.05));

    // Vira o alien para o lado onde ele atirou
    if (mouse_x != x) direcao = sign(mouse_x - x);

    // Ponto de saída: posição do alien + deslocamento manual
    var origem_x = x + direcao * saida_dx;
    var origem_y = y + saida_dy;

    var angulo = point_direction(origem_x, origem_y, mouse_x, mouse_y);

    // Profundidade -10000 deixa a bala na frente de tudo
    var bala = instance_create_depth(origem_x, origem_y, -10000, obj_bala);
    bala.direction = angulo;
    bala.speed = velocidade_bala;
    bala.image_angle = angulo;

    // Liga a animação de tiro e reinicia do primeiro frame
    atirando = true;
    tempo_atirando = ceil(sprite_get_number(sprite_tiro) / velocidade_anim_tiro);
    if (sprite_index == sprite_tiro) image_index = 0;
}

// Duração da animação de tiro
if (atirando) {
    tempo_atirando--;
    if (tempo_atirando <= 0) atirando = false;
}

// Animações (só mexe quando o sprite muda)
var novo_sprite;
var nova_velocidade;

if (atirando) {
    novo_sprite = sprite_tiro;
    nova_velocidade = velocidade_anim_tiro;
} else if (!no_chao) {
    novo_sprite = spr_alien_pulo;
    nova_velocidade = 0.15;
} else if (movimento != 0) {
    novo_sprite = spr_alien_andando;
    nova_velocidade = 0.2;
} else {
    novo_sprite = spr_alien_idle;
    nova_velocidade = 0.12;
}

if (sprite_index != novo_sprite) {
    sprite_index = novo_sprite;
    image_index = 0;
    image_speed = nova_velocidade;
}

// No pulo, segura o último frame em vez de repetir a animação
if (sprite_index == spr_alien_pulo && image_index >= image_number - 1) {
    image_index = image_number - 1;
    image_speed = 0;
}