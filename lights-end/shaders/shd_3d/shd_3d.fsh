//
// Simple passthrough fragment shader
//

varying vec3 v_vPosition;
varying vec3 v_vNormal;
varying vec4 v_vColour;
varying vec2 v_vTexcoord;

uniform vec3 u_campos;
uniform vec4 u_lightpos;

//[0.216667, -0.666667, 0.713170]
const vec3 u_lightdir = vec3(0.21666, -0.667, 0.713);

// [0.600000, 0.300000, 1.000000, 1.000000]
const vec3 BURNCOLOR = vec3(0.6, 0.3, 1.0);

// Blender's version of color burn
vec3 ColorBurn(vec3 B, vec3 A, float fac)
{
	// return max(vec3(0.0), 1.0-((1.0-B)/A)) * fac + B * (1.0-fac); // Used in image editors like Photoshop
	return max(vec3(0.0), 1.0-((1.0-B)) / ( (1.0-fac) + (fac*A) ) ); // Used in Blender
}

void main()
{
	gl_FragColor = v_vColour * texture2D(gm_BaseTexture, v_vTexcoord);
	
	if (gl_FragColor.a <= 0.01) {discard;}
	
	float dp = dot(v_vNormal, normalize(u_lightdir));
	dp = max(dp, 0.0);
	dp /= distance(u_lightpos.xyz, v_vPosition.xyz)/200.0;
	dp = min(pow(dp*u_lightpos.w, 0.1), 1.0);
	
	//dp = max(0.0, 1.0-dp);
	
	//dp *= pow(mix(0.0, 1.2, distance(u_lightpos.xyz, vec3(v_vPosition.xy, 0.0))/3000.0), 1.5);
	//dp = min((1.0-u_lightpos.w)*dp, 1.0);
	//dp = float(int(dp*5.0))/5.0;
	//dp = max(dp, 0.0);
	
	vec3 colorburned = ColorBurn(gl_FragColor.rgb, BURNCOLOR, 1.0);
	gl_FragColor.rgb = mix(colorburned, gl_FragColor.rgb, dp);
	//gl_FragColor.rgb = vec3(dp);
	
	const float s = 64.0;
	gl_FragColor.r = float(int(gl_FragColor.r*s))/s;
	gl_FragColor.g = float(int(gl_FragColor.g*s))/s;
	gl_FragColor.b = float(int(gl_FragColor.b*s))/s;
}
