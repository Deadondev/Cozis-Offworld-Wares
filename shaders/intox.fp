void main()
{
	vec2 coord = TexCoord;
	vec2 px = vec2(1.0 / res_w, 1.0 / res_h);

	vec2 nc;
	vec4 sum = vec4(0, 0, 0, 0);

	for(int x = -radius; x <= radius; ++x)
	{
		for(int y = -radius; y <= radius; ++y)
		{
			nc = vec2(coord.x + px.x * x, coord.y + px.y * y);
			sum += texture(InputTexture, nc);
		}
	}

	sum /= pow(float(radius) * 2 + 1, float(2));

	FragColor = sum;
}
