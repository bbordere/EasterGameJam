//shader_type spatial;
//render_mode unshaded;
//void fragment() {
	//METALLIC = 0.0;
	//ROUGHNESS = 0.01;
	//ALBEDO = vec3(0.1, 0.3, 0.5);
	//ALPHA = 0.5;
//}

//shader_type spatial;
//render_mode unshaded;
//
//uniform float gradient_width : hint_range(0.0, 1.0) = 0.2; // Largeur de la zone de dégradé (entre 0 et 1)
//uniform vec4 center_color = vec4(0.0, 1.0, 0.0, 1.0); // Couleur du centre
//
//void fragment() {
    //// Calcul de la distance du pixel au centre de l'objet
    //vec3 center = vec3(0.5, 0.5, 0.5);
    //float distance_to_center = length(vec3(UV.xy, 0.5) - center);
//
    //// Calcul de la transparence en fonction de la distance au centre
    //float transparency = smoothstep(0.0, gradient_width, distance_to_center);
//
    //// Appliquer la transparence au pixel
    //ALBEDO.rgb = center_color.rgb;
    //ALPHA = (1.0 - transparency);
//}

shader_type spatial;
render_mode unshaded;


uniform float gradient_width : hint_range(0.0, 1.0) = 0.2; // Largeur de la zone de dégradé (entre 0 et 1)

uniform vec4 light_blue_color  = vec4(0.4, 0.6, 1.0, 1.0); // Couleur bleu clair
uniform vec4 dark_blue_color = vec4(0.0, 0.0, 0.5, 1.0); // Couleur bleu foncé

void fragment() {
    // Calcul de la distance du pixel au centre de l'objet
    vec3 center = vec3(0.5, 0.5, 0.5);
    float distance_to_center = length(vec3(UV.xy, 0.5) - center);

    // Calcul de l'interpolation entre les couleurs bleu clair et bleu foncé
    float t = smoothstep(0.0, gradient_width, distance_to_center);
    vec4 interpolated_color = mix(light_blue_color, dark_blue_color, t);

    // Calcul de la transparence en fonction de la distance au centre
    float transparency = smoothstep(0.0, gradient_width, distance_to_center);

    // Appliquer la couleur interpolée avec la transparence au pixel
    ALBEDO.rgb = interpolated_color.rgb;
    ALPHA = interpolated_color.a * (1.0 - transparency);
}
