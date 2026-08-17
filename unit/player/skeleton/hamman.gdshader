shader_type canvas_item;

instance uniform float strength : hint_range(0.0, 0.2) = 0.1;
instance uniform vec2 direction = vec2(0.0, 0.0);
uniform int samples : hint_range(4, 32) = 4;

void fragment() {
    vec2 dir = vec2(1.0,-1.0)*normalize(direction) * strength;
    vec4 color = vec4(0.0);
    float total_weight = 0.0;
    
    for (int i = 0; i < samples; i++) {
        float t = float(i) / float(samples - 1) - 0.5;
        vec2 uv = UV + dir * t;
        vec4 sample_color = texture(TEXTURE, uv);
        
        // 根据 Alpha 值加权累加，避免透明部分把颜色拽黑
        float weight = sample_color.a;
        color += sample_color * weight;
        total_weight += weight;
    }
    
    // 如果总权重为 0，直接返回完全透明
    if (total_weight < 0.001) {
        COLOR = vec4(0.0);
    } else {
        COLOR = color / total_weight;
        // 保证 Alpha 值不缩水
        COLOR.a = max(color.a / total_weight, 0.0);
    }
}