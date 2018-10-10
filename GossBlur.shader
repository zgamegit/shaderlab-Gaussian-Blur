Shader "Zgame/PostEffect/GaussianBlur"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100

		Pass
		{
			
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv[9] : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			v2f vert (appdata v)
			{
				float2 offset[9]={float2(-1,1),float2(0,1),float2(1,1),
								  float2(-1,0),float2(0,0),float2(1,0),
								  float2(-1,-1),float2(0,-1),float2(1,-1)};
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				for(int i=0;i<9;i++)
				{
					o.uv[i]=v.uv+offset[i]*_MainTex_TexelSize.xy;
				}
				//o.uv =v.uv;
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				float gaussian[9]={0.0947416,0.118318,0.0947416,0.118318,0.147761,0.118318,0.0947416,0.118318,0.0947416};
				// sample the texture
				fixed4 col = fixed4(0,0,0,0);
				for(int off=0;off<9;off++)
				{
					col+=tex2D(_MainTex,i.uv[off])*gaussian[off];
				}
				return col;
			}
			ENDCG
		}
	}
}
