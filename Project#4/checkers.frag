#version 330 compatibility

in vec4  vColor;
in float vLightIntensity;
in vec2  vST;
in vec3 vMCposition ;

uniform float uAd;
uniform float uBd;
uniform float uNoiseAmp;
uniform float uNoiseFreq;
uniform float uTol;
uniform vec4  uOvalColor;
uniform bool uUseDiscard;
uniform float uAlpha;

uniform sampler3D Noise3;


void
main( )
{
	float s = vST.s;
	float t = vST.t;
	float sp = 2. * s;		// good for spheres
	float tp = t;
	float numins = int( sp /uAd );
	float numint = int( tp /uBd );

	gl_FragColor = vColor;		// default color

	
	if( 1>0 )
	{

	float scenter = numins*uAd + uAd*0.5;
	float tcenter = numint*uBd + uBd*0.5;
	
	sp = sp - scenter;
	tp = tp - tcenter;
	
	vec3 upvp = vec3( sp, tp, 0. );
	vec3 cntr = vec3( 0., 0., 0. );
	vec3 delta = upvp - cntr;
	
	//  noise addition
	
	vec4  nv  = texture3D( Noise3, uNoiseFreq * vMCposition );
	float n = nv.r + nv.g + nv.b + nv.a;	// 1. -> 3.
	n = ( n - 2. );				// -1. -> 1.

	float oldrad = length(delta);
	float newrad = oldrad + (n*uNoiseAmp);
	delta = delta * newrad / oldrad;		
			
	float deltau = delta.x ;
	float deltav = delta.y;

	sp = deltau;
	tp = deltav ;
	

	float ellipseEquation=(2*sp/(uAd))*(2*sp/(uAd)) + (2*tp/(uBd))*(2*tp/(uBd));
	
	float t = smoothstep( 1-uTol, 1+uTol, ellipseEquation );
	gl_FragColor = mix( uOvalColor, vColor, t );
	
			
	if (ellipseEquation<= 1)
	{

		gl_FragColor = uOvalColor;

	}
	else
	{
		if( uUseDiscard )
		{
			discard;
			//MessageBox "This implements the Alpha extra credit";
		}
		else
		{
			gl_FragColor = vec4( 1, 1, 0, uAlpha );
		}
	}
	
	
	}
	
	gl_FragColor.rgb *= vLightIntensity;	// apply lighting model
	
}