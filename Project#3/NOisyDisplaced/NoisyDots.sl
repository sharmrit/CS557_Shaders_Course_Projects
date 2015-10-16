surface
ovals( 
float
Ks = 0.5,
Kd = 0.5, 
Ka = .1, 
Ar = 0.25,
Br = 0.10,
height = 0.2 ,
roughness = 0.1;
color specularColor = color( 0, 0, 1 )
)

{


float up =  2 * u;
float vp =  v;
float TheHeight = 0.0 ;

float numinu =  floor( up / (2*Ar) );
float numinv =  floor( vp / (2*Br) );

color dotColor = Cs;

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
float newrad = oldrad + 0.8*magnitude;
delta = delta * newrad / oldrad;

float deltau = xcomp(delta) ;
float deltav = ycomp(delta);


up = deltau;
vp = deltav ;


float ellipseEquation=(up/Ar)*(up/Ar) + (vp/Br)*(vp/Br);
if ( ellipseEquation <= 1)
{

	//if(ellipseEquation >0.1)
	//{
	//	dotColor = color( 0., 1., 0. ); // green
		
	//}
	//else if(ellipseEquation >0.01 && ellipseEquation < 0.1)
	//{
	dotColor = color( 1., .5, 0. ); // beaver orange?
	//}

	//else if(ellipseEquation >0.0)
	//{
	//	dotColor = color( 1., 1., 1. ); // white
	//}



}


}

varying vector Nf = faceforward( normalize( N ), I );
vector V = normalize( -I );

Oi =1;
		Ci = Oi * ( dotColor * ( Ka * ambient() + Kd * diffuse(Nf) ) +
		specularColor * Ks * specular( Nf, V, roughness ) );
}