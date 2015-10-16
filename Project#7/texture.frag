uniform sampler2D uTexUnit;

varying vec2	vST;

void
main( )
{
	vec3 newcolor = texture2D( uTexUnit, vST ).rgb;
	gl_FragColor = vec4( newcolor.rgb, 1. );
}
