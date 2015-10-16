surface
ovals( float
		Ar = 0.05,
		Br = 0.02,
		Ks = 0.5,
		Kd = 0.5, 
		Ka = .1, 
		roughness = 0.1;
	color specularColor = color( 1, 1, 1 )
)
{
		float up = 2. * u;
		float vp = v;
		
		//float numinu = floor( up / Diam );
		//float numinv = floor( vp / Diam );

		float numinu = floor( up / (2.*Ar) );
		float numinv = floor( vp / (2.*Br) );

		color dotColor = Cs;
		if( mod( numinu+numinv, 2) == 0 )
		{
			//float uc = numinu*Diam + Diam/2.;
			//float vc = numinv*Diam + Diam/2.;
			float uc = numinu*2.*Ar + Ar;
			float vc = numinv*2.*Br + Br;

			up = up - uc;
			vp = vp - vc;
			
			float ellipse=(up/Ar)*(up/Ar) + (vp/Br)*(vp/Br);
			point upvp = point( up, vp, 0. );
			point cntr = point( 0., 0., 0. );
			if( ellipse<=1)
			{
				dotColor = color( 1., .5, 0.0 ); // beaver orange?
			}
		}
		varying vector Nf = faceforward( normalize( N ), I );
		vector V = normalize( -I );
		Oi = 0.9;
		Ci = Oi * ( dotColor * ( Ka * ambient() + Kd * diffuse(Nf) ) +
		specularColor * Ks * specular( Nf, V, roughness ) );
}