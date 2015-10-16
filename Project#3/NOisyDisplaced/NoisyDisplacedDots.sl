displacement
ovald( 
float
Ks = 0.5,
Kd = 0.5, 
Ka = .1, 
Ar = 0.025,
Br = 0.10,
height = 0.2 ,
Ramp   = 0.30,				// fraction of square used for the ramp
roughness = 0.1;
color specularColor = color( 1, 1, 1 )
)

{


float up =  2 * u;
float vp =  v;
float TheHeight = 0.0 ;

float numinu =  floor( up / (2*Ar) );
float numinv =  floor( vp / (2*Br) );


if( mod( numinu+numinv, 2 ) == 0 )
{


// noise magnitude
point PP = point "shader" P;
float magnitude = 0.;
float size = 1.;
float i;
for( i = 0.; i < 6.0; i += 1.0 )
{
magnitude += ( noise( size * PP ) - 0.5 ) / size;
size *= 2.0;
}

float uc = numinu * 2.*Ar + Ar;
float vc = numinv * 2.*Br + Br;
up = up - uc;
vp = vp - vc;

point upvp = point( up, vp, 0. );
point cntr = point( 0., 0., 0. );
vector delta = upvp - cntr;


float oldrad = length(delta);
float newrad = oldrad + 0.5*magnitude;
delta = delta * newrad / oldrad;
float len = length(delta);




float deltau = xcomp(delta) ;
float deltav = ycomp(delta);


up = deltau;
vp = deltav ;

upvp = point( up, vp, 0. );


float ellipseEquation=(up/Ar)*(up/Ar) + (vp/Br)*(vp/Br);		
if (ellipseEquation<= 1)
{

	TheHeight = height-ellipseEquation*height ;
	float t = smoothstep( 0., Ramp, height );	   
// 0. if dist <= 0., 1. if dist >= Ramp
		
	TheHeight = t*TheHeight ;			   // apply the blending
}


}

//#define DISPLACEMENT_MAPPING
if( TheHeight != 0. )
{
	#ifdef DISPLACEMENT_MAPPING
	P= P + normalize(N) * TheHeight;
	N = calculatenormal(P);
	#else
	N = calculatenormal( P+ normalize(N) * TheHeight );
	#endif
}

varying vector Nf = faceforward( normalize( N ), I );
vector V = normalize( -I );

}