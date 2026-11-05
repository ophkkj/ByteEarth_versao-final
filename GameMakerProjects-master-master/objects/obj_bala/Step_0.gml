/// STEP — obj_bala

vida++;

// Mantém o sprite de cabeça pra cima quando a bala vai para a esquerda
image_yscale = (direction > 90 && direction < 270) ? -abs(image_yscale) : abs(image_yscale);

// Bateu em parede ou chão (ignora os 2 primeiros frames, para não morrer ao nascer)
if (vida > 2 && collision_line(xprevious, yprevious, x, y, obj_solido, true, true) != noone) {
    instance_destroy();
}

// Saiu da room
if (!point_in_rectangle(x, y, -50, -50, room_width + 50, room_height + 50)) {
    instance_destroy();
}