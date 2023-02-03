// Updated handler (3/26/22) for edge-case desyncs. Thanks Cali, Phantom, & FDA.

class UaS_AlcoholEventHandler : StaticEventHandler {
    override void WorldTick()
	{
        let shouldEnable = false;
		bool enableshader = false;
        if(playeringame[consoleplayer]) {
            PlayerInfo player = players[consoleplayer];
            
			Actor playerCam = player.mo;
            
			if(player.camera)
                playerCam = player.camera;

            if(playerCam)
                enableShader = playerCam.countInv("UasAlcohol_IntoxToken") >= UasAlcohol_IntoxToken.min_effect_amt;
        }
        Shader.SetEnabled(players[consoleplayer], "UASAlcohol_Intoxication", enableShader);
        //PPShader.SetEnabled("UASAlcohol_Intoxication", enableShader);
    }
}