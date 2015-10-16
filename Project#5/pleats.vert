#version 330 compatibility

uniform float uK, uP;
uniform float uLightAlongX, uLightAlongY, uLightAlongZ;
uniform float uKa, uKd, uKs;
uniform vec4  uColor;
uniform vec4  uSpecularColor;
uniform float uShininess;

flat out vec3 vNormalfrag;
flat out vec3 vLightfrag;
flat out vec3 vEyefrag;
flat out vec3 vPerVertexfrag;

out  vec3 vMC;

const float PI = 3.14159265;
const float Y0 = 1.;

void
main( )
{
	
	vec3 Normal;
	vec3 Light;
	vec3 Eye;
	
	vMC = aVertex.xyz;
	vec4 V = aVertex;
	V.z = uK * (Y0-V.y) * sin( 2.*PI*V.x/uP );

	vec4 ECposition = uModelViewMatrix * V;
	vec3 eyePositionforLight = vec3( uLightAlongX, uLightAlongY, uLightAlongZ );

	float dzdx = uK * (Y0-V.y) * (2.*PI/uP) * cos( 2.*PI*V.x/uP );
	vec3 Tx = vec3( 1., 0., dzdx );

	float dzdy = -uK * sin( 2.*PI*V.x/uP );
	vec3 Ty = vec3( 0., 1., dzdy );

	vec3 newNormal = normalize(  cross( Tx, Ty )  );

	vNormalfrag = newNormal;
	vLightfrag = eyePositionforLight - ECposition.xyz;	
	vEyefrag = vec3( 0., 0., 0. ) - ECposition.xyz;		


	Normal = normalize(vNormalfrag);
	Light =  normalize(vLightfrag);
	Eye =    normalize(vEyefrag);


	vec4 ambientLight = uKa * uColor;

	float d = max( dot(Normal,Light), 0. );
	vec4 diffuseLight = uKd * d * uColor;

	float s = 0.;
	if( dot(Normal,Light) > 0. )		
	{
		vec3 ref = normalize( 2. * Normal * dot(Normal,Light) - Light );
		s = pow( max( dot(Eye,ref),0. ), uShininess );
	}
	vec4 specularLight = uKs * s * uSpecularColor;
	vPerVertexfrag = ambientLight.rgb + diffuseLight.rgb + specularLight.rgb;
	gl_Position = uModelViewProjectionMatrix * V;
}
