shader_type canvas_item;

uniform vec4 water_color : source_color = vec4(0.1, 0.4, 0.8, 1.0);
uniform vec4 foam_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float water_opacity : hint_range(0.0, 1.0) = 0.7;
uniform float foam_opacity : hint_range(0.0, 1.0) = 0.7;

// Boat Tracker
uniform vec2 uv_offset = vec2(0.0, 5.0);

// Wave Math
uniform float wave_frequency = 3.0;
uniform float wave_speed = 5.0;
uniform float max_radius = 10.0;

// --- NEW: Randomization Controls ---
uniform float noise_scale = 1.5;             // Size of the random ripples
uniform float distortion_strength = 0.5;     // How wobbly the rings become
uniform float breakup_strength : hint_range(0.0, 1.5) = 0.8; // How much the foam tears apart

varying vec2 world_pos;

// --- PROCEDURAL 2D NOISE GENERATOR ---
// This creates smooth, randomized cloudy patterns purely through math
vec2 random2(vec2 p) {
    return fract(sin(vec2(dot(p, vec2(127.1, 311.7)), dot(p, vec2(269.5, 183.3)))) * 43758.5453);
}

float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(mix(dot(random2(i + vec2(0.0, 0.0)), f - vec2(0.0, 0.0)),
                   dot(random2(i + vec2(1.0, 0.0)), f - vec2(1.0, 0.0)), u.x),
               mix(dot(random2(i + vec2(0.0, 1.0)), f - vec2(0.0, 1.0)),
                   dot(random2(i + vec2(1.0, 1.0)), f - vec2(1.0, 1.0)), u.x), u.y);
}
// -------------------------------------

void fragment() {
	vec4 main_texture = texture(TEXTURE, UV);
	vec2 new_uv = UV + uv_offset;

	// 1. GENERATE THE NOISE MAP
    // We add TIME so the noise pattern slowly "boils" and shifts over the water
	float organic_noise = noise(new_uv * noise_scale + (TIME * 0.2));

	// 2. DISTORT THE DISTANCE
    // This pushes the exact circular distance in random directions, making them wobbly
	float wobbly_dist = length(new_uv) + organic_noise * distortion_strength;

	// 3. APPLY TO WAVE MATH
	float wave_math = sin((wobbly_dist * wave_frequency) - (TIME * wave_speed));

	// 4. BREAK UP THE RINGS
    // Instead of a flat threshold (0.8), we subtract noise to tear holes in the foam
	float threshold = 0.8 + (organic_noise * breakup_strength);
	float sharp_foam = step(threshold, wave_math);

	// 5. FADE OUT DISTANCE
	float radius_mask = smoothstep(max_radius * 0.5, max_radius, length(new_uv));
	float final_foam_mask = sharp_foam * radius_mask;

	float lightness = length(main_texture.rgb);
	float final_mask = (final_foam_mask * foam_opacity * lightness) * main_texture.a;

	COLOR = mix(COLOR, water_color * main_texture.a, water_opacity);
	COLOR = mix(COLOR, foam_color, final_mask);
}