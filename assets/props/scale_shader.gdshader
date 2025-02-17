shader_type spatial;
render_mode unshaded;

uniform vec4 albedo : source_color;
uniform sampler2D texture_albedo : source_color, filter_linear_mipmap, repeat_enable;

uniform float roughness : hint_range(0.0, 1.0);
uniform float specular : hint_range(0.0, 1.0, 0.01);
uniform float metallic : hint_range(0.0, 1.0, 0.01);
uniform vec2 texture_size = vec2(1.0, 1.0);

void vertex() {
	UV = VERTEX.xz*1.0/texture_size;
}

void fragment() {
	vec2 base_uv = UV;

	vec4 albedo_tex = texture(texture_albedo, base_uv);
	ALBEDO = albedo.rgb * albedo_tex.rgb;

	METALLIC = metallic;
	SPECULAR = specular;

	ROUGHNESS = roughness;
	ALPHA *= albedo.a * albedo_tex.a;
}
