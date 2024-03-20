shader_type canvas_item;

uniform float fade_time : hint_range(0.1, 5.0) = 1.0; // Durée du fondu en secondes

void fragment() {
    // Calculer le facteur de fondu en fonction du temps écoulé
    float fade_factor = clamp(TIME / fade_time, 0.0, 1.0);

    // Appliquer le fondu au noir
    COLOR.rgb *= fade_factor;
	COLOR.a = 1.0 - fade_factor;
}