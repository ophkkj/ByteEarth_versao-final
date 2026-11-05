if (estado == "vivo") {
    hp -= 1;
    dano_timer = 12;
    with (other) instance_destroy();
}