uniform vec2 uResolution;
uniform float uSize;
uniform sampler2D uParticlesTexture;
attribute vec2 aParticlesUv;
attribute float aSize; // random sizes (set in the for loop)

varying vec3 vPosition;
varying vec3 vColor;


uniform vec3 uColor1;
uniform vec3 uColor2;
uniform vec3 uColor3;

void main()
{
    vec4 particle = texture(uParticlesTexture, aParticlesUv);

    // Final position
    vec4 modelPosition = modelMatrix * vec4(particle.xyz, 1.0);
    vec4 viewPosition = viewMatrix * modelPosition;
    vec4 projectedPosition = projectionMatrix * viewPosition;
    gl_Position = projectedPosition;

    // Point size
    float sizeIn = smoothstep(0.0, 0.1, particle.a); 
    float sizeOut = 1.0 - smoothstep(0.7, 1.0, particle.a); 
    float size = min(sizeIn, sizeOut);

    gl_PointSize = size * aSize * uSize * uResolution.y;
    gl_PointSize *= (1.0 / - viewPosition.z);

	// Color
    vec3 color = vec3(1.0, 0.1, 0.9);
    float depth = (modelPosition.y + 1.0) * 0.5; 
   
    if (depth <= 0.5) {
        color = mix(uColor1, uColor2, depth * 2.0); 
    } else {
        color = mix(uColor2, uColor3, (depth - 0.5) * 1.8); 
    }

    // Varyings
    vColor = color;
}