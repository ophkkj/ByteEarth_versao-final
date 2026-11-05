
/// ANIMATION END — obj_david

if (sprite_index == spr_alien_arma) {
    sprite_index = spr_alien_olhar_arma;
    image_index = 0;
    image_speed = 0.15;
}
else if (sprite_index == spr_alien_olhar_arma) {
    sprite_index = spr_alien_guardar_arma;
    image_index = 0;
    image_speed = 0.15;
}
else if (sprite_index == spr_alien_guardar_arma) {
    usando_arma = false;

    sprite_index = spr_alien_idle;
    image_index = 0;
    image_speed = 0.12;

    alarm[0] = room_speed * 45;
}
