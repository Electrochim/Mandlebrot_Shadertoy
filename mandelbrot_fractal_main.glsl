// mandlebrot set fractal
// f(z) = z² + c
// so for shader (x, y) = 

const vec2 camera_offset_1 = vec2(-0.1632, -1.0328F);

const vec2 camera_offset = camera_offset_1;

const int REPEATS = 300;
const float MAX_DIST = 5.0F;

const vec3 colors = vec3(0.2, 0.1, 0.3);
const float brightness = 1.3F;


vec2 mandelbrot (vec2 c) {
    vec2 z = vec2(0.0F, 0.0F);

    for (int repeats = REPEATS; repeats > 0; repeats--) {
        float next_x = (z.x * z.x) - (z.y * z.y) + c.x;
        float next_y = (2.0F * z.x * z.y) + c.y;
        
        z = vec2(next_x, next_y);
        
        float distance = sqrt(next_x * next_x + next_y * next_y);
        
        if (distance > MAX_DIST) return sqrt(z);
    }
    
    return sqrt(z);
}

vec3 mandelbrot_colors (vec2 c) {
    vec2 z = vec2(0.0F, 0.0F);

    for (int repeats = REPEATS; repeats > 0; repeats--) {
        float next_x = (z.x * z.x) - (z.y * z.y) + c.x;
        float next_y = (2.0F * z.x * z.y) + c.y;
        
        z = vec2(next_x, next_y);
        
        float distance = sqrt(next_x * next_x + next_y * next_y);
        
        if (distance > MAX_DIST) return vec3(float(repeats) / float(REPEATS));
    }
    
    return vec3(0.0F, 0.0F, 0.0F);
}

void mainImage (out vec4 fragColor, in vec2 fragCoord)
{
    // Normalized pixel coordinates (from 0 to 2 with 0, 0 at center of screen)
    vec2 uv = (fragCoord - 0.5F * iResolution.xy) / iResolution.y;
    
    // zoom pixel coords based on time
    vec2 uv_t = (uv * 2.0F) / exp(iTime * 1.5F - 1.5F) + camera_offset;

    vec2 fractal = mandelbrot(uv_t);
    vec3 mandelbrot_col = mandelbrot_colors(uv_t);
    
    vec3 col = vec3(
        mandelbrot_col.x * fractal.x,
        mandelbrot_col.y * fractal.y,
        mandelbrot_col.z
    ) * colors * brightness;

    // Output to screen
    fragColor = vec4(col, 1.0F);
}
